path_to_input_directory = ('../input_files/');
input_files = dir(fullfile(path_to_input_directory,'*.csv'));
aggregating_algorithms_list = {
    {@AdaHedgeFixShare, {0}} % 0 means, that it is pure adahedge
    {@ConstantFixShare, {0.03, 0.05}} % eta = 0.1, alpha = 0.05
    {@DynamicFixShare, {0.05}} % alpha=0.05
    {@DynamicFixShareModified, {0.05}}  % alpha=0.05
    };

for file = 1:length(input_files)
    indexes = [3]; % indexes of columns, which used
    input_path = fullfile(path_to_input_directory, input_files(file).name); %generate input file name

    
    input = csvread(input_path, 1, 2);
    T = 100;%length(input);
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
    
    

    results = zeros(T, numel(aggregating_algorithms_list));
    
    figure;
    hold on;
    plot(1:T, -S(1:T, 1), 'y', 'DisplayName', '1 expert');
    plot(1:T, -S(1:T, 2), 'g', 'DisplayName', '2 expert');
    
    for alg_index = 1:numel(aggregating_algorithms_list)
        func = aggregating_algorithms_list{alg_index}{1};
        arg = [{s(1:T, :)}, aggregating_algorithms_list{alg_index}{2}{:}];
        ml =  func(arg{:});
        cml = zeros(size(ml));
        for i = 2:T
            cml(i) = sum(ml(1:i));
        end
        plot(1:T, -cml(1:T), 'DisplayName', func2str(func));
    end
    legend(gca,'show', 'Location', 'northwest')
end
