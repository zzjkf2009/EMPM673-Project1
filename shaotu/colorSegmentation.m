% This the code for color segmentation


Video=VideoReader('detectbuoy.avi');

for img=1:Video.NumberOfFrame
filename=strcat('frame',num2str(img),'.jpg');
b=read(Video,img);
testFrame=fullfile('D:\','Cygwin','home','shaot','ENPM673 - Project 1','P1_submission','ColorSeg','Images','TestSet','Frames',filename);
trainingFrame=fullfile('D:\','Cygwin','home','shaot','ENPM673 - Project 1','P1_submission','ColorSeg','Images','TrainingSet','Frames',filename);

imwrite(b,filename);
figure(1),imshow(b,[]);
end 

frame=imread('frame1.jpg');
%Detect red color object in frame
Red=frame(:,:,1);

%RedG=imgaussfilt(Red,2);

%imshow(BW);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%
% use roipoly to crop red color buoy
RedMask=uint8(roipoly(frame); % transfer binary to uint8
% tranfer RedMask (480*640 uint8) to RedMask3 (480*640*3 uint8)

%!!!for loop cause problem!!!
RedMask3(:,:,1)=RedMask;
RedMask3(:,:,2)=RedMask;
RedMask3(:,:,3)=RedMask;
%crop red buoy using mask
grayRed1=frame(:,:,1).*RedMask3(:,:,1);
grayRed2=frame(:,:,2).*RedMask3(:,:,2);
grayRed3=frame(:,:,3).*RedMask3(:,:,3);

CropRed(:,:,1)=grayRed1;
CropRed(:,:,2)=grayRed2;
CropRed(:,:,3)=grayRed3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use roipoly to crop green color buoy
GreenMask=uint8(roipoly(frame));
% transfer GreenMask (480*640 uint8) to GreenMask3 (480*640*3 uint8)

% !!!for loop cause problem!!!!
GreenMask3(:,:,1)=GreenMask;
GreenMask3(:,:,2)=GreenMask;
GreenMask3(:,:,3)=GreenMask;
%crop green using mask
grayGreen1=frame(:,:,1).*GreenMask3(:,:,1);
grayGreen2=frame(:,:,2).*GreenMask3(:,:,2);
grayGreen3=frame(:,:,3).*GreenMask3(:,:,3);

CropGreen(:,:,1)=grayGreen1;
CropGreen(:,:,2)=grayGreen2;
CropGreen(:,:,3)=grayGreen3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use roipoly to crop yellow color buoy
YellowMask=uint8(roipoly(frame));
%!!!! has problem if use for loop
 YellowMask3(:,:,1)=YellowMask;
  YellowMask3(:,:,2)=YellowMask;
   YellowMask3(:,:,3)=YellowMask;
% transfer GreenMask (480*640 uint8) to GreenMask3 (480*640*3 uint8)
%crop green using mask
grayYellow1=frame(:,:,1).*YellowMask3(:,:,1);
grayYellow2=frame(:,:,2).*YellowMask3(:,:,2);
grayYellow3=frame(:,:,3).*YellowMask3(:,:,3);

CropYellow(:,:,1)=grayYellow1;
CropYellow(:,:,2)=grayYellow2;
CropYellow(:,:,3)=grayYellow3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part2 
% compute and vitualize average color histogram for each color channel
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find nonzero elements for matrix
hRed1=nonzeros(grayRed1);
hRed2=nonzeros(grayRed2);
hRed3=nonzeros(grayRed3);

hGreen1=nonzeros(grayGreen1);
hGreen2=nonzeros(grayGreen2);
hGreen3=nonzeros(grayGreen3);

hYellow1=nonzeros(grayYellow1);
hYellow2=nonzeros(grayYellow2);
hYellow3=nonzeros(grayYellow3);

%
% find mean of each color buoy in each RGB channel
MhRed1=mean(hRed1);
MhRed2=mean(hRed2);
MhRed3=mean(hRed3);

MhGreen1=mean(hGreen1);
MhGreen2=mean(hGreen2);
MhGreen3=mean(hGreen3);

MhYellow1=mean(hGreen1);
MhYellow2=mean(hGreen2);
MhYellow3=mean(hGreen3);

% plot histogram of each color buoy in each RGB channel

meanRed=[MhRed1 MhRed2 MhRed3];
meanGreen=[MhGreen1 MhGreen2 MhGreen3];
meanYellow=[MhYellow1 MhYellow2 MhYellow3];

figure(1),bar(meanRed);
title('Red Buoy');
set(gca,'XTickLabel',{'Red','Green','Blue'}) %set x-axis
xlabel('Color Channel'),ylabel('Value')  %set label for x and y axis


figure(2),bar(meanGreen);
title('Green Buoy');
set(gca,'XTickLabel',{'Red','Green','Blue'}) %set x-axis
xlabel('Color Channel'),ylabel('Value')  %set label for x and y axis

figure(3),bar(meanYellow);
title('Yellow Buoy');
set(gca,'XTickLabel',{'Red','Green','Blue'}) %set x-axis
xlabel('Color Channel'),ylabel('Value')  %set label for x and y axis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















