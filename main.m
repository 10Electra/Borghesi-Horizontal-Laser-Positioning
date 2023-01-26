filePath = 'C:\Users\cqh27498\Downloads\Atomic Precision Mount Tests\';
% fileName = '18um Al 5x mag, 0.55FOV.OPD';
fileName = '25um Al, 300um wide.OPD';
left_foil_bound = 140;
right_foil_bound = 1090;
approx_beam_width_um = 10;
realMinZ = -6.744;
realMaxZ = 10.302;

%% 
fullPath = strcat(filePath,fileName);
[array,wavelength,aspect,pxlsize] = ReadOPD(fullPath);
% array = (array / 13.027) + 8.222;
array = RecalibrateZ(array, realMinZ, realMaxZ);
clear filePath fileName fullPath realMinZ realMaxZ

%% 
approx_beam_width_px = round(approx_beam_width_um/(pxlsize*1000)); % Need to work out scaling.
sprintf('Search width is %d data point columns',approx_beam_width_px)

foil_centre = (left_foil_bound + right_foil_bound) / 2;
left_third_bound = round(1/3 * (right_foil_bound-left_foil_bound) + left_foil_bound);
right_third_bound = round(2/3 * (right_foil_bound-left_foil_bound) + left_foil_bound);
total_search_width_px = right_third_bound-left_third_bound;

%%
% for xi = left_third_bound:right_third_bound
%     y = array(:,xi);
%     x = linspace(1,height(array),height(array))';
%     x(isnan(y)) = NaN;
%     xfit = rmmissing(x);
%     yfit = rmmissing(y);
%     scatter(xfit,yfit,'filled')
% %     hold on
% %     fitobj = fit(xfit,yfit,'poly2');
% %   plot(fitobj)
% %     fitobj2 = fit(xfit,yfit,'poly1');
% %     plot(fitobj2)
%     title(xi)
%     waitforbuttonpress
%     clf
% end
% clear x y xfit yfit xi
%% 
m = zeros(total_search_width_px,1);
r = zeros(total_search_width_px,1);
for i=1:total_search_width_px
    j = i-1 + left_third_bound;
    fitobj = FitSlice(array,j,'poly1');
    [minCol,maxCol] = bounds(array(:,j));
    r(i) = maxCol-minCol;
    m(i) = fitobj.p1;
end

i = 0;
lsf = inf;
bsf = NaN;
while i + approx_beam_width_px <= total_search_width_px
    j = i + left_third_bound;
    total = 0;
    for k = 1:approx_beam_width_px
        total = total + r(i+k);
    end
    avg = total / approx_beam_width_px;
    if lsf > avg
        lsf = avg;
        bsf = j+approx_beam_width_px/2; % 0.5 less than actual value
    end
    i=i+1;
end
clear i j k m r minCol maxCol total fitobj avg

%% 
sprintf(['The middle column of the %d column wide least warped section' ...
    ' is %d'],[approx_beam_width_px,bsf])
sprintf('The average gradient of this section is %d',lsf)

%%
figure(1)
plot3([bsf,bsf],[0,height(array)],[0,0],'r')
hold on
plot3([left_third_bound,left_third_bound],[0,height(array)],[0,0],'b')
plot3([right_third_bound,right_third_bound],[0,height(array)],[0,0],'b')
surf(array,EdgeColor="none")
daspect([6,6,1])
% daspect([1,1,1])
ylim([350 600])
% xlim([0 1200])
hold off

%%
% figure(2)
% plot(FitSlice(array,bsf,'poly1'))
% hold on
% y = array(:,bsf);
% x = linspace(1,height(array),height(array))';
% x(isnan(y)) = NaN;
% xfit = rmmissing(x);
% yfit = rmmissing(y);
% scatter(xfit,yfit,'filled')
% hold off
% clear x y xfit yfit