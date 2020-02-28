function xp = smib(t,x)
%SMIB model.
global F D

%   

xp = [x(2);  F-sin(x(1))-D*x(2)];
end
