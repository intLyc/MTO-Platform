%% Basic Generative Adversarial Network
%% Load Data

function [output, paramsGen, stGen, paramsDis, stDis] = InitialGAN(tdata, fdata, lrD, lrG, BS)
trainX = preprocess(tdata);
dim = size(trainX, 1);
noise_data = fdata(:, randperm(size(fdata, 2)));
%% Settings
settings.noise = noise_data;
settings.dim = dim;
settings.latent_dim = dim;
settings.batch_size = BS; settings.image_size = [dim, 1, 1];
settings.lrD = lrD; settings.lrG = lrG; settings.beta1 = 0.7;
settings.beta2 = 0.9; settings.maxepochs = 20;

%% Initialization
%% Generator
paramsGen.FCW1 = dlarray( ...
    initializeGaussian([settings.latent_dim, settings.latent_dim], .03));
paramsGen.FCb1 = dlarray(zeros(settings.latent_dim, 1, 'single'));
paramsGen.BNo1 = dlarray(zeros(settings.latent_dim, 1, 'single'));
paramsGen.BNs1 = dlarray(ones(settings.latent_dim, 1, 'single'));
paramsGen.FCW2 = dlarray(initializeGaussian([settings.latent_dim, settings.latent_dim]));
paramsGen.FCb2 = dlarray(zeros(settings.latent_dim, 1, 'single'));
paramsGen.BNo2 = dlarray(zeros(settings.latent_dim, 1, 'single'));
paramsGen.BNs2 = dlarray(ones(settings.latent_dim, 1, 'single'));
paramsGen.FCW4 = dlarray(initializeGaussian( ...
    [prod(settings.image_size), settings.latent_dim]));
paramsGen.FCb4 = dlarray(zeros(prod(settings.image_size) ...
    , 1, 'single'));

stGen.BN1 = []; stGen.BN2 = []; stGen.BN3 = [];

%% Discriminator
paramsDis.FCW1 = dlarray(initializeGaussian([settings.latent_dim, ...
        prod(settings.image_size)], .03));
paramsDis.FCb1 = dlarray(zeros(settings.latent_dim, 1, 'single'));
paramsDis.BNo1 = dlarray(zeros(settings.latent_dim, 1, 'single'));
paramsDis.BNs1 = dlarray(ones(settings.latent_dim, 1, 'single'));
paramsDis.FCW4 = dlarray(initializeGaussian([1, settings.latent_dim]));
paramsDis.FCb4 = dlarray(zeros(1, 1, 'single'));

stDis.BN1 = []; stDis.BN2 = [];

avgG.Dis = []; avgGS.Dis = []; avgG.Gen = []; avgGS.Gen = [];
%% Train
numIterations = floor(size(trainX, 2) / settings.batch_size);
out = false; epoch = 0; global_iter = 0;
while ~out
    tic;
    trainXshuffle = trainX(:, randperm(size(trainX, 2)));
    for i = 1:numIterations
        global_iter = global_iter + 1;
        idx = (i - 1) * settings.batch_size + 1:i * settings.batch_size;
        XBatch = gpdl(single(trainXshuffle(:, idx)), 'CB');
        noise = gpdl(single(noise_data(:, idx)), 'CB');
        [GradGen, GradDis, stGen, stDis] = ...
            dlfeval(@modelGradients, XBatch, noise, ...
            paramsGen, paramsDis, stGen, stDis);
        [paramsDis, avgG.Dis, avgGS.Dis] = ...
            adamupdate(paramsDis, GradDis, ...
            avgG.Dis, avgGS.Dis, global_iter, ...
            settings.lrD, settings.beta1, settings.beta2);
        [paramsGen, avgG.Gen, avgGS.Gen] = ...
            adamupdate(paramsGen, GradGen, ...
            avgG.Gen, avgGS.Gen, global_iter, ...
            settings.lrG, settings.beta1, settings.beta2);

    end
    epoch = epoch + 1;
    if epoch == settings.maxepochs
        out = true;
        output = progressplot(paramsGen, stGen, settings);
    end
end
%% Helper Functions
%% preprocess
function x = preprocess(x)
    dim = size(x, 1);
    x = reshape(x, dim, []);
end
%% extract data
function x = gatext(x)
    x = gather(extractdata(x));
end
%% gpu dl array wrapper
function dlx = gpdl(x, labels)
    dlx = gpuArray(dlarray(x, labels));
end
%% Weight initialization
function parameter = initializeGaussian(parameterSize, sigma)
    if nargin < 2
        sigma = 0.06;
    end
    parameter = randn(parameterSize, 'single') .* sigma;
end
%% Generator
function [dly, st] = Generator(dlx, params, st)
    % fully connected
    %1
    dly = fullyconnect(dlx, params.FCW1, params.FCb1);
    dly = leakyrelu(dly, 0.5);
    if isempty(st.BN1)
        [dly, st.BN1.mu, st.BN1.sig] = batchnorm(dly, params.BNo1, params.BNs1);
    else
        st.BN1.sig(st.BN1.sig < 0) = -st.BN1.sig(st.BN1.sig < 0);
        [dly, st.BN1.mu, st.BN1.sig] = batchnorm(dly, params.BNo1, ...
            params.BNs1, st.BN1.mu, st.BN1.sig);
    end
    %2
    dly = fullyconnect(dly, params.FCW2, params.FCb2);
    dly = leakyrelu(dly, 0.5);
    if isempty(st.BN2)
        [dly, st.BN2.mu, st.BN2.sig] = batchnorm(dly, params.BNo2, params.BNs2);
    else
        st.BN2.sig(st.BN2.sig < 0) = -st.BN2.sig(st.BN2.sig < 0);
        [dly, st.BN2.mu, st.BN2.sig] = batchnorm(dly, params.BNo2, ...
            params.BNs2, st.BN2.mu, st.BN2.sig);
    end
    %4
    dly = fullyconnect(dly, params.FCW4, params.FCb4);
    dly = sigmoid(dly);
end
%% Discriminator
function [dly, st] = Discriminator(dlx, params, st)
    % fully connected
    %1
    dly = fullyconnect(dlx, params.FCW1, params.FCb1);
    dly = leakyrelu(dly, 0.5);
    dly = dropout(dly);
    if isempty(st.BN1)
        [dly, st.BN1.mu, st.BN1.sig] = batchnorm(dly, params.BNo1, params.BNs1);
    else
        st.BN1.sig(st.BN1.sig < 0) = -st.BN1.sig(st.BN1.sig < 0);
        [dly, st.BN1.mu, st.BN1.sig] = batchnorm(dly, params.BNo1, ...
            params.BNs1, st.BN1.mu, st.BN1.sig);
    end
    %4
    dly = fullyconnect(dly, params.FCW4, params.FCb4);
    dly = sigmoid(dly);
end
%% modelGradients
function [GradGen, GradDis, stGen, stDis] = modelGradients(x, z, paramsGen, ...
        paramsDis, stGen, stDis)
    [fake_images, stGen] = Generator(z, paramsGen, stGen);
    ex = extractdata(fake_images);
    d_output_real = Discriminator(x, paramsDis, stDis);
    [d_output_fake, stDis] = Discriminator(fake_images, paramsDis, stDis);

    d_loss = -mean(.9 * log(d_output_real + eps) + log(1 - d_output_fake + eps));
    g_loss = -mean(log(d_output_fake + eps));

    GradGen = dlgradient(g_loss, paramsGen, 'RetainData', true);
    GradDis = dlgradient(d_loss, paramsDis);
end
%% progressplot
function gen_imgs = progressplot(paramsGen, stGen, settings)
    noise = gpdl(settings.noise, 'CB');
    gen_imgs = Generator(noise, paramsGen, stGen);
    gen_imgs = reshape(gen_imgs, settings.dim, []);
    gen_imgs = extractdata(gen_imgs);
end
%% dropout
function dly = dropout(dlx, p)
    if nargin < 2
        p = .5;
    end

    n = p * 10;
    mask = randi([1, 10], size(dlx));
    mask(mask <= n) = 0;
    mask(mask > n) = 1;
    dly = dlx .* mask;

end
end
