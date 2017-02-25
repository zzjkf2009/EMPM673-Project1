clc;
clear;

%Color segmentation applied gaussian filter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read frame into matrix
frame=imread('frame1.jpg');

%separate each rgb channel
frameR=frame(:,:,1);
frameG=frame(:,:,2);
frameB=frame(:,:,3);

%apply gaussin filter to each channel
%with stardard dervation sigma=2
GframeR=imgaussfilt(frameR);
GframeG=imgaussfilt(frameG);
GframeB=imgaussfilt(frameB);

%compress each channel back to frame after gaussin filter
Gframe(:,:,1)=GframeR;
Gframe(:,:,2)=GframeG;
Gframe(:,:,3)=GframeB;


%set the mean value from preivous step
%normal distribution for Red Buoy
MRed1=222.4992;
MRed2=181.3360;
MRed3=124.7600;
SigmaRed1=12.1218;
SigmaRed2=9.36878;
SigmaRed3=8.34032;

%normal distribution for Green buoy
MGreen1=150.0126;
MGreen2=217.3088;
MGreen3=137.7605;
SigmaGreen1=9.69417;
SigmaGreen2=10.6782;
SigmaGreen3=8.27476;

%normal distribution for Yellow Buoy
MYellow1=201.1416;
MYellow2=217.1908;
MYellow3=119.3234;
SigmaYellow1=11.9059;
SigmaYellow2=10.8482;
SigmaYellow3=8.26926;


% detect Red Buoy
%boundary condition for Red Buoy detection
%one * sigma
upRed1= uint8(MRed1+SigmaRed1);
downRed1=uint8(MRed1-SigmaRed1);
upRed2= uint8(MRed2+SigmaRed2);
downRed2=uint8(MRed2-SigmaRed2);
upRed3=uint8(MRed3+SigmaRed3);
downRed3=uint8(MRed3-SigmaRed3);


count=0;
ncount=0;

for i=1:480
    for j=1:640
        if (GframeR(i,j)>230) &&(230>GframeG(i,j))&&(GframeG(i,j)>120)&& (130> GframeB(i,j))&&(GframeB(i,j)>80)
         BuoyR(i,j)=GframeR(i,j);

        else
            BuoyR(i,j)=0;
        end
    end
end

figure (1),imshow(BuoyR);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%normal distribution for Yellow Buoy
MYellow1=201.1416;
MYellow2=217.1908;
MYellow3=119.3234;
SigmaYellow1=11.9059;
SigmaYellow2=10.8482;
SigmaYellow3=8.26926;


% detect Green Buoy
%boundary condition for Green Buoy detection
upGreen1= uint8(MGreen1+2*SigmaGreen1);
downGreen1=uint8(MGreen1-2*SigmaGreen1);
upGreen2= uint8(MGreen2+2*SigmaGreen2);
downGreen2=uint8(MGreen2-2*SigmaGreen2);
upGreen3=uint8(MGreen3+SigmaGreen3);
downGreen3=uint8(MGreen3-SigmaGreen3);


for i=1:480
    for j=1:640
       % if (upGreen1>GframeR(i,j))&& (GframeG(i,j)>downGreen1) && (upGreen2>GframeG(i,j))&&(GframeG(i,j)>downGreen2)&& (upGreen3> GframeB(i,j))&&(GframeB(i,j)>downGreen3)
       if(169>GframeR(i,j)) && (GframeG(i,j)>196) && (145>GframeB(i,j)) && (GframeB(i,j)>110)
         BuoyG(i,j,1)=GframeR(i,j);
         BuoyG(i,j,2)=GframeG(i,j);
         BuoyG(i,j,3)=GframeB(i,j);
         else
            BuoyG(i,j,1)=0;
            BuoyG(i,j,2)=0;
            BuoyG(i,j,3)=0;
        end
    end
end

figure (2),imshow(BuoyG);

% detect Yellow Buoy
%boundary condition for Yellow Buoy detection
upYellow1= uint8(MYellow1+2*SigmaYellow1);
downYellow1=uint8(MYellow1-2*SigmaYellow1);
upYellow2= uint8(MYellow2+2*SigmaYellow2);
downYellow2=uint8(MYellow2-2*SigmaYellow2);
upYellow3=uint8(MGreen3+2*SigmaYellow3);
downYellow3=uint8(MGreen3-2*SigmaYellow3);


for i=1:480
    for j=1:640
        if (255>GframeR(i,j))&& (GframeR(i,j)>220)&&(GframeG(i,j)>177) && (255>GframeG(i,j))&&(GframeG(i,j)>195)&& (125> GframeB(i,j))&&(GframeB(i,j)>100)
         BuoyY(i,j,1)=GframeR(i,j);
         BuoyY(i,j,2)=GframeG(i,j);
         BuoyY(i,j,3)=GframeB(i,j);
         else
            BuoyY(i,j,1)=0;
            BuoyY(i,j,2)=0;
            BuoyY(i,j,3)=0;
        end
    end
end



figure (3),imshow(BuoyY);











