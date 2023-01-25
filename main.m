filePath = 'C:\Users\cqh27498\Downloads\Atomic Precision Mount Tests\';
fileName = '18um Al 5x mag, 0.55FOV.OPD'; 
left_foil_bound = 140;
right_foil_bound = 1090;
search_width_um = 20;

%% 
fullPath = strcat(filePath,fileName);
[array,wavelength,aspect,pxlsize] = ReadOPD(fullPath);
clear filePath fileName fullPath

%% 
search_width_px = round(search_width_um/2.5); % Need to work out scaling.
sprintf('Search width is %d data point columns',search_width_px)

foil_centre = (left_foil_bound + right_foil_bound) / 2;
left_third_bound = round(1/3 * (right_foil_bound-left_foil_bound) + left_foil_bound);
right_third_bound = round(2/3 * (right_foil_bound-left_foil_bound) + left_foil_bound);

%%
% fitobj = FitSlice(array,460,'poly1');
% disp(fitobj.p1)

% for xi = left_third_bound:right_third_bound
%     y = array(:,xi);
%     x = linspace(1,height(array),height(array))';
%     x(isnan(y)) = NaN;
%     xfit = rmmissing(x);
%     yfit = rmmissing(y);
%     scatter(xfit,yfit,'filled')
%     hold on
%     fitobj = fit(xfit,yfit,'poly2');
%     plot(fitobj)
%     fitobj2 = fit(xfit,yfit,'poly1');
%     plot(fitobj2)
%     title(xi)
%     waitforbuttonpress
%     clf
% end

%% 
l = left_third_bound;
lsf = inf;
bsf = NaN;
while l + search_width_px <= right_third_bound
    total = 0;
    for i = 1:search_width_px
        fitobj = FitSlice(array,l+i,'poly1');
        total = total + fitobj.p1;
    end
    avg = total / search_width_px;
    if lsf > avg
        lsf = avg;
        bsf = l+search_width_px/2;
    end
    l=l+1;
end
clear i col_min col_max total l r

%% 
disp(bsf)
disp(lsf)

%% 
plot3([bsf,bsf],[0,height(array)],[0,0],'r')
hold on
plot3([left_third_bound,left_third_bound],[0,height(array)],[0,0],'b')
plot3([right_third_bound,right_third_bound],[0,height(array)],[0,0],'b')
surf(array,EdgeColor="none")
daspect([1,1,1])
ylim([350 550])
xlim([0 1200])