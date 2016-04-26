function [w, M] = mix(eta, L)
    mn = min(L);
    if (eta == Inf) 
        w = L==mn;
        s = sum(w);
        w = w/s;
    else
        w = exp(-eta .* (L-mn));    
        s = sum(w);       
        w = w/s;
    end    
    M = mn - log(s/length(L))/eta;
end