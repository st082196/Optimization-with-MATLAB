load('input.mat','BONN_table','WJC1_table');
load('results 8 old\UCT_to_WJC1\ga x3 (7) + ga.mat','x');
x0 = x;
table = WJC1_table;
n = 101; % количество точек
lb = x0; % начальная точка
lb(1) = 14;
ub = x0; % конечная точка
ub(1) = 15;

dx = linspace(0,1,n);
x = lb + dx.*(ub - lb);
delta = zeros(10,16,n);
d_delta = zeros(10,16,n);
f = zeros(n,1);
for i = 1:n
    delta(:,:,i) = UCT(x(:,i));
    d_delta(:,:,i) = delta(:,:,i) - delta(:,:,1);
    f(i) = sqrt(mean(UCT_deviations(x(:,i),table).^2,'all')); % RMSE
end

plot(dx,reshape(delta(7,1,:),[],1,1));