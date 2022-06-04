load('data.mat');
points = p < 90; % Диапазон аппроксимируемых точек
% points(5:5:end) = 0;
p = p(points);
u = u(points);
w = w(points);
n = 11;

% u(p)
[linearModelTerms, coefficients] = deal(cell(1,n-1));
for i = 1:numel(linearModelTerms)
    linearModelTerms{i} = sprintf('u_a_j(%u,%u,p)',n,i);
    coefficients{i} = sprintf('C%u',i);
end
[fit_p_u, gof_p_u] = fit(p,u,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'));
C = coeffvalues(fit_p_u).';
[fit_p_u_W, gof_p_u_W] = fit(p,u,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'),'Weights',1./u.^2);
C_W = coeffvalues(fit_p_u_W).';

% w(p)
[linearModelTerms, coefficients] = deal(cell(1,n-3));
for i = 1:numel(linearModelTerms)
    linearModelTerms{i} = sprintf('w_a_j(%u,%u,p)',n,i);
    coefficients{i} = sprintf('D%u',i);
end
[fit_p_w, gof_p_w] = fit(p,w,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'));
D = coeffvalues(fit_p_w).';
[fit_p_w_W, gof_p_w_W] = fit(p,w,fittype(linearModelTerms,'coefficients',coefficients,'independent','p'),'Weights',1./w.^2);
D_W = coeffvalues(fit_p_w_W).';
%% u(p)
figure('Name','u(p)');
hold on;

p_fit = linspace(min(p),max(p),500);
plot(p(u>0),abs(u(u>0)),'.','Color','b');
plot(p(u<0),abs(u(u<0)),'.','Color','m');
plot(p_fit,abs(u_a(C,p_fit)),'Color','g');
plot(p_fit,abs(u_a(C_W,p_fit)),'Color','r');

set(gca,'YScale','log');
xlabel('p');
ylabel('|u|');
legend('u > 0','u < 0','u^a','u^a_W','Location','northeast');
grid on;
%% w(p)
figure('Name','w(p)');
hold on;

p_fit = linspace(min(p),max(p),500);
plot(p(w>0),abs(w(w>0)),'.','Color','b');
plot(p(w<0),abs(w(w<0)),'.','Color','m');
plot(p_fit,abs(w_a(D,p_fit)),'Color','g');
plot(p_fit,abs(w_a(D_W,p_fit)),'Color','r');

set(gca,'YScale','log');
xlabel('p');
ylabel('|w|');
legend('w > 0','w < 0','w^a','w^a_W','Location','northeast');
grid on;