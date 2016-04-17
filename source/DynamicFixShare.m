function h = DynamicFixShare(l, alpha)
    [T, K] = size(l);
    h = nan(T,1);
    Delta = 0;
    L = zeros(size(l));
    for t = 1:T
        eta = max(log(K), 1)./Delta;
        [~, ~, ws_c] = ConstantFixShare(l(1:t-1, :), eta, alpha);
        h(t) = ws_c * l(t, :)';
        m_t =  -1/eta*log(ws_c * exp(-eta*l(t,:)'));
        delta = max(0, h(t) - m_t);
        try
            L(t,:) = L(t-1,:) + l(t,:); 
        catch
            L(t,:) = l(t,:);
        end
        Delta = Delta + delta;
    end
end