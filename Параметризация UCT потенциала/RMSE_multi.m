function f = RMSE_multi(parameter,table)
%Вычисляет среднеквадратичное отклонение значений фаз потенциала UCT от
%значений из table
%   1-ый параметр:
%    среднеквадратичное отклонение по всем фазам
%   2-ой параметр:
%    среднеквадратичное отклонение по фазам,
%    использующимся при вычислении e_d

f = UCT_deviations(parameter,table);
f = [sqrt(mean(f.^2,'all')); sqrt(mean(f(7,[1,2]).^2,'all'))];