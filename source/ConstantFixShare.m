function [h, H, ws] = ConstantFixShare(l, eta, alpha)
    [T, K] = size(l);
    h = nan(T,1);
    L = zeros(1, K);
    
    ws = ones(1, K)/K;
    
    H = nan(T,1);
    for t = 1:T
        v = ws/sum(ws);
        
        
        h(t) = v * l(t, :)';
        H(t) = sum(h(1:t));
        L = L+l(t, :);
        
        if (eta == Inf)
            ws = L == min(L);
            wm = ws;
        else
            wm = ws.*exp(-L*eta);
        end
            
        pool = sum(alpha * wm);
        ws = (1-alpha)*wm+1/(length(ws)-1)*(pool-alpha*wm);
    end
    ws = ws/sum(ws);
end