function [ucm, ucm2, labels] = get_ucm(im)
    addpath('./ucm/lib');
    k = 0.05
   
    %globalPb
    imwrite(im, 'temp.bmp');
    globalPb('temp.bmp', 'temp_gPb.mat');

    % for boundaries
    load('temp_gPb.mat', 'gPb_orient')
    ucm = contours2ucm(gPb_orient, 'imageSize');
    imwrite(ucm,'temp_ucm.bmp');

    % for regions
    ucm2 = contours2ucm(gPb_orient, 'doubleSize');
    imwrite(ucm2,'temp_ucm2.bmp');

    labels2 = bwlabel(ucm2 <= k);
    labels = labels2(2:2:end, 2:2:end);    
end