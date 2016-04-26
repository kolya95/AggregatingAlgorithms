function [s, S]  = get_losses(input_path, indexes)
    input = csvread(input_path, 1, 2);
    T = length(input);
    input = input(1:T, indexes);
    V = zeros(T, 1); % V(t)    volume of game on step t
    C = zeros(T, 2); % C(t, i) fund/capital of  i-th expert on step t
    s = zeros(T, 2); % s(t, i) loss of  i-th expert on step t
    S = zeros(T, 2); % S(t, i) cumulative loss of  i-th expert on step t

    const = 1;

    for t = 1:T-1
        %capitals
        C(t, 1) = 2*const*(input(t)-input(1));
        C(t, 2) = -C(t, 1); 

        % count losses on current step
        s(t, 1) = C(t,1)*(input(t+1)-input(t));
        s(t, 2) = -s(t, 1);

        % count cumulative losses
        S(t, 1) = sum(s(1:t, 1));
        S(t, 2) = sum(s(1:t, 2));

        % считаем объем игры
        V(t+1) = V(t) + max(s(t,:));

    end
    s = s/max(max(s));
    for t = 1:T-1    
        S(t, 1) = sum(s(1:t, 1));
        S(t, 2) = sum(s(1:t, 2));
    end
    
    
    
end