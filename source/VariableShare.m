function [h, H, ws] = VariableShare(l, eta, alpha)
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
        L_ = l(t,:);
        if (eta == Inf)
            ws = L == min(L);
            wm = ws;
        else
            wm = ws.*exp(-L*eta);
        end
        ws(1) = (1-alpha)^L_(1)*wm(1)+(1-(1-alpha)^L_(2))*wm(2);
        ws(2) = (1-alpha)^L_(2)*wm(2)+(1-(1-alpha)^L_(1))*wm(1);
        %pool = sum(alpha * wm);
        %ws = (1-alpha)*wm+1/(length(ws)-1)*(pool-alpha*wm); 
    end
    ws = ws/sum(ws);
end