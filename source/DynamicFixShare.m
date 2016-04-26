function h = DynamicFixShare(l, alpha)
    [T, K] = size(l);
    h = nan(T,1);
    Delta = 0;
    L = zeros(size(l));
    for t = 1:T
        eta = max(log(K), 1)./Delta;
        [~, ~, ws_c] = ConstantFixShare(l(1:t-1, :), eta, alpha);
        h(t) = ws_c * l(t, :)';
        try
            L(t,:) = L(t-1,:) + l(t,:); 
            [~, Mprev] = mix(eta, L(t-1,:));
            
        catch
            L(t,:) = l(t,:);
            Mprev = 0;
        end
        [~, M] = mix(eta, L(t,:));
        
        delta = max(0, h(t) - (M-Mprev));
        
        Delta = Delta + delta;
        
        if mod(t, 200) == 0
            t
        end
    end
end