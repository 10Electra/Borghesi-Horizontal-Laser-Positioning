function [array,f,c] = RecalibrateZ(array,realMinZ, realMaxZ)
%RECALIBRATEZ Summary of this function goes here
%   Detailed explanation goes here
f = (realMaxZ-realMinZ)/(max(max(array))-min(min(array)));
array = array * f;

c = realMinZ - min(min(array));
array = array + c;
end

