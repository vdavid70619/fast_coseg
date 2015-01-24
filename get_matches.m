function matches = get_matches(im1,im2,method)
    if method=='deep' 
        imwrite(im1, '_tmp1.jpg');
        imwrite(im2, '_tmp2.jpg');
        !./deepmatching-static _tmp1.jpg _tmp2.jpg -jpg_settings > result
        matches = load('result')
    end

end