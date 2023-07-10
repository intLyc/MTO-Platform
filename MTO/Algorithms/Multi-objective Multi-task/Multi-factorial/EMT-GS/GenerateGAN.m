%% Generator
function [dly, st] = GenerateGAN(dlx, params, st)
dlx = dlarray(dlx, 'CB');
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
dly = extractdata(dly);
end
