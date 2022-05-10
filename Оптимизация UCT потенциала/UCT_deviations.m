function f = UCT_deviations(parameter,table)
%Вычисляет отклонения значений фаз потенциала UCT от значений из table

UCT_table = UCT(parameter);
UCT_table = UCT_table(1:size(table,1),1:size(table,2));
f = abs(UCT_table-table);