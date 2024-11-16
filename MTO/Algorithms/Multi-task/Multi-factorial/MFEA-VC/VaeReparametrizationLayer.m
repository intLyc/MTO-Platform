classdef VaeReparametrizationLayer < nnet.layer.Layer

properties (Learnable)
    % Layer learnable parameters
end

methods
    function layer = VaeReparametrizationLayer(name)
        layer.Name = name;
        layer.Description = "VAE Reparametrization Layer";
        layer.NumInputs = 2;
        layer.NumOutputs = 1;
    end

    function Z = predict(layer, mu, logVar)
        epsilon = randn(size(mu), 'like', mu); % epsilon是与mu大小相同的独立且服从标准正态分布的随机数

        halfLogVar = 0.5 * logVar;
        assert(isequal(size(halfLogVar), size(logVar)), 'halfLogVar and logVar should have the same size');

        expHalfLogVar = exp(halfLogVar);
        assert(isequal(size(expHalfLogVar), size(logVar)), 'expHalfLogVar and logVar should have the same size');

        Z = mu + expHalfLogVar .* epsilon; % 重参数化公式
        assert(isequal(size(Z), size(mu)), 'Z and mu should have the same size');
    end
end
end
