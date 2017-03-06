clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute and vitualize average color histogram for each color channel
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Croped buoy image
% !!!!! add 'Image' folder to path!!!
%CropRed=imread(fullfile('TrainingSet','CroppedBuoys','red_frame1.jpg'));
CropRed=imread(fullfile('TrainingSet','CroppedBuoys','red_frame1.jpg'));
CropGreen=imread(fullfile('TrainingSet','CroppedBuoys','green_frame1.jpg'));
CropYellow=imread(fullfile('TrainingSet','CroppedBuoys','yellow_frame1.jpg'));
%CropYellow=imread('yellow_frame1.jpg');


%grayGropRed=rgb2gray(CropRed);

% find nonzero elements for matrix
hRed1=nonzeros(CropRed(:,:,1));
hRed2=nonzeros(CropRed(:,:,2));
hRed3=nonzeros(CropRed(:,:,3));

hGreen1=nonzeros(CropGreen(:,:,1));
hGreen2=nonzeros(CropGreen(:,:,2));
hGreen3=nonzeros(CropGreen(:,:,3));

hYellow1=nonzeros(CropYellow(:,:,1));
hYellow2=nonzeros(CropYellow(:,:,2));
hYellow3=nonzeros(CropYellow(:,:,3));

% Remove the edge noise caused by JPG file compression
% Set the threshold


hRed1(hRed1<200)=[];
hRed2(hRed2<30)=[];
hRed3(hRed3<15)=[];

hGreen1(hGreen1<10)=[];
hGreen2(hGreen2<200)=[];
hGreen3(hGreen3<8)=[];

hYellow1(hYellow1<200)=[];
hYellow2(hYellow2<200)=[];
hYellow3(hYellow3<15)=[];


%------------------------------------------------------------------------%
%histogram for three buoys
figure(1); 
hR1=histogram(hRed1,'Facecolor','r');
hold on;
hR2=histogram(hRed2,'Facecolor','g');
hold on;
hR3=histogram(hRed3,'Facecolor','b');
legend('R','G','B');
title('Red Buoy color distribution');
%!!! Change to the path in your own computer!!!
saveas(figure(1),'D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Output\Part0\R_hist.jpg');

figure(2); 
hG1=histogram(hGreen1,'Facecolor','r');
hold on;
hG2=histogram(hGreen2,'Facecolor','g');
hold on;
hG3=histogram(hGreen3,'Facecolor','b');
legend('R','G','B');
title('Green Buoy color distribution');
saveas(figure(2),'D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Output\Part0\G_hist.jpg');

figure(3); 
hY1=histogram(hYellow1,'Facecolor','r');
hold on;
hY2=histogram(hYellow2,'Facecolor','g');
hold on;
hY3=histogram(hYellow3,'Facecolor','b');
legend('R','G','B');
title('Yellow Buoy color distribution');
saveas(figure(3),'D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Output\Part0\Y_hist.jpg');

%-----------------------------------------------------------------------%

%-----------------------------------------------------------------------%
%scatter plot for color distribution
%Red Buoy color distirbution in scatter plot
uR=1;
vR=1;
wR=1;

for i=1:480
    for j=1:640
        if CropRed(i,j,1)>0 && CropRed(i,j,2)>0&& CropRed(i,j,3)>0
            RxR(uR,1)=CropRed(i,j,1); % Array of Sampled Red Buoy in R channel
            RxG(vR,1)=CropRed(i,j,2); % Array of Sampled Red Buoy in G channel
            RxB(wR,1)=CropRed(i,j,3); % Array of Sampled Red Buoy in B channel
            uR=uR+1;
            vR=vR+1;
            wR=wR+1;
        end
    end
end
figure(4);
scatter3(RxR,RxG,RxB,'.');
xlabel('R'),ylabel('G'),zlabel('B');
title('Red Buoy Color Distribution in Scatter Plot');
%!!! Change to the path in your own computer!!!
saveas(figure(4),'D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Output\Part0\R_Scatter.jpg');

%Green Buoy color distirbution in scatter plot
uG=1;
vG=1;
wG=1;

for i=1:480
    for j=1:640
        if CropGreen(i,j,1)>0 && CropGreen(i,j,2)>0&& CropGreen(i,j,3)>0
            GxR(uG,1)=CropGreen(i,j,1); % Array of Sampled Green Buoy in R channel
            GxG(vG,1)=CropGreen(i,j,2); % Array of Sampled Green Buoy in G channel
            GxB(wG,1)=CropGreen(i,j,3); % Array of Sampled Green Buoy in B channel
            uG=uG+1;
            vG=vG+1;
            wG=wG+1;
        end
    end
end
figure(5);
scatter3(GxR,GxG,GxB,'.');
xlabel('R'),ylabel('G'),zlabel('B');
title('Green Buoy Color Distribution in Scatter Plot');
%!!! Change to the path in your own computer!!!
saveas(figure(5),'D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Output\Part0\G_Scatter.jpg');


%Yellow Buoy color distribution in scatter plot
uY=1;
vY=1;
wY=1;

for i=1:480
    for j=1:640
        if CropYellow(i,j,1)>0 && CropYellow(i,j,2)>0&& CropYellow(i,j,3)>0
            YxR(uY,1)=CropYellow(i,j,1); % Array of Sampled Yellow Buoy in R channel
            YxG(vY,1)=CropYellow(i,j,2); % Array of Sampled Yellow Buoy in G channel
            YxB(wY,1)=CropYellow(i,j,3); % Array of Sampled Yellow Buoy in B channel
            uY=uY+1;
            vY=vY+1;
            wY=wY+1;
        end
    end
end
figure(6);
scatter3(YxR,YxG,YxB,'.');
xlabel('R'),ylabel('G'),zlabel('B');
title('Yellow Buoy Color Distribution in Scatter Plot');
%!!! Change to the path in your own computer!!!
saveas(figure(6),'D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Output\Part0\Y_Scatter.jpg');

%---------------------------------------------------------------------%
%save color sample data

%Red Buoy
RedSamples(:,1)=RxR;
RedSamples(:,2)=RxG;
RedSamples(:,3)=RxB;

%Green buoy
GreenSamples(:,1)=GxR;
GreenSamples(:,2)=GxG;
GreenSamples(:,3)=GxB;

%Yellow Buoy
YellowSamples(:,1)=YxR;
YellowSamples(:,2)=YxG;
YellowSamples(:,3)=YxB;
