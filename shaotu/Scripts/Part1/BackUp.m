%Back Up of Detect function using 3D gaussian 



%This function is to segment and contour each colored Buoy
%Input: Frames
%Output: Images with contoured each color buoys
%function []=detectBuoy(frame)

clc;
clear;
frame=imread('frame1.jpg');

frameR=reshape(frame,[480*640 3]);
load('CroppedBuoy.mat');

DCropRed=double(reshape(CropRed, [480*640 3]));
DCropGreen=double(reshape(CropGreen, [480*640 3]));
DCropYellow=double(reshape(CropYellow, [480*640 3]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Eliminate zero elements
u=1;
v=1;
w=1;

for i= 1:480*640
    if DCropRed(i,1)>0 && DCropRed(i,2)>0 && DCropRed(i,3)>0
        NDCropRed(u,:)=DCropRed(i,:);
        u=u+1;
    end
    
    if DCropGreen(i,1)>0 && DCropGreen(i,2)>0 && DCropGreen(i,3)>0
        NDCropGreen(v,:)=DCropGreen(i,:);
        v=v+1;
    end
    
    if DCropYellow(i,1)>0 && DCropYellow(i,2)>0 && DCropYellow(i,3)>0
        NDCropYellow(w,:)=DCropYellow(i,:);
        w=w+1;
    end
end

[muR covR]=estimate(NDCropRed);
[muG covG]=estimate(NDCropGreen);
[muY covY]=estimate(NDCropYellow);

[VR,EigR]=eig(covR);
[VG,EigG]=eig(covG);
[VY,EigY]=eig(covY);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Threshold points in Ellipsoid
dframe=double(frame);
%{
%Detect Red Buoy
w=1;
for i=1:480
    for j=1:640
        %Ellipsoid Threshold
        %{
        RBR=((dframe(i,j,1)- muR(1))/EigR(1,1))^2;
        RBG=((dframe(i,j,2)- muR(2))/EigR(2,2))^2;
        RBB=((dframe(i,j,3)- muR(3))/EigR(3,3))^2;
                
        TR=RBR+RBG+RBB;
        ThresholdR(w)=TR;
        w=w+1;
        %}
        
        PR=reshape(dframe(i,j,:),[3 1]);
        VectorR=PR-transpose(muR);
        TVectorR=VR*VectorR;
        
        
        RBR=((TVectorR(1))/EigR(3,3))^2;
        RBG=((TVectorR(2))/EigR(2,2))^2;
        RBB=((TVectorR(3))/EigR(1,1))^2;
        TR=RBR+RBG+RBB;
        ThresholdR(w)=TR;
        w=w+1;

    
        if TR<1
            BuoyR(i,j,1)=(frame(i,j,1));
            BuoyR(i,j,2)=(frame(i,j,2));
            BuoyR(i,j,3)=(frame(i,j,3));
        else
            BuoyR(i,j,1)=0;
            BuoyR(i,j,2)=0;
            BuoyR(i,j,3)=0;

        end
    end
end

BuoyR=uint8(BuoyR);
BuoyR=rgb2gray(BuoyR);
BuoyR=imbinarize(BuoyR);
BuoyR=bwareaopen(BuoyR,50);
BuoyR=imfill(BuoyR, 'holes');
seY=strel('disk',70);
BuoyR=imclose(BuoyR,seY);

% Plot contour
figure (1),imshow(frame);
title('Colored Buoy Contour');
hold all;
imcontour(BuoyR,'red');
%}

%Detect Green Buoy
v=1;
for i=1:480
    for j=1:640
        %{
        GBR=((dframe(i,j,1)- muG(1))/EigG(1,1))^2;
        GBG=((dframe(i,j,2)- muG(2))/EigG(2,2))^2;
        GBB=((dframe(i,j,3)- muG(3))/EigG(3,3))^2;
        
        %TG=2*GBR+3*GBG+2*GBB;
        TG=GBR+GBG+GBB;
        ThresholdG(v)=TG;
        v=v+1;
        %}
        PG=reshape(dframe(i,j,:),[3 1]);
        VectorG=PG-transpose(muG);
        TVectorG=VG*VectorG;
        
        
        GBR=((TVectorG(1))/EigG(3,3))^2;
        GBG=((TVectorG(2))/EigG(1,1))^2;
        GBB=((TVectorG(3))/EigG(2,2))^2;
        TG=GBR+GBG+GBB;
        ThresholdG(v)=TG;
        v=v+1;
        if TG<1
            BuoyG(i,j,1)=(frame(i,j,1));
            BuoyG(i,j,2)=(frame(i,j,2));
            BuoyG(i,j,3)=(frame(i,j,3));
        else
            BuoyG(i,j,1)=0;
            BuoyG(i,j,2)=0;
            BuoyG(i,j,3)=0;
        end
    end
end


%Binary image processing
BuoyG=uint8(BuoyG);
BuoyG=rgb2gray(BuoyG);
BuoyG=imbinarize(BuoyG);
BuoyG=bwareaopen(BuoyG,80);
BuoyG=imfill(BuoyG, 'holes');
seY=strel('disk',20);
BuoyG=imclose(BuoyG,seY);

imshow(BuoyG);

%{
%Plot Green Buoy and its contour 
hold all;
imcontour(BuoyG,'green');
%}

%{
%Detect Yellow Buoy
u=1;
%TmuY=VY*transpose(muY);


for i=1:480
    for j=1:640
        %{
        YBR=((dframe(i,j,1)- muY(1))/EigY(1))^2;
        YBG=((dframe(i,j,2)- muY(2))/EigY(2))^2;
        YBB=((dframe(i,j,3)- muY(3))/EigY(3))^2;
        %}
        
        %TG=2*GBR+3*GBG+2*GBB;
        %TY=YBR+YBG+100*YBB;
        PY=reshape(dframe(i,j,:),[3 1]);
        VectorY=PY-transpose(muY);
        TVectorY=VY*VectorY;
        
        
        YBR=((TVectorY(1))/EigY(3,3))^2;
        YBG=((TVectorY(2))/EigY(1,1))^2;
        YBB=((TVectorY(3))/EigY(2,2))^2;
        TY=YBR+YBG+YBB;
        ThresholdY(u)=TY;
        
        u=u+1;
        if TY<1
            BuoyY(i,j,1)=(frame(i,j,1));
            BuoyY(i,j,2)=(frame(i,j,2));
            BuoyY(i,j,3)=(frame(i,j,3));
        else
            BuoyY(i,j,1)=0;
            BuoyY(i,j,2)=0;
            BuoyY(i,j,3)=0;
        end
    end
end
imshow(BuoyY);


%Binary image processing
BuoyY=uint8(BuoyY);
BuoyY=rgb2gray(BuoyY);
BuoyY=imbinarize(BuoyY);
BuoyY=bwareaopen(BuoyY,30);
BuoyY=imfill(BuoyY, 'holes');
seY=strel('disk',30);
BuoyY=imclose(BuoyY,seY);

%Plot Green Buoy and its contour 
hold all;
imcontour(BuoyY,'Yellow');

%}

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Red Buoy Detection
% Get Red buoy boundary value from colorSegmentation.m 
upRed1= uint8(NormalRed1.mu+2*NormalRed1.sigma);
downRed1= uint8(NormalRed1.mu-2*NormalRed1.sigma);
upRed2= uint8(NormalRed2.mu+2*NormalRed2.sigma);
downRed2= uint8(NormalRed2.mu-2*NormalRed2.sigma);
upRed3= uint8(NormalRed3.mu+2*NormalRed3.sigma);
downRed3= uint8(NormalRed3.mu-2*NormalRed3.sigma);

% extract Red Buoy
for i=1:480
    for j=1:640
        if (frameR(i,j)>downRed1)&& (frameR(i,j)<upRed1) &&(upRed2>frameG(i,j))&&(frameG(i,j)>downRed2)&& (upRed3> frameB(i,j))&&(frameB(i,j)>downRed3)
         BuoyR(i,j)=(frameR(i,j));

        else
            BuoyR(i,j)=0;
        end
    end
end

%Binary image processing
BuoyR=uint8(BuoyR);
BuoyR=imbinarize(BuoyR);
BuoyR=bwareaopen(BuoyR,10);
BuoyR=imfill(BuoyR, 'holes');
seY=strel('disk',30);
BuoyR=imclose(BuoyR,seY);

% Plot contour
figure (1),imshow(frame);
title('Colored Buoy Contour');
hold all;
imcontour(BuoyR,'red');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Green Buoy Detection
%Get Green Buoy boundary Value from colorSegmentation.m 
upGreen1= uint8(NormalGreen1.mu+2*NormalGreen1.sigma);
downGreen1= uint8(NormalGreen1.mu-2*NormalGreen1.sigma);
upGreen2= uint8(NormalGreen2.mu+2*NormalGreen2.sigma);
downGreen2= uint8(NormalGreen2.mu-2*NormalGreen2.sigma);
upGreen3= uint8(NormalGreen3.mu+2*NormalGreen3.sigma);
downGreen3= uint8(NormalGreen3.mu-2*NormalGreen3.sigma);

% extract Green Buoy
for i=1:480
    for j=1:640
        if (frameR(i,j)>downGreen1)&& (frameR(i,j)<upGreen1) &&(upGreen2>frameG(i,j))&&(frameG(i,j)>downGreen2)&& (upGreen3> frameB(i,j))&&(frameB(i,j)>downGreen3)
         BuoyG(i,j)=(frameR(i,j));

        else
            BuoyG(i,j)=0;
        end
    end
end

%Binary image processing
BuoyG=uint8(BuoyG);
BuoyG=imbinarize(BuoyG);
BuoyG=bwareaopen(BuoyG,20);
BuoyG=imfill(BuoyG, 'holes');
seY=strel('disk',10);
BuoyG=imclose(BuoyG,seY);

%Plot Green Buoy and its contour 
hold all;
imcontour(BuoyG,'green');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Green Buoy Detection
%Get Green Buoy boundary Value from colorSegmentation.m 
upYellow1= uint8(NormalYellow1.mu+2*NormalGreen1.sigma);
downYellow1= uint8(NormalYellow1.mu-2*NormalGreen1.sigma);
upYellow2= uint8(NormalYellow2.mu+2*NormalGreen2.sigma);
downYellow2= uint8(NormalYellow2.mu-2*NormalGreen2.sigma);
upYellow3= uint8(NormalYellow3.mu+2*NormalGreen3.sigma);
downYellow3= uint8(NormalYellow3.mu-2*NormalGreen3.sigma);


% extract Yellow Buoy
for i=1:480
    for j=1:640
        if (frameR(i,j)>downYellow1)&& (frameR(i,j)<upYellow1) &&(upYellow2>frameG(i,j))&&(frameG(i,j)>downYellow2)&& (upYellow3> frameB(i,j))&&(frameB(i,j)>downYellow3)
         BuoyY(i,j)=(frameR(i,j));

        else
            BuoyY(i,j)=0;
        end
    end
end

%Binary image processing
BuoyY=uint8(BuoyY);
BuoyY=imbinarize(BuoyY);
BuoyY=bwareaopen(BuoyY,50);
BuoyY=imfill(BuoyY, 'holes');
seY=strel('disk',20);
BuoyY=imclose(BuoyY,seY);

%Plot Green Buoy and its contour 
hold all;
imcontour(BuoyY,'Yellow');

%}

%end
