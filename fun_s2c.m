% spectral 2 rgb color
function c=s2c_fun(l)
% input: l lambda
% return: rgb
if (l<380.0) r=     0.00;
elseif (l<400.0) r=0.05-0.05*sin(pi*(l-366.0)/ 33.0);
elseif (l<435.0) r=     0.31*sin(pi*(l-395.0)/ 81.0);
elseif (l<460.0) r=     0.31*sin(pi*(l-412.0)/ 48.0);
elseif (l<540.0) r=     0.00;
elseif (l<590.0) r=     0.99*sin(pi*(l-540.0)/104.0);
elseif (l<670.0) r=     1.00*sin(pi*(l-507.0)/182.0);
elseif (l<730.0) r=0.32-0.32*sin(pi*(l-670.0)/128.0);
else              r=     0.00;
end
if (l<454.0) g=     0.00;
elseif (l<617.0) g=     0.78*sin(pi*(l-454.0)/163.0);
else              g=     0.00;
end
if (l<380.0) b=     0.00;
elseif (l<400.0) b=0.14-0.14*sin(pi*(l-364.0)/ 35.0);
elseif (l<445.0) b=     0.96*sin(pi*(l-395.0)/104.0);
elseif (l<510.0) b=     0.96*sin(pi*(l-377.0)/133.0);
else              b=     0.00;
end
c = [r,g,b];
end