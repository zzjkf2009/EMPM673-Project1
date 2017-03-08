%% 1. Get rid of the white border
img1=imread('capture.png');%read a random frame 
img2=imgaussfilt3(img1);%smooth it 
img3=rgb2gray(img2);
img4=imbinarize(img3);
%  img6 = bwareaopen(img4,20);
%  BW2 = bwareafilt(img4,3,'smallest');
%  imshow(BW2);
  LB2 = 30000; LB1 = 500;
UB2 = 50000;
UB1 = 2000;
Iout1 = xor(bwareaopen(img4,LB2),  bwareaopen(img4,UB2));
Iout2 = xor(bwareaopen(img4,LB1),  bwareaopen(img4,UB1));
Iout=xor(Iout1,Iout2);
ss=size(img1);
z=(zeros(ss));
the_frame=z+Iout;
fra=imcomplement(the_frame);




% img6=edge(img5,'Canny');
% 
%    rp=regionprops(Iout,'BoundingBox');
% a1=rp(1).BoundingBox;
% img6=imcomplement(Iout);
% 
%     I = imcrop(img6, a1);


I2 = imclearborder(im2bw(fra));
%% 2. Find each of the four corners
[y,x] = find(I2);
[~,loc] = min(y+x);
C = [x(loc),y(loc)];
[~,loc] = min(y-x);
C(2,:) = [x(loc),y(loc)];
[~,loc] = max(y+x);
C(3,:) = [x(loc),y(loc)];
[~,loc] = max(y-x);
C(4,:) = [x(loc),y(loc)];
%% 3. Plot the corners
imshow(img1); hold on
% plot(C([1:4 1],1),C([1:4 1],2),'r','linewidth',3);
plot(C(:,1),C(:,2),'r.','MarkerSize',30);
 C=[C ones(size(C,1),1)].';
%% 4. Homography
ref=imread('lena.png');
lena=imresize(ref,0.2);
[r1,c1]=size(lena);
D=[1,1,1;r1,1,1;r1,c1,1;1,c1,1].';
H =  homography2d(D,C);
G=H/H(3,3); 
for i=1:r1
for j=1:c1

v1 = [i;j;1];
v2 = G*v1;
v3 =v2/v2(3,1);  



img1(floor( v3(1,1)),floor(v3(2,1)))=lena(i,j);

 
end 
 end



% %% 4. Find the locations of the new  corners
% L = mean(C([1 4],1));
% R = mean(C([2 3],1));
% U = mean(C([1 2],2));
% D = mean(C([3 4],2));
% C2 = [L U; R U; R D; L D];
% %% 5. Do the image transform
% figure
% T = cp2tform(C ,C2,'projective');
% IT = imtransform(im2bw(I),T); %IM2BW is not necessary
% IT1=imcomplement(IT)
% reg=regionprops(IT1,'BoundingBox');
% a3=reg(5).BoundingBox;
%     im7 = imcrop(IT1, a3);
%     im8=imclose(im7,strel('square',6));
% 
% imshow(im8);
% 







  

 
 

