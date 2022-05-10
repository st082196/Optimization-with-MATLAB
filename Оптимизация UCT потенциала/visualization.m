load('input.mat','BONN_table','WJC1_table','hc');
load('results 8\UCT_to_WJC1\ga x3 (7) + ga.mat','x');
x0 = x;
table = WJC1_table;
n = 101; % количество точек
lb = x0; % начальная точка
lb(3) = 6;
ub = x0; % конечная точка
ub(3) = 10;

dx = linspace(0,1,n);
x = lb + dx.*(ub - lb);
f = zeros(n,1);
for i = 1:n
    f(i) = sqrt(mean(UCT_deviations(x(:,i),table).^2,'all')); % RMSE
end

plot(dx,f);