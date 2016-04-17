function h = DynamicFixShare(l, alpha)
    [T, K] = size(l);
    h = nan(T,1);
    Delta = 0;
    natural_alpha = alpha;
    prev_deltas = ones(1,10);
    L = zeros(size(l));
    for t = 1:T
        if abs(sum(prev_deltas)) > 2
            eta = max(log(K), 1)./Delta;
            alpha = natural_alpha;
            [~, ~, ws_c] = ConstantFixShare(l(1:t-1, :), eta, alpha);
            h(t) = ws_c * l(t, :)';
            m_t =  -1/eta*log(ws_c * exp(-eta*l(t,:)'));
            delta = max(0, h(t) - m_t);
        else
            h(t) = 0;
            delta = 0;
        end
        try
            L(t,:) = L(t-1,:) + l(t,:); 
        catch
            L(t,:) = l(t,:);
        end
        prev_deltas(1+t-length(prev_deltas).*floor(t./length(prev_deltas))) = sign(l(t,1));
        Delta = Delta + delta;
    end
end