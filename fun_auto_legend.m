function fun_auto_legend(pre,list,post)
% FUN_AUTO_LEGEND generate legend by using given prefix, list, and postfix
% USAGE:
%     fun_auto_legend(pre,list,post)
% INPUTS:
%    pre: char,prefix
%    list: numeric, the list of legends that need to be generated
%    post: char,postfix
% OUTPUTS:
% EXAMPLE:
%    fun_auto_legend('CHL = ',[0.01 0.1 1 10],'mg/m^3')
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 
    legendlist = [];
    legendcomm = [];
    for i = 1:length(list)
        legendlist = [legendlist string([pre,num2str(list(i)),post])];
        legendcomm=[legendcomm string(['legendlist(' num2str(i) ')'])];
    end
    temp = join(legendcomm,',');
    temp = ["legend(" temp ")"];
    legendcomm = join(temp);
    eval(legendcomm);


end