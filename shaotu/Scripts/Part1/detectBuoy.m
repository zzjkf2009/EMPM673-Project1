%This function is to segment and contour each colored Buoy
%Input: Frames
%Output: Images with contoured each color buoys

function []=detectBuoy(frame)

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

%Detect Red Buoy
w=1;
for i=1:480
    for j=1:640
        %Ellipsoid Threshold
        
        % Transfer coordinate using Eigenvector
        PR=reshape(dframe(i,j,:),[3 1]);
        VectorR=PR-transpose(muR);
        TVectorR=VR*VectorR;
        
        %Check whether the points are inside Ellipsoid
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

%Binary Image Processing
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


%Detect Green Buoy

v=1;
for i=1:480
    for j=1:640

        % Transfer coordinate using Eigenvector
        PG=reshape(dframe(i,j,:),[3 1]);
        VectorG=PG-transpose(muG);
        TVectorG=VG*VectorG;
        
        %Check whether the points are inside Ellipsoid
        GBR=((TVectorG(1))/EigG(3,3))^2;
        GBG=((TVectorG(2))/EigG(1,1))^2;
        GBB=3*((TVectorG(3))/EigG(2,2))^2;
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
seY=strel('disk',40);
BuoyG=imclose(BuoyG,seY);


%Plot Green Buoy and its contour 
hold all;
imcontour(BuoyG,'green');



%Detect Yellow Buoy
u=1;

for i=1:480
    for j=1:640

        % Transfer coordinate using Eigenvector
        PY=reshape(dframe(i,j,:),[3 1]);
        VectorY=PY-transpose(muY);
        TVectorY=VY*VectorY;
        
        %Check whether the points are inside Ellipsoid
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


%Plot Binary image
figure(2);
binaryBuoy=BuoyR+BuoyG+BuoyY;
imshow(binaryBuoy);
title('Binary Image for Detected Buoy');

end
