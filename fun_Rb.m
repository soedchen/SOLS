function [Rb,bottom] = fun_Rb(bottomType,Wavelength)
% FUN_RB get the reflectance seafloor according to the bottomType
% USAGE:
%   [Rb] = fun_Rb(bottomType,Wavelength)
% INPUTS:
%   bottomType: the types of sea botom 1-12
%    1 for average clean seagrass
%    2 for average coral
%    3 for average dark sediment
%    4 for average hardpan
%    5 for average kelp
%    6 for average macrophyte
%    7 for average ooid sand
%    8 for average seagrass
%    9 for average turf algae
%    10 for brown algae
%    11 for clean coral sand
%    12 for greean algae
%    13 for red algae
%   Wavelength: nm, 350-800nm
% OUTPUTS:
%   Rb: sea floor reflectance
%   bottom: the type name of the sea floor
% EXAMPLE:
%    
% HISTORY:
%    2021-11-05: first edition by OLIDAR
% .. Authors: - 
if bottomType<1 || bottomType>13
   error("BottomType exceeds the range of 1-13")
end
seafloor=Seafloor(bottomType,Wavelength);
Rb = seafloor.Rb;
bottom = seafloor.Type;