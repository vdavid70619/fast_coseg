im1 = imread('amira1_small_128.png');
im2 = imread('amira2_small_128.png');

im1 = imresize(im1,0.25);
im2 = imresize(im2,0.25);

[bdry1, ~, region1] = get_ucm(im1);
[bdry2, ~, region2] = get_ucm(im2);

matches = get_matches(im1,im2,'deep');

common_regions = [];
for mi = 1:size(matches,1)
    common_regions = [common_regions; ...
        region1(matches(mi,1)+1,matches(mi,2))+1, region2(matches(mi,3)+1,matches(mi,4)+1), matches(mi,5)];
end

coms = unique(common_regions(:,1:2),'rows')

score = [];
for ci = 1:size(coms)
    debug = 0;
    score(ci) = -sum(common_regions((common_regions(:,1)==coms(ci,1))&(common_regions(:,2)==coms(ci,2)),3));
end

costM = ones(length(unique(region1)),length(unique(region2)));
costM = costM.*Inf;

for ci = 1:size(coms)
    debug = 0;
    costM(coms(ci,1),coms(ci,2)) = score(ci);
end    

assigns = munkres(costM);
final_assigns = [];    
for ai = 1:length(assigns)
   if assigns(ai)~=0
       final_assigns = [final_assigns; ai assigns(ai)];
   end
end

clm = jet(size(final_assigns,1))
new_im11 = zeros(size(im1,1),size(im1,2));
new_im21 = zeros(size(im2,1),size(im2,2));
new_im12 = zeros(size(im1,1),size(im1,2));
new_im22 = zeros(size(im2,1),size(im2,2));
new_im13 = zeros(size(im1,1),size(im1,2));
new_im23 = zeros(size(im2,1),size(im2,2));

for i=1:size(final_assigns,1)
    new_im11(region1(:)==final_assigns(i,1)) = clm(i,1);
    new_im21(region2(:)==final_assigns(i,2)) = clm(i,1);    
    new_im12(region1(:)==final_assigns(i,1)) = clm(i,2);
    new_im22(region2(:)==final_assigns(i,2)) = clm(i,2); 
    new_im13(region1(:)==final_assigns(i,1)) = clm(i,3);
    new_im23(region2(:)==final_assigns(i,2)) = clm(i,3);         
end

new_im1 = im1;
new_im2 = im2;
new_im1(:,:,1) = new_im11;
new_im1(:,:,2) = new_im12;
new_im1(:,:,3) = new_im13;    
new_im2(:,:,1) = new_im21;
new_im2(:,:,2) = new_im22;
new_im2(:,:,3) = new_im23;  

subplot(2,2,1)
visulize_matches(new_im1*255,new_im2*255,matches); 
subplot(2,2,2)
visulize_matches(im1,im2,matches);    
subplot(2,2,3)
visulize_matches(bdry1*255,bdry2*255,matches);
subplot(2,2,4)
visulize_matches(region1,region2,matches);
debug = 1;