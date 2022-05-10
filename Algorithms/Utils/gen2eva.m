function converge_eva = gen2eva(converge_gen, varargin)
    %% Map the convergence from generation to evaluation
    % Input: converge_gen, eva_gen, converge_num
    % Output: converge_eva

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    converge_num = 200;

    n = numel(varargin);
    if n == 0
        eva_gen = repmat(1:length(converge_gen), [size(converge_gen) 1]);
    elseif n == 1
        eva_gen = varargin{1};
    elseif n == 2
        eva_gen = varargin{1};
        converge_num = varargin{2};
    end

    if length(converge_gen) <= converge_num
        converge_eva = converge_gen;
        return;
    end

    converge_eva = nan(size(converge_gen, 1), converge_num);
    for k = 1:size(converge_gen, 1)
        eva_gap = eva_gen(k, end) ./ (converge_num);
        idx = 1;
        i = 1;
        while i <= length(eva_gen)
            if eva_gen(k, i) >= ((idx) * eva_gap)
                converge_eva(k, idx) = converge_gen(k, i);
                idx = idx + 1;
            else
                i = i + 1;
            end
            if idx > converge_num
                break;
            end
        end
        converge_eva(k, 1) = converge_gen(k, 1);
        converge_eva(k, end) = converge_gen(k, end);
        if idx - 1 < length(converge_num)
            converge_eva(k, idx - 1:end) = converge_gen(k, end);
        end
    end
end
