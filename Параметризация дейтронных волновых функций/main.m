load('data.mat');
points = p < 100; % Диапазон аппроксимируемых точек
% points(5:5:end) = 0;
p = p(points);
u_obs = u_obs(points);
w_obs = w_obs(points);
n = 11;

% u(p)
[linearModelTerms, coefficients] = deal(cell(1,n-1));
for i = 1:numel(linearModelTerms)
    linearModelTerms{i} = sprintf('u_j(%u,%u,p)',n,i);
    coefficients{i} = sprintf('C%u',i);
end
[fit_u_p,gof_u_p] = fit(p,u_obs,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'));
C = coeffvalues(fit_u_p).'.*sqrt(pi./2);
[fit_u_p_weighted,gof_u_p_weighted] = fit(p,u_obs,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'),'Weights',1./u_obs.^2);
C_weighted = coeffvalues(fit_u_p_weighted).'.*sqrt(pi./2);

% w(p)
[linearModelTerms, coefficients] = deal(cell(1,n-3));
for i = 1:numel(linearModelTerms)
    linearModelTerms{i} = sprintf('w_j(%u,%u,p)',n,i);
    coefficients{i} = sprintf('D%u',i);
end
[fit_w_p,gof_w_p] = fit(p,w_obs,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'));
D = coeffvalues(fit_w_p).'.*sqrt(pi./2);
[fit_w_p_weighted,gof_w_p_weighted] = fit(p,w_obs,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'),'Weights',1./w_obs.^2);
D_weighted = coeffvalues(fit_w_p_weighted).'.*sqrt(pi./2);
%% u(p)
figure('Name','u(p)');
hold on;

p_fit = linspace(min(p),max(p),1000);
plot(p_fit,abs(u(C,p_fit)),'Color','g');
plot(p_fit,abs(u(C_weighted,p_fit)),'Color','r');
plot(p,abs(u_obs),'o','Color','b','MarkerFaceColor','b','MarkerSize',3);

set(gca,'YScale','log');
xlabel('p');
ylabel('u');
grid on;
%% w(p)
figure('Name','w(p)');
hold on;

p_fit = linspace(min(p),max(p),1000);
plot(p_fit,abs(w(D,p_fit)),'Color','g');
plot(p_fit,abs(w(D_weighted,p_fit)),'Color','r');
plot(p,abs(w_obs),'o','Color','b','MarkerFaceColor','b','MarkerSize',3);

set(gca,'YScale','log');
xlabel('p');
ylabel('w');
grid on;