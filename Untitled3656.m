%% 1. Get rid of the white border
tic
img1=imread('capture.png');%read a random frame 
img2=imgaussfilt3(img1);%smooth it 
img3=rgb2gray(img2);
img4=imbinarize(img3);
tag=imread('ref_marker.png');

%  img6 = bwareaopen(img4,20);
%  BW2 = bwareafilt(img4,3,'smallest');
%  imshow(BW2);
  LB2 = 30000; LB1 = 500;
UB2 = 80000;
UB1 = 2000;
Iout1 = xor(bwareaopen(img4,LB2),  bwareaopen(img4,UB2));
Iout2 = xor(bwareaopen(img4,LB1),  bwareaopen(img4,UB1));
Iout=xor(Iout1,Iout2);
% ss=size(img1);
% z=(zeros(ss));
% the_frame=z+Iout;
fra=imcomplement(Iout);


I2 = imclearborder(im2bw(fra));
%% 2. Find the corners of the paper
[y1,x1] = find(Iout1);
[~,loc1] = min(y1+x1);
C1 = [x1(loc1),y1(loc1)];
[~,loc1] = min(y1-x1);
C1(2,:) = [x1(loc1),y1(loc1)];
[~,loc1] = max(y1+x1);
C1(3,:) = [x1(loc1),y1(loc1)];
[~,loc1] = max(y1-x1);
C1(4,:) = [x1(loc1),y1(loc1)];
% figure(1),imshow(img1); hold on
% plot((C1(:,1)),(C1(:,2)),'r.','MarkerSize',30);hold off
% [rows, columns] = size(I2);
% logicalMap = poly2mask((C1(:,1)).',(C1(:,2).'), rows, columns); % put in coords of the rectangle corners.
% extractedValues =I2(logicalMap);
D1=[1,1;400,1;400,700;1,700];
tform = fitgeotrans(C1,D1,'Projective');
C1=[C1 ones(size(C1,1),1)].';
D1=[D1 ones(size(D1,1),1)].';
Paper=imwarp(Iout,tform);
P=imwarp(img1,tform);
reg=regionprops(Paper,'BoundingBox');
cro=imcrop(Paper,reg(2).BoundingBox);
% imshow(cro);
[w,z]=size(cro);
w1=ceil(w/4);z1=ceil(z/4);
fun = @(block_struct)...
mean2((block_struct.data))

I3 = blockproc(cro,[w1 z1],fun);
 I3((I3<0.5))=0;
  I3((I3>=0.5))=1;
if I3(1,4)==1
        bin=[I3(3,2),I3(2,2),I3(2,3),I3(3,3)];
        q=imrotate(P,270);
        D=[512,1,1;512,512,1;1,512,1;1,1,1].';
        T=[200,1,1;200,200,1;1,200,1;1,1,1].';
    elseif I3(1,1)==1  
        bin=[I3(3,3),I3(3,2),I3(2,2),I3(2,3)];
        q=imrotate(P,180);
        D=[512,512,1;1,512,1;1,1,1;512,1,1].';
        T=[200,200,1;1,200,1;1,1,1;200,1,1].';
    elseif I3(4,1)==1
        bin=[I3(2,3),I3(3,3),I3(3,2),I3(2,2)];
        q=imrotate(P,90);
        D=[1,512,1;1,1,1;512,1,1;512,512,1].';
        T=[1,200,1;1,1,1;200,1,1;200,200,1].';
    elseif I3(4,4)==1
        bin=[I3(2,2),I3(2,3),I3(3,3),I3(3,2)];
        q=P;
        D=[1,1,1;512,1,1;512,512,1;1,512,1].';
        T=[1,1,1;200,1,1;200,200,1;1,200,1].';
%     elseif I3(4,4)==1
%         D=[512,512,1;1,512,1;1,1,1;512,1,1].';
        
 
end
%   bin=[I3(2,2),I3(2,3),I3(3,3),I3(3,2)];
%  
  dec=binaryVectorToDecimal(bin);
%  tform1 = fitgeotrans(D1,C1,'Projective');
%  Prr=imwarp(P,tform);
 
