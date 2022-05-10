function UCT_table = UCT(parameter)
%Вычисляет значения фаз потенциала UCT при заданных параметрах

if ~libisloaded('potential')
   loadlibrary('potential');
end
UCT_table = zeros(160,1);

phase = calllib('potential','UCT_noncoupled',parameter);
setdatatype(phase,'doublePtr',16.*6);
UCT_table(1:96) = phase.Value;

phase = calllib('potential','UCT_coupled',parameter);
setdatatype(phase,'doublePtr',16.*4);
UCT_table(97:160) = phase.Value;

UCT_table = reshape(UCT_table,16,10);
UCT_table = UCT_table.';