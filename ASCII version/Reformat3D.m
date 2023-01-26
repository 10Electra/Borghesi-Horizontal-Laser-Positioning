function Reformat3D(filePathParam,fileNameParam)
%OPZFCONVERSION Converts a 3D coordinate file (.obj, .xyz..) to two useful
%   tables. Output: Table1, Table2. Table 1 is an n*3 table, where n is
%   the number of data points in the original file. Table 2 is a p*q table,
%   where p and q are the y and x dimensions of the rectangular data.
fullPath = strcat(filePathParam,fileNameParam);
fid = fopen(fullPath, 'rt');
C = textscan(fid, '%f%f%f', 'Delimiter',' ', 'HeaderLines', 10);
x = C{1};
y = C{2};
z = C{3};
fclose(fid);

%   Finding the dimensions of the interferometer image
i = 1;
while x(i+1) == x(i)
    i = i + 1;
end
img_width = i;
img_height = height(x)/img_width;

%   Create table2 with dimensions img_height,img_width
table2 = zeros(img_height,img_width);
for i = 1:img_height
    table2(i,:) = z(img_width*(i-1)+1:img_width*i)';
end
save reformat3dworkspace.mat
end