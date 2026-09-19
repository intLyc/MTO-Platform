function result = ComputeWilcoxonHolm(varargin)
% Compatibility entry point. Wilcoxon retains the original unadjusted test.
result = ComputeWilcoxonTest(varargin{:});
end
