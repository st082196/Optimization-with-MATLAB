%% Загрузка входных данных
clear; clc;
load('input.mat');
table = WJC1_table;
max_time = 18000;
SSE = @(parameter) sum(UCT_deviations(parameter,table).^2,'all');
RMSE = @(parameter) sqrt(mean(UCT_deviations(parameter,table).^2,'all'));
RMSE_multi = @(parameter) RMSE_multi(parameter,table);
%% Поиск минимума
x0 = (lb+ub)./2;
% x0 = x;
% rng(0);

tic
switch 'fminsearch'
    case 'fminsearch'
        [x,fval,exitflag,output] = fminsearch( ...
            RMSE,x0,optimset('MaxTime',max_time,'Display','iter') ...
            );
    case 'fmincon'
        [x,fval,exitflag,output] = fmincon( ...
            RMSE,x0,[],[],[],[],lb,ub,[],optimset('MaxTime',max_time,'Display','iter') ...
            );
    case 'GlobalSearch'
        problem = createOptimProblem( ...
            'fmincon','x0',x0,'objective',RMSE,'lb',lb,'ub',ub ...
            );
        [x,fval,exitflag,output,solutions] = run( ...
            GlobalSearch('NumStageOnePoints',1000,'NumTrialPoints',5000,'MaxTime',max_time,'Display','iter'),problem ...
            );
    case 'MultiStart'
        problem = createOptimProblem( ...
            'fmincon','x0',x0,'objective',RMSE,'lb',lb,'ub',ub ...
            );
        [x,fval,exitflag,output,solutions] = run( ...
            MultiStart('MaxTime',max_time,'Display','iter'),problem,200 ...
            );
    case 'patternsearch'
        [x,fval,exitflag,output] = patternsearch( ...
            RMSE,x0,[],[],[],[],lb,ub,[], ...
            optimoptions(@patternsearch,'MaxFunctionEvaluations',1e6,'MaxIterations',1e4,'MaxTime',max_time,'Display','iter') ...
            );
    case 'ga'
        [x,fval,exitflag,output,population,scores] = ga( ...
            RMSE,nvars,[],[],[],[],lb,ub,[], ...
            optimoptions(@ga,'MaxTime',max_time,'Display','iter') ...
            );
    case 'particleswarm'
        [x,fval,exitflag,output] = particleswarm( ...
            RMSE,nvars,lb,ub, ...
            optimoptions(@particleswarm,'MaxTime',max_time,'Display','iter') ...
            );
    case 'simulannealbnd'
        [x,fval,exitflag,output] = simulannealbnd( ...
            RMSE,x0,lb,ub, ...
            optimoptions(@simulannealbnd,'MaxTime',max_time,'Display','iter') ...
            );
    case 'gamultiobj'
        [x,fval,exitflag,output,residuals] = gamultiobj( ...
            RMSE_multi,nvars,[],[],[],[],lb,ub,[], ...
            optimoptions(@gamultiobj,'MaxStallGenerations',1000,'MaxTime',max_time,'PlotFcn','gaplotpareto','Display','iter') ...
            );
    case 'paretosearch'
        [x,fval,exitflag,output,residuals] = paretosearch( ...
            RMSE_multi,nvars,[],[],[],[],lb,ub,[], ...
            optimoptions(@paretosearch,'PlotFcn','psplotparetof','MaxTime',max_time,'Display','iter') ...
            );
end
time = toc;
%% Расчёт дополнительных параметров и вывод результатов
phase = UCT(x(7,:));
p = sqrt((E.*m)./(2.*hc));
r_s = 2./(p(1).^2-p(2).^2).*(p(1).*cotd(phase(1,1))-p(2).*cotd(phase(1,2)));
a_s = 1./(r_s./2.*p(1).^2-p(1).*cotd(phase(1,1)));
r_t = 2./(p(1).^2-p(2).^2).*(p(1).*cotd(phase(7,1))-p(2).*cotd(phase(7,2)));
a_t = 1./(r_t./2.*p(1).^2-p(1).*cotd(phase(7,1)));
e_d = hc./m.*((1-sqrt(1-2.*r_t./a_t))./r_t).^2;

mask = [1; hc; 1; hc; 1; hc; 1; hc; 1; hc; 1; hc; 1; hc; 1; hc; hc];
% fprintf('%.16g\n',[x(:).*mask; SSE(x); RMSE(x); a_s; r_s; a_t; r_t; e_d]);
fprintf('%.16g\n',[x(7,:).'.*mask; SSE(x(7,:)); RMSE(x(7,:)); a_s; r_s; a_t; r_t; e_d]);
%% Удаление ненужных данных перед сохранением
clear BONN_table WJC1_table E hc m nvars lb ub x0 ...
    table max_time SSE RMSE RMSE_multi mask phase p r_s a_s r_t a_t e_d