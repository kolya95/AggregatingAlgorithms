function h = AdaHedgeFixShare(l, alpha)
    [T, K] = size(l);
    h = nan(T,1);
    L = zeros(1, K);
    Delta = 0;
    for t = 1:T
        eta = max(log(K), 1)/Delta;
        [w, Mprev] = mix(eta, L, alpha);
        
        h(t) = w * l(t, :)';
        L = L + l(t, :);
        [~, M] = mix(eta, L, alpha);
        
        delta = max(0, h(t) - (M-Mprev));
        Delta = Delta + delta;
    end
end
