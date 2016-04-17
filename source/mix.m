function [w, M] = mix(eta, L, alpha)
    mn = min(L);
    if (eta == Inf) 
        w = L==mn;
        s = sum(w);
        w = w/s;
    else
        w = exp(-eta .* (L-mn));    
        s = sum(w);       
        w = w/s;
        if ~isnan(alpha) 
            temp = w(1);
            w(1) = (1-alpha)*w(1)+alpha*w(2);
            w(2) = (1-alpha)*w(2)+alpha*temp;
        end
    end    
    M = mn - log(s/length(L))/eta;
end