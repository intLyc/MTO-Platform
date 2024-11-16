classdef SplitMeanLogVarLayer < nnet.layer.Layer
properties (Learnable)
    % Layer learnable parameters
end

methods
    function layer = SplitMeanLogVarLayer(name)
        layer.Name = name;
        layer.Description = "SplitMeanLogVar Layer";
    end

    function [zMean, zLogvar] = predict(layer, Z)
        zMean = Z(:, :);
        zMean(:, end) = 0;
        zLogvar = Z(:, :);
        zLogvar(:, size(Z, 2) / 2) = 0;

    end
end
end
