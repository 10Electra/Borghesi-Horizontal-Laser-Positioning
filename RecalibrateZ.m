function array = RecalibrateZ(array,realMinZ, realMaxZ)
%RECALIBRATEZ Summary of this function goes here
%   Detailed explanation goes here
array = array * (realMaxZ-realMinZ)/(max(max(array))-min(min(array)));
array = array + realMinZ - min(min(array));
end

