%
% Prerequisites: matrix M produced by prep_roi_phanton.m
%

% Read the target image 
T_raw = imread ('Siemens_star_(128_spokes)_&_Matlab_code.tif');
T = uint16 (T_raw(:,:,1)) .* 256;
%imshow(T);

% Inscribed square
r = floor (size (T, 1) / 2);
sqSide = floor (2 * r / sqrt(2));

% how many tiles do we need to match the mask image? - depends on size(prep_roi_phanton.m::M)
szMx = size(M,1);
szMy = size(M,2);
nx = ceil (szMx / sqSide);
ny = ceil (szMy / sqSide);

% Produce the intensity image I
x1 = floor(r-sqSide/2);
x2 = floor(r+sqSide/2);
I = repmat(T(x1:x2, x1:x2), nx,ny);

% The intensity image is same size or bigger /due to floor()/ than the mask image. Clip it
I = I (1:szMx , 1:szMy);

%imshow (I)