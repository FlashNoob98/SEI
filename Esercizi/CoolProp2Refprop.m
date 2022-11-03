function [out] = CoolProp2Refprop
%% CoolProp To Refprop Syntax generate a function handle to py.CoolProp module
%
% In order to use refpropm syntax inside the script, you only need to call
% refpropm = CoolProp2Refprop; once
out = @py.CoolProp.CoolProp.PropsSI;
end

