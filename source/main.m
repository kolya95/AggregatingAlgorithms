path_yandex = '../input_files/yandex.csv';
path_moex = '../input_files/MOEX.csv';
path_moex = '../input_files/MOEX_h.csv';

indexes = [3];

input_path = path_moex;
input_columns =indexes;

input = csvread(input_path, 1, 2);
T = length(input);
input = input(5000:T, indexes);
T = length(input);

V = zeros(T, 1); % V(t, 1) ����� ���� �� ���� t
fluc = zeros(T, 1); % ���������� ����
C = zeros(T, 2); % C(t, i) ������� i-�� �������� �� ���� t
s = zeros(T, 2); % s(t, i) �������� i-�� �������� �� ���� t
S = zeros(T, 2); % ������������ �������

const = 1;

for t = 1:T-1
    %������������� ��������
    C(t, 1) = 2*const*(input(t)-input(1));
    C(t, 2) = -C(t, 1); 
       
    % ������� ��������/������ �� ������� ����
    s(t, 1) = C(t,1)*(input(t+1)-input(t));
    s(t, 2) = -s(t, 1);
    
    % ������� ������������ ������
    S(t, 1) = sum(s(1:t, 1));
    S(t, 2) = sum(s(1:t, 2));
    
    % ������� ����� ����
    V(t+1) = V(t) + max(s(t,:));
    
end

%mixed_losses = AdaHedge_FixShare(s(1:T, :), 0.01);
mixed_losses = DynamicFixShare(s(1:T,:), 0.01);
cumulative_mixed = zeros(size(mixed_losses));
G = mixed_losses;
for i = 2:T
    cumulative_mixed(i) = sum(mixed_losses(1:i));
end

% plot(1:T, input(:,3))
figure;
hold on;
plot(1:T, S(1:T, 1));
plot(1:T, -cumulative_mixed(1:T), 'k');
plot(1:T, S(1:T, 2));
%plot(1:T, V);

% figure;
% hold on;
% plot(1:T, C(1:T, 1));
% plot(1:T, G(1:T), 'k');
% plot(1:T, C(1:T, 2));