%  [y3,x3] = find(P);
% [~,loc1] = min(y3+x3);
% C3 = [x3(loc1),y3(loc1)];
% [~,loc1] = min(y3-x3);
% C3(2,:) = [x3(loc1),y3(loc1)];
% [~,loc1] = max(y3+x3);
% C3(3,:) = [x3(loc1),y3(loc1)];
% [~,loc1] = max(y3-x3);
% C3(4,:) = [x3(loc1),y3(loc1)];
% figure(1),imshow(P); hold on
% plot(C3(:,1),C3(:,2),'r.','MarkerSize',30);hold off
% % D1=[1,1;400,1;400,700;1,700];
% tform = fitgeotrans(C3,D1,'Projective');
    
 
 
 
figure, imshow(q);

	message = sprintf('ID of the tag = %d', dec);
	text(60,30, message, 'Color', 'r');
%     img5=imgaussfilt3(P);%smooth it 
%     img6=im2bw(img5,0.8);
%     img7=imcomplement(img6);
% %     refg=regionprops(img7,'BoundingBox');
% %     img8=imcrop(img7,refg(2).BoundingBox);
%     
%    
%       LB4 = 3000; LB3 = 260000;
% UB4 = 6000;
% UB3 = 270000;
% Iout31 = xor(bwareaopen(img6,LB4),  bwareaopen(img6,UB4));
% Iout41 = xor(bwareaopen(img6,LB3),  bwareaopen(img6,UB3));
% Iout23=xor(Iout31,Iout41);
% ss2=size(P);
% z2=(zeros(ss2));
% the_frame1=z2+Iout23;
% fra2=imcomplement(the_frame1);
% 
% 
% I24 = imclearborder(im2bw(fra2));
% 
% 
% %  img6 = bwareaopen(img4,20);
% %  BW2 = bwareafilt(img4,3,'smallest');
% %  imshow(BW2);
% %   LB2 = 30000; LB1 = 500;
% % UB2 = 80000;
% % UB1 = 2000;
% 
% % ss1=size(img1);
% % z=(zeros(ss));
% % the_frame=z+Iout;
% % fra=imcomplement(the_frame);
% %     regg=regionprops(im2bw(P),'BoundingBox');
% %     io=imcrop(P,regg(1).BoundingBox);
% %     imshow(io);

 
%% 3. Find each of the four corners of the tag

[y,x] = find(I2);
[~,loc] = min(y+x);
C = [x(loc),y(loc)];
[~,loc] = min(y-x);
C(2,:) = [x(loc),y(loc)];
[~,loc] = max(y+x);
C(3,:) = [x(loc),y(loc)];
[~,loc] = max(y-x);
C(4,:) = [x(loc),y(loc)];
% L = mean(C([1 4],1));
% R = mean(C([2 3],1));
% U = mean(C([1 2],2));
% % D = mean(C([3 4],2));
% figure(1),imshow(img1); hold on
% plot(C(:,1),C(:,2),'r.','MarkerSize',30);
 C=[C ones(size(C,1),1)].';
%% 4. Homography
% tagg=imread('ref_marker.jpg');
% T=[1,1,1;200,1,1;200,200,1;1,200,1].';
ref=imread('lena.png');
% lena=imresize(ref,0.2);

    

H =  homography2d(D,C);
G=H/H(3,3); 
for i=1:512
for j=1:512
v1 = [i;j;1];
v2 = G*v1;
v3 =v2/v2(3,1);  
img1(floor(v3(2,1)),floor( v3(1,1)),1)=ref(j,i,1);
img1(floor(v3(2,1)),floor( v3(1,1)),2)=ref(j,i,2);
img1(floor(v3(2,1)),floor( v3(1,1)),3)=ref(j,i,3); 
end 
end
figure(2),imshow(img1);


%      fun = @(block_struct)...
%      mean2(block_struct.data);
% B=blockproc(I1,[25 25],fun);
% B(B==255)=1;
% bin=B(4:5,4:5);
%  re=reshape(bin,[1 4]);
%  dec=binaryVectorToDecimal(re);
%  


% C2 = [L U; R U; R D; L D];
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



K =[1406.08415449821,0,0;
    2.20679787308599, 1417.99930662800,0;
    1014.13643417416, 566.347754321696,1]';

H2=homography2d(T,C);
G2=H2/H2(3,3);

h1=G2(:,1);h2=G2(:,2);
h3=G2(:,3);
const=((norm((inv(K)*h1))+ norm((inv(K)*h2)))/2)^-1;
B=const*inv(K)*G2;
b1=B(:,1);b2=B(:,2);b3=B(:,3);
r1 = const*b1 ; r2 = const*b2 ; r3 = cross(r1,r2) ; t = const*b3;

RT=[r1,r2,r3,t];
Projection=K*RT;
  

 
 

