filePath = "C:\Users\cqh27498\Downloads\Atomic Precision Mount Tests\";
fileName = "18um laser machined foil (filtered).obj";

if ~isfile("reformat3dworkspace.mat")
    disp('Saved workspace file not found; loading data afresh')
    Reformat3D(filePath,fileName);
    disp('Finished loading data')
else
    load('reformat3dworkspace','fileNameParam')
    if fileNameParam ~= fileName
        disp(['Saved workspace file refers to a different file; ' ...
              'loading data afresh'])
        [table1,table2] = Reformat3D(filePath,fileName);
        disp('Finished loading data')
    else
        load('reformat3dworkspace','table1','table2')
        disp('Saved workspace file found; loading saved data')
    end
    clear fileNameParam
end

%%
x = table1(:,1); y = table1(:,2);

[xMin,xMax] = bounds(x); x_range = xMax-xMin;
[yMin,yMax] = bounds(y); y_range = yMax-yMin;

um_per_pixel_x = 1e+6 * x_range / img_width; % Would be good to check this with the interferometer
um_per_pixel_y = 1e+6 * y_range / img_height;

clear(x, y, x_range, y_range, xMin, xMax, yMin, yMax)
%%
left_foil_bound = 763;
right_foil_bound = 2755;

foil_centre = (left_foil_bound + right_foil_bound) / 2;
left_third_bound = 1/3 * (right_foil_bound-left_foil_bound) + left_foil_bound;
right_third_bound = 2/3 * (right_foil_bound-left_foil_bound) + left_foil_bound;

search_width = 5;

l = left_third_bound;
r = left_third_bound + 3;
lsf = inf;
bsf = NaN;
while r <= right_third_bound
    total = 0;
    for i = 1:search_width
        [col_min,col_max] = bounds(table1(:,l));
        total = total + (col_max-col_min);
    end
    avg = total / height(Z);
    if lsf > avg
        lsf = avg;
        bsf = (l+r)/2;
    end
    l=l+1;
    r=r+1;
end

%%
if bsf > foil_centre
    disp("The flattest line-out is right of the centre by (um)")
elseif bsf < foil_centre
    disp("The flattest line-out is left of the centre by (um)")
else
    disp("The flattest line-out is in the centre.")
end
dist_px = abs(foil_centre-bsf);
dist_um = dist_px * m_per_pixel_x*1e+6;
disp(dist_um)

%%
n = 10;
bsf_x = bsf * ones(1,n);
bsf_y = [ones(1,n/2),ones(1,n/2)*height(table1)];
bsf_z = 1:n;
plot3(bsf_x,bsf_y,bsf_z,'r')
hold on
surf(Z,EdgeColor="none")
daspect([5,5,1])