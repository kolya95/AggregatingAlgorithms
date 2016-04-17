function [h, H, ws] = ConstantFixShare(l, eta, alpha)
    [T, K] = size(l);
    h = nan(T,1);
    L = zeros(1, K);
    ws = ones(1, K)/K;
    H = nan(T,1);
    for t = 1:T
        ws_ = ws;
        h(t) = ws_ * l(t, :)';
        H(t) = sum(h(1:t));
        L = L + l(t, :);
        
        if (eta == Inf)
            ws = L == min(L);
            s = sum(ws);
            ws = ws/s;
        else
            ws(1) = ws_(1)*exp(-L(1)*eta);
            ws(2) = ws_(2)*exp(-L(2)*eta);
            ws = ws/sum(ws);
        end
        
        temp = ws(1);
        ws(1) = (1-alpha)*ws(1)+alpha*ws(2);
        ws(2) = (1-alpha)*ws(2)+alpha*temp;
    end
end