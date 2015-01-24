function visulize_matches(im1,im2,matches)

    colors = jet(128);
    height = max(size(im1,1),size(im2,1));
    im1_ratio = height/size(im1,1);
    im2_ratio = height/size(im2,1);
    im1 = imresize(im1,im1_ratio);
    im2 = imresize(im2,im2_ratio);
    matches(:,1:2) = matches(:,1:2) * im1_ratio;
    matches(:,3:4) = matches(:,3:4) * im2_ratio;
    points1 = [matches(:,2) matches(:,1)];
    points2 = [matches(:,4) matches(:,3)];
    scores = matches(:,5);
    match_img = zeros(height, size(im1,2)+size(im2,2), size(im2,3));
    match_img(1:size(im1,1),1:size(im1,2),:) = im1;
    match_img(1:size(im2,1),size(im1,2)+1:end,:) = im2;
    imshow(uint8(match_img),[]);

    hold on;

    for i=1:size(points1,1)
        plot([points1(i,2) points2(i,2)+size(im1,2)],[points1(i,1) points2(i,1)],...
            'Color',colors(ceil(128*scores(i)./max(scores)),:));
    end

    hold off;

end