classdef Seafloor
    % Seafoor class
    % input paramaters£º
    %   bottomType£ºsea bottom type,0-13
    %       0£ºuser-defined Lambertian value£¬
    %    sea.botType = 1 for average clean seagrass
    %    sea.botType = 2 for average coral
    %    sea.botType = 3 for average dark sediment
    %    sea.botType = 4 for average hardpan
    %    sea.botType = 5 for average kelp
    %    sea.botType = 6 for average macrophyte
    %    sea.botType = 7 for average ooid sand
    %    sea.botType = 8 for average seagrass
    %    sea.botType = 9 for average turf algae
    %    sea.botType = 10 for brown algae
    %    sea.botType = 11 for clean coral sand
    %    sea.botType = 12 for greean algae
    %    sea.botType = 13 for red algae
    %   Wavelength£º 350-800nm
    %   Rb£ºuser-defined Lambertian value£¬when bottomType=0£»
    %   case1£º532nm£¬user-defined 0.1£»
    %       bottom = Bottom(0,532,0.1)
    %   case2£ºclean seagrass£¬532nm
    %       bottom = Bottom(1,532)
    properties
        Type;   % bottomType
        Rb;     % sea floor reflectance
        Wavelength; %  nm
    end
    
    methods
        
        function obj = Seafloor(bottomType,Wavelength,Rb)
            obj.Wavelength = Wavelength;    % wavelength
            if bottomType==0
                obj.Rb = Rb;
            elseif bottomType==1
                obj.Type = 'clean seagrass ';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==2
                obj.Type = 'coral';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==3
                obj.Type = 'dark sediment';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==4
                obj.Type = 'hardpan';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==5
                obj.Type = 'kelp';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==6
                obj.Type = 'macrophyte';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==7
                obj.Type = 'ooid sand';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==8
                obj.Type = 'seagrass';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==9
                obj.Type = 'turf algae';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==10
                obj.Type = 'brown algae';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==11
                obj.Type = 'clean coral sand';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            elseif bottomType==12
                obj.Type = 'for greean algae';
                obj.Rb = obj.getRb(bottomType,Wavelength);   
            elseif bottomType ==13
                obj.Type = 'red algae';
                obj.Rb = obj.getRb(bottomType,Wavelength);
            else
                error("BottomType exceeds the range of 0-13");
            end
        end
        
        % Get parameters from file
        function Rb = getRb(obj,bottomType,Wavelength) 
            data = load('Bottom_params.rb');
            x = data(:,1);
            y = data(:,bottomType+1);
            Rb = interp1(x,y,Wavelength);
        end
    end
end

