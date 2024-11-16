classdef MyVAE < handle
properties
    inputSizeX1
    inputSizeX2
    hiddenSize
    latentSize
    ReparametrizationLayer
    encoder
    decoder
    net
    trainOpts
    optimizer
    iterationFcn
    t = 0
    numEpochs
    batchSize
    temperature
    SplitMeanLogVar
end

methods
    function obj = MyVAE(inputSizeX1, inputSizeX2, hiddenSize, latentSize)
        obj.inputSizeX1 = inputSizeX1;
        obj.inputSizeX2 = inputSizeX2;
        obj.hiddenSize = hiddenSize;
        obj.latentSize = latentSize;
        obj.temperature = 0.1;
        obj.trainOpts = struct( ...
            'Verbose', true, ...
            'Plots', 'training-progress', ...
            'ExecutionEnvironment', 'cpu', ...
            'DispatchInBackground', true);
        obj.iterationFcn = @(net, gradients, state, t, iteration)obj.adamUpdateWithParams(net, gradients, state, t, iteration);
        obj.optimizer = 'adam';
        obj.numEpochs = 5;
        obj.batchSize = 20;

        % 创建编码器层
        obj.encoder = [
            sequenceInputLayer(obj.inputSizeX1, 'Name', 'input')
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_1')
            reluLayer('Name', 'reluLayer_1')
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_2')
            reluLayer('Name', 'reluLayer_2')
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_3')
            reluLayer('Name', 'reluLayer_3')
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_4')
            sigmoidLayer('Name', 'sigmoidLayer_1')
            fullyConnectedLayer(latentSize, 'Name', 'zMean')
            fullyConnectedLayer(latentSize, 'Name', 'zLogVar')
            ];

        obj.ReparametrizationLayer = VaeReparametrizationLayer('reparametrization');
        obj.SplitMeanLogVar = SplitMeanLogVarLayer("name");
        % 创建解码器层
        obj.decoder = [
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_7')
            reluLayer('Name', 'reluLayer_4')
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_8')
            reluLayer('Name', 'reluLayer_5')
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_9')
            reluLayer('Name', 'reluLayer_6')
            fullyConnectedLayer(hiddenSize, 'Name', 'fullyConnectedLayer_10')
            sigmoidLayer('Name', 'sigmoidLayer_2')
            fullyConnectedLayer(inputSizeX1, 'Name', 'fullyConnectedLayer_11')
            ];

        % 创建 VAE 网络
        lgraph = layerGraph(obj.encoder);
        lgraph = addLayers(lgraph, obj.ReparametrizationLayer);
        lgraph = addLayers(lgraph, obj.decoder);
        lgraph = connectLayers(lgraph, 'zMean', 'reparametrization/in1');
        lgraph = connectLayers(lgraph, 'zLogVar', 'reparametrization/in2');
        lgraph = connectLayers(lgraph, 'reparametrization', 'fullyConnectedLayer_7');
        net = dlnetwork(lgraph);
        obj.net = net;

    end

    function train(obj, X1, X2)
        % Prepare the data
        X1(end, :) = [];
        X2(end, :) = [];
        X = [X1, X2];

        % 创建 VAE 网络
        lgraph = layerGraph(obj.encoder);
        lgraph = addLayers(lgraph, obj.ReparametrizationLayer);
        lgraph = addLayers(lgraph, obj.decoder);
        lgraph = connectLayers(lgraph, 'zMean', 'reparametrization/in1');
        lgraph = connectLayers(lgraph, 'zLogVar', 'reparametrization/in2');
        lgraph = connectLayers(lgraph, 'reparametrization', 'fullyConnectedLayer_7');
        % analyzeNetwork(lgraph);
        net = dlnetwork(lgraph);
        obj.net = net;

        % Train the VAE
        X = dlarray(single(X), 'CBT');

        % 设置自定义训练循环
        numObservations = size(X, 2);
        numIterations = ceil(numObservations / obj.batchSize); %计算数据划分成多少个批次

        function [net, gradients, loss] = modelGradients(net, XBatch, latentSize)
            XBatch = dlarray(single(XBatch), 'CBT');
            zMeanLogVar = predict(net, XBatch);
            [zMean, zLogvar] = obj.SplitMeanLogVar.predict(zMeanLogVar);
            [z, klLoss] = sampling(zMean, zLogvar);
            z = dlarray(single(z), 'CBT');
            XHat = predict(net, z, 'Outputs', 'fullyConnectedLayer_11');

            % 计算 InfoNCE loss
            XHat = reshape(XHat, [size(XHat), 1]);
            Y = softmax(XHat / obj.temperature, 'DataFormat', 'CBT');
            Y = dlarray(single(Y), 'CBT');
            loss = -sum(log(Y .* XBatch + eps), 'all') / numel(Y);

            X1_sim = sum(Y(:, 1:size(XBatch, 2) / 2) .* XBatch(:, 1:size(XBatch, 2) / 2), 'all') / numel(Y(:, 1:size(XBatch, 2) / 2));
            X2_sim = sum(Y(:, size(XBatch, 2) / 2 + 1:end) .* XBatch(:, size(XBatch, 2) / 2 + 1:end), 'all') / numel(Y(:, size(XBatch, 2) / 2 + 1:end));
            gradients = dlgradient(loss, net.Learnables);
        end

        function [current_epoch_test_loss] = modelTest(net, X3, X4, latentSize)
            X3 = [X3, ones(size(X3, 1), 1)];
            X4 = [X4, 2 * ones(size(X4, 1), 1)];
            TestBatch = [X3, X4];
            TestBatch = dlarray(single(TestBatch), 'CBT');
            zMeanLogVar = predict(net, TestBatch);
            [zMean, zLogvar] = obj.SplitMeanLogVar.predict(zMeanLogVar);
            [z, klLoss] = sampling(zMean, zLogvar);

            % 调整 z 的大小以匹配输入层
            z = dlarray(single(z), 'CBT');
            XHat = predict(net, z, 'Outputs', 'fullyConnectedLayer_11');

            % 计算 InfoNCE loss
            XHat = reshape(XHat, [size(XHat), 1]);
            Y = softmax(XHat / obj.temperature, 'DataFormat', 'CBT');
            Y = dlarray(single(Y), 'CBT');
            current_epoch_test_loss = -sum(log(Y .* TestBatch + eps), 'all') / numel(Y);
        end

        function [z, klLoss] = sampling(zMean, zLogvar)
            % 从标准正态分布中抽取样本 epsilon
            epsilon = randn(size(zMean));
            zLogvar(:, 1:end - 1) = [];
            zMean(:, 1:size(zMean, 2) / 2 - 1) = [];
            zMean(:, 2:end) = [];
            z = zMean + exp(0.5 * zLogvar) .* epsilon;

            % 计算 KL 散度损失
            klLoss = -0.5 * sum(1 + zLogvar - zMean.^2 - exp(zLogvar), 'all') / numel(zMean);
        end

        % 自定义训练循环
        numLayers = numel(net.Layers);
        numLearnables = numel(net.Learnables) / 3; % 10个可学习参数

        % 初始化 state 结构体数组
        state = struct('m', cell(1, numLearnables), 'v', cell(1, numLearnables));
        for i = 1:numLearnables
            state(i).m = dlarray(zeros(size(net.Learnables.Value{i}), 'like', net.Learnables.Value{i}));
            state(i).v = dlarray(zeros(size(net.Learnables.Value{i}), 'like', net.Learnables.Value{i}));
        end

        losses = [];
        testLosses = [];
        for epoch = 1:obj.numEpochs
            for iteration = 1:numIterations
                % 按批次获取训练数据
                idx = (iteration - 1) * obj.batchSize + 1:iteration * obj.batchSize;
                XBatch = X(:, idx);

                % 评估模型梯度和损失
                [net, gradients, loss] = dlfeval(@modelGradients, net, XBatch, obj.latentSize);

                % 更新网络参数
                [net, state, obj.t] = obj.iterationFcn(net, gradients, state, obj.t, (epoch - 1) * numIterations + iteration);
                % 显示损失
                if any(isinf(gather(extractdata(loss)))) %|| any(isinf(gather(extractdata(current_epoch_test_loss))))
                    %fprintf('Loss is -inf. Stopping training.\n');
                    break;
                else
                    %fprintf('Epoch: %d, Iteration: %d, Loss: %f\n', epoch, iteration, double(gather(extractdata(loss))));
                    [current_epoch_test_loss] = dlfeval(@modelTest, net, X1, X2, obj.latentSize);
                    %fprintf('Epoch: %d, Iteration: %d, [testLoss]: %f\n', epoch, iteration, double(gather(extractdata(current_epoch_test_loss))));
                end

                losses = [losses, double(gather(extractdata(loss)))];
                testLosses = [testLosses, double(gather(extractdata(current_epoch_test_loss)))];
            end
            if any(isinf(gather(extractdata(loss)))) || any(isinf(double(extractdata(current_epoch_test_loss))))
                break;
            end
        end
    end

    function saveVAENetwork(obj, filename)
        net = obj.net;
        save(filename, 'net');
    end

    function dLdX = combineMeanLogVar(obj, dLdZ)
        dLdX = permute(dLdZ, [4 1 2 3]);
    end

    function z = encode(obj, x1, x2)
        x = [x1, x2];
        x(end, :) = [];
        x = dlarray(single(x), 'CBT');
        zMeanLogVar = predict(obj.net, x);
        zMean = zMeanLogVar(:, 1:size(x, 2) / 2);
        zLogVar = zMeanLogVar(:, size(x, 2) / 2 + 1:end);
        z = obj.ReparametrizationLayer(1).predict(zMean, zLogVar);
    end

    function [x1, x2] = decode(obj, z)
        z = dlarray(single(z), 'CBT');
        x = predict(obj.net, z, 'Outputs', 'fullyConnectedLayer_11');
        x = double(gather(x));
        x1 = x(:, 1:floor(size(x, 2) / 2));
        x2 = x(:, floor(size(x, 2) / 2) + 1:end);
    end

    function [net, state, t] = adamUpdateWithParams(obj, net, gradients, state, t, iteration)
        learnRate = 0.0001;
        beta1 = 0.9;
        beta2 = 0.999;
        epsilon = 1e-8;
        gradClipValue = 1;

        numLearnables = numel(state);

        for i = 1:numLearnables
            if size(state(i).m) ~= size(gradients.Value{i})
                disp("Mismatch in size for state(" + i + ").m and gradients.Value{" + i + "}");
                disp("Size of state(i).m: " + size(state(i).m));
                disp("Size of gradients.Value{i}: " + size(gradients.Value{i}));
            else
                % 梯度裁剪
                gradients.Value{i} = max(min(gradients.Value{i}, gradClipValue), -gradClipValue);

                state(i).m = beta1 * state(i).m + (1 - beta1) * gradients.Value{i}; % 动量m
                state(i).v = beta2 * state(i).v + (1 - beta2) * (gradients.Value{i} .* gradients.Value{i}); % 速度v
                mhat = state(i).m / (1 - beta1^obj.t);
                vhat = state(i).v / (1 - beta2^obj.t);
                obj.t = obj.t + 1;
                net.Learnables.Value{i} = net.Learnables.Value{i} - learnRate * mhat ./ (sqrt(vhat) + epsilon);
            end
        end
    end

    function newIndividuals = generate(obj, X1, X2, lambda)

        % Encode the Dec, MFObj, and TaskLabel attributes
        z = obj.encode(X1, X2);

        % Decode the shared latent variable to generate new individuals for each task
        [new_X1, new_X2] = obj.decode(z * lambda);
        new_X1 = [new_X1; ones(1, size(new_X1, 2))];
        new_X2 = [new_X2; 2 * ones(1, size(new_X2, 2))];
        newIndividuals = [new_X1, new_X2];

        % Separate the Dec, MFObj, and TaskLabel attributes
        numIndividuals = size(newIndividuals, 2);
        new_Dec = newIndividuals(1:obj.inputSizeX1 - 2, :);
        new_MFObj = newIndividuals(obj.inputSizeX1 - 1:obj.inputSizeX1, :);
        new_TaskLabel = newIndividuals(obj.inputSizeX1 + 1:end, :);

        % Process the new individuals to match the population structure
        newPopulation = repmat(Individual_MF, 1, numIndividuals);

        for i = 1:numIndividuals
            newPopulation(i).Dec = extractdata(new_Dec(:, i));
            newPopulation(i).MFObj = extractdata(new_MFObj(:, i));
            newPopulation(i).MFFactor = extractdata(new_TaskLabel(i)); % Update MFFactor with new_TaskLabel
        end
        newIndividuals = newPopulation;
    end
end
end
