% Modified Segment1D_frame
%!!!!!!!!!Run colorSegmentation.m before run this script. 
% read frame into matrix

v = VideoReader('detectbuoy.avi');

while hasFrame(v)
    frame=readFrame(v);

%separate each rgb channel
%frame=imread('frame180.jpg');
%frameR=imgaussfilt(frame(:,:,1));
%frameG=imgaussfilt(frame(:,:,2));
%frameB=imgaussfilt(frame(:,:,3));
frameR=frame(:,:,1);
frameG=frame(:,:,2);
frameB=frame(:,:,3);


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

end