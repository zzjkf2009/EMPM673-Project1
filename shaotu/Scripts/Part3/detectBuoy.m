%This function is to segment and contour each colored Buoy
%Input: Frames
%Output: Images with contoured each color buoys

function []=detectBuoy(frame)

load('CroppedBuoy.mat');
load('CroppedGreenProps.mat');

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


GMMR=fitgmdist(double(NDCropRed),2);
GMMG=fitgmdist(double(NDCropGreen),2);
GMMY=fitgmdist(double(NDCropYellow),2);


muR1=GMMR.mu(1,:);
muR2=GMMR.mu(2,:);
covR1=GMMR.Sigma(:,:,1);
covR2=GMMR.Sigma(:,:,2);

muG1=GMMG.mu(1,:);
muG2=GMMG.mu(2,:);
covG1=GMMG.Sigma(:,:,1);
covG2=GMMG.Sigma(:,:,2);

muY1=GMMY.mu(1,:);
muY2=GMMY.mu(2,:);
covY1=GMMY.Sigma(:,:,1);
covY2=GMMY.Sigma(:,:,2);

[VR1,EigR1]=eig(covR1);
[VR2,EigR2]=eig(covR2);
[VG1,EigG1]=eig(covG1);
[VG2,EigG2]=eig(covG2);
[VY1,EigY1]=eig(covY1);
[VY2,EigY2]=eig(covY2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Threshold points in Ellipsoid
dframe=double(frame);


%Detect Red Buoy
w=1;
for i=1:480
    for j=1:640
        %Ellipsoid Threshold
        
        % Transfer coordinate using Eigenvector
        PR=reshape(dframe(i,j,:),[3 1]);
        VectorR1=PR-transpose(muR1);
        TVectorR1=VR1*VectorR1;
        
        VectorR2=PR-transpose(muR2);
        TVectorR2=VR2*VectorR2;
        
        %Check whether the points are inside Ellipsoid
        RBR1=((TVectorR1(1))/EigR1(3,3))^2;
        RBG1=((TVectorR1(2))/EigR1(2,2))^2;
        RBB1=((TVectorR1(3))/EigR1(1,1))^2;
        TR1=RBR1+RBG1+RBB1;
        
        RBR2=((TVectorR2(1))/EigR2(3,3))^2;
        RBG2=((TVectorR2(2))/EigR2(2,2))^2;
        RBB2=((TVectorR2(3))/EigR2(1,1))^2;
        TR2=RBR2+RBG2+RBB2;
        
        ThresholdR1(w)=TR1;
        ThresholdR2(w)=TR2;
        w=w+1;
        
       if (TR1<1 || TR2<1)
       %if TR1<1
       %if TR2<1
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
seY=strel('disk',20);
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
        %Ellipsoid Threshold
        
        % Transfer coordinate using Eigenvector
        PG=reshape(dframe(i,j,:),[3 1]);
        VectorG1=PG-transpose(muG1);
        TVectorG1=VG1*VectorG1;
        
        VectorG2=PG-transpose(muG2);
        TVectorG2=VG2*VectorG2;
        
        %Check whether the points are inside Ellipsoid
        GBR1=((TVectorG1(1))/EigG1(3,3))^2;
        GBG1=((TVectorG1(2))/EigG1(1,1))^2;
        GBB1=((TVectorG1(3))/EigG1(2,2))^2;
        TG1=GBR1+GBG1+GBB1;
        
        GBR2=((TVectorG2(1))/EigG2(3,3))^2;
        GBG2=((TVectorG2(2))/EigG2(1,1))^2;
        GBB2=((TVectorG2(3))/EigG2(2,2))^2;
        TG2=GBR2+GBG2+GBB2;
        
        ThresholdG1(v)=TG1;
        ThresholdG2(v)=TG2;
        v=v+1;
        
       if (TG1<1 || TG2<1)
       %if TG1<1
       %if TG2<1
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
if ~isempty(find(BuoyG,1))
BuoyGprops=regionprops(BuoyG);
if max(BuoyGprops(:).Area) > CroppedGreenProps.Area
    BuoyG=0;
else
    hold all;
imcontour(BuoyG,'green');

end
end


%Detect Yellow Buoy
u=1;
for i=1:480
    for j=1:640
        %Ellipsoid Threshold
        
        % Transfer coordinate using Eigenvector
        PY=reshape(dframe(i,j,:),[3 1]);
        VectorY1=PY-transpose(muY1);
        TVectorY1=VY1*VectorY1;
        
        VectorY2=PY-transpose(muY2);
        TVectorY2=VY2*VectorY2;
        
        %Check whether the points are inside Ellipsoid
        YBR1=((TVectorY1(1))/EigY1(3,3))^2;
        YBG1=((TVectorY1(2))/EigY1(2,2))^2;
        YBB1=((TVectorY1(3))/EigY1(1,1))^2;
        TY1=YBR1+YBG1+YBB1;
        
        YBR2=((TVectorY2(1))/EigY2(3,3))^2;
        YBG2=((TVectorY2(2))/EigY2(1,1))^2;
        YBB2=((TVectorY2(3))/EigY2(2,2))^2;
        TY2=YBR2+YBG2+YBB2;
        
        ThresholdY1(u)=TY1;
        ThresholdY2(u)=TY2;
        u=u+1;
        
       if (TY1<1 || TY2<1)
       %if TY1<1
       %if TY2<1
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


