%%% parameters of run
save = 1;
rewrite = 1;
path_to_input_directory = ('../input_files/');
path_to_outut = '../output/last';
indexes = [3]; % indexes of columns, which used
input_files = dir(fullfile(path_to_input_directory,'*.csv'));
aggregating_algorithms_list = {
    {@AdaHedge, {}, {'AHF'}} % 0 means, that it is pure adahedge
    {@ConstantFixShare, {0.03, 0.01}, {'CFS'}} % eta = 0.1, alpha = 0.05
    {@DynamicFixShare, {0.05}, {'DFS'}} % alpha=0.05
    {@VariableShare, {0.03, 0.01}, {'VS'}}
    };

%%% run
for file = 1:length(input_files)
    input_path = fullfile(path_to_input_directory, input_files(file).name); %generate input file name

    
    [s, S] = get_losses(input_path, indexes); % get losses, and cumulative losses
    T = length(s);%min(length(s), 1000);
    
    cumulative_losses = zeros(numel(aggregating_algorithms_list), T);
    for alg_index = 1:numel(aggregating_algorithms_list)
        aggregating_algorithms_list{alg_index}{3}

        func = aggregating_algorithms_list{alg_index}{1};
        arg = [{s(1:T, :)}, aggregating_algorithms_list{alg_index}{2}{:}];
        ml =  func(arg{:});
        cml = zeros(size(ml));
        for i = 2:T
            cml(i) = sum(ml(1:i));
        end
        cumulative_losses(alg_index, :) = cml;
    end

%%% plots    
    figure;
    hold on;
    plot(1:T, -S(1:T, 1), 'y', 'DisplayName', '1 expert');
    plot(1:T, -S(1:T, 2), 'g', 'DisplayName', '2 expert');    
    for alg_index = 1:numel(aggregating_algorithms_list)
        name = aggregating_algorithms_list{alg_index}{3};
        args_str = '';
        if length(arg) > 1
            args_str = strcat('(', num2str(arg{2}));
            for arg_index = 3:length(arg)
                args_str = strcat(args_str, ',', num2str(arg{arg_index}));
            end
            args_str = strcat(args_str, ')');
        end
        legend_name = strcat(name, args_str);
        plot(1:T, -cumulative_losses(alg_index, 1:T), 'DisplayName', legend_name{1});
    end
    legend(gca,'show', 'Location', 'northwest')  
    [~,output_name, ~] = fileparts(input_files(file).name);
    if save && rewrite
        print(fullfile(path_to_outut, output_name),'-dpng','-r0')
    else if save && ~rewrite
            true_name = output_name;
            for i = 1:100
                if exist(fullfile(path_to_outut, strcat(output_name, '.png')), 'file')
                    output_name = strcat(true_name, num2str(i));
                else
                    print(fullfile(path_to_outut, output_name),'-dpng')
                    break;
                end
            end            
        end
    end
%%% 
end
