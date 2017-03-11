v = VideoReader('Tag0.mp4');%use this to read the video in frames
for img = 1:3
    filename=strcat('frame',num2str(img),'.jpg');
    b=read(v,img);imwrite(b,filename);
end
%% 1. Extracting the Frame
tic
img1=imread('frame1.jpg');%read a random frame
IMG=img1;%duplicate
img2=imgaussfilt3(img1);%smooth it 
img3=rgb2gray(img2);
img4=imbinarize(img3);
  LB2 = 30000; LB1 = 500;UB2 = 80000;UB1 = 2000;%setting the limits of paper and tag so as to extract it
Iout1 = xor(bwareaopen(img4,LB2),  bwareaopen(img4,UB2));
Iout2 = xor(bwareaopen(img4,LB1),  bwareaopen(img4,UB1));
Iout=xor(Iout1,Iout2);
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
D1=[1,1;400,1;400,700;1,700];
tform = fitgeotrans(C1,D1,'Projective');
C1=[C1 ones(size(C1,1),1)].';
D1=[D1 ones(size(D1,1),1)].';
Paper=imwarp(Iout,tform);
P=imwarp(img1,tform);
reg=regionprops(Paper,'BoundingBox');
cro=imcrop(Paper,reg(2).BoundingBox);
%% 3.Finding Corners of Tag
[y,x] = find(I2);
[~,loc] = min(y+x);
C = [x(loc),y(loc)];
[~,loc] = min(y-x);
C(2,:) = [x(loc),y(loc)];
[~,loc] = max(y+x);
C(3,:) = [x(loc),y(loc)];
[~,loc] = max(y-x);
C(4,:) = [x(loc),y(loc)];
%% 4.Tag Id and Orientation
[w,z]=size(cro);
w1=ceil(w/4);z1=ceil(z/4);
fun = @(block_struct)...
mean2((block_struct.data));
I3 = blockproc(cro,[w1 z1],fun);
 I3((I3<0.5))=0;
  I3((I3>=0.5))=1;
if I3(1,4)==1
        bin=[I3(3,2),I3(2,2),I3(2,3),I3(3,3)];
        q=imrotate(P,270);
        C=[C(2,:);C(3,:);C(4,:);C(1,:)];
    elseif I3(1,1)==1  
        bin=[I3(3,3),I3(3,2),I3(2,2),I3(2,3)];
        q=imrotate(P,180);
        C=[C(3,:);C(4,:);C(1,:);C(2,:)];
    elseif I3(4,1)==1
        bin=[I3(2,3),I3(3,3),I3(3,2),I3(2,2)];
        q=imrotate(P,90);
        C=[C(4,:);C(1,:);C(2,:);C(3,:)];
    elseif I3(4,4)==1
        bin=[I3(2,2),I3(2,3),I3(3,3),I3(3,2)];
        q=P;
        C=C;      
end

  dec=binaryVectorToDecimal(bin);
figure(1), imshow(q);hold on
message = sprintf('ID of the tag = %d', dec);
text(100,200, message, 'Color', 'r'); 
C=[C ones(size(C,1),1)].';
%% 4. Homography and Placing Lena

ref=imread('lena.png');


 D=[1,1,1;512,1,1;512,512,1;1,512,1].';

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
figure(2),imshow(img1);hold on

%% 5.Cube


K =[1406.08415449821,0,0;
    2.20679787308599, 1417.99930662800,0;
    1014.13643417416, 566.347754321696,1]';
T=[0,1,1;200,1,1;200,200,1;1,200,1].';
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

  cube=[1,1,0,1;200,1,0,1;200,200,0,1;1,200,0,1;1,1,-0.05,1;200,1,-0.05,1;200,200,-0.05,1;1,200,-0.05,1];
  P1=Projection*cube(1,:).';
  P1=floor(P1/P1(3,1));
  P2=Projection*cube(2,:).';
  P2=floor(P2/P2(3,1));
  P3=Projection*cube(3,:).';
  P3=floor(P3/P3(3,1));
  P4=Projection*cube(4,:).';
  P4=floor(P4/P4(3,1));
  P5=Projection*cube(5,:).';
  P5=floor(P5/P5(3,1));
  P6=Projection*cube(6,:).';
  P6=floor(P6/P6(3,1));
  P7=Projection*cube(7,:).';
  P7=floor(P7/P7(3,1));
  P8=Projection*cube(8,:).';
  P8=floor(P8/P8(3,1));
 
figure,imshow(IMG);hold on
plot([P1(1),P2(1)],[P1(2),P2(2)],'Color','g','LineWidth',2)
plot([P2(1),P3(1)],[P2(2),P3(2)],'Color','g','LineWidth',2)
plot([P3(1),P4(1)],[P3(2),P4(2)],'Color','g','LineWidth',2)
plot([P4(1),P1(1)],[P4(2),P1(2)],'Color','g','LineWidth',2)
plot([P1(1),P5(1)],[P1(2),P5(2)],'Color','r','LineWidth',2)
plot([P2(1),P6(1)],[P2(2),P6(2)],'Color','r','LineWidth',2)
plot([P3(1),P7(1)],[P3(2),P7(2)],'Color','r','LineWidth',2)
plot([P4(1),P8(1)],[P4(2),P8(2)],'Color','r','LineWidth',2)
plot([P5(1),P6(1)],[P5(2),P6(2)],'Color','b','LineWidth',2)
plot([P6(1),P7(1)],[P6(2),P7(2)],'Color','b','LineWidth',2)
plot([P7(1),P8(1)],[P7(2),P8(2)],'Color','b','LineWidth',2)
plot([P8(1),P5(1)],[P8(2),P5(2)],'Color','b','LineWidth',2)
lol=toc