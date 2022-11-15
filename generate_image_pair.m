function generate_image_pair (outdir, fnamePattern, roiArea, nrX, nrY, gap)

    % Phantom preparation
    I_raw = imread('arnoldcat_pure_cat.jpg');
    
    %figure; imshow(I_raw); title('Original');
    
    BW_raw = I_raw(:,:,1) > 100;
    BW = imcomplement (BW_raw);
    %figure; imshow(BW); title('Binary');
    
    % Contour
    C_c = bwboundaries(BW);
    C = cell2mat(C_c);
    
    % Scale ROI
    C_zy = C(:,1) - mean(C(:,1));
    C_zx = C(:,2) - mean(C(:,2));
    C_zy = C_zy ./ range(C(:,1));
    C_zx = C_zx ./ range(C(:,2));
    side = ceil(sqrt(roiArea * 1.44)); %--- An option --- max(range(C(:,1)), range(C(:,2)));	% ROI side
    ROI_centered = roipoly (side, side, C_zx .* side + side/2, C_zy .* side + side/2);
    ROI_centered_and_padded = padarray (ROI_centered, [gap gap], 0, 'both');
    %figure; imshow(ROI_z);
    %figure; imshow(ROI_zp);
    
    % Produce the mask image M
    M = repmat (ROI_centered_and_padded, nrX, nrY);
    M = bwlabel (M);    % The result 'M' is float
    M = uint32 (M);
    %figure; imshow(M .* 200); title(sprintf('ROI area = %d , # of ROIs = %d', roiArea, nrX*nrY));	% .* to increase brightness of {1,2,3, ... a few}
    
    % Report stats
    sprintf('-- actual ROI area = %d', nnz(ROI_centered_and_padded))
    
    % Generate the intensity data
    prep_intensity_phantom();
    
    % Save images
    fname = [outdir '/seg/' sprintf(fnamePattern, nrX*nrY, roiArea)]; 
    save2tif (fname, M);
    fname = [outdir '/int/' sprintf(fnamePattern, nrX*nrY, roiArea)];  
    save2tif (fname, I);

    % Create the masked intensities for user's awareness. (Doing this as uint16, not as uint32 as I and M originally are, because uint32 is not supported by imwrite().)
    I_masked = uint16(I) .* uint16(M);
    %figure; imshow(I_msk); title(sprintf('ROI area = %d , # of ROIs = %d', roiArea, nrX*nrY));
    imwrite (I_masked, [outdir '/' sprintf(fnamePattern, nrX*nrY, roiArea)]);  % Generate a thumbnail image
end