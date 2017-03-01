clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute and vitualize average color histogram for each color channel
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Croped buoy image
% !!!!! add 'Image' folder to path!!!
%CropRed=imread(fullfile('TrainingSet','CroppedBuoys','red_frame1.jpg'));
CropRed=imread('red_frame1.jpg');
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

%find normal distribution for Red buoy each channel
NormalRed1=fitdist(hRed1,'Normal');
NormalRed2=fitdist(hRed2,'Normal');
NormalRed3=fitdist(hRed3,'Normal');

%{
NormalRed1=fitdist(CropRed(:,:,1),'Normal');
NormalRed2=fitdist(CropRed(:,:,2),'Normal');
NormalRed3=fitdist(CropRed(:,:,3),'Normal');
%}

%find normal distribution for Green Buoy each channel
NormalGreen1=fitdist(hGreen1,'Normal');
NormalGreen2=fitdist(hGreen2,'Normal');
NormalGreen3=fitdist(hGreen3,'Normal');

%find normal distirbtion for Yellow Buoy each channel
NormalYellow1=fitdist(hYellow1,'Normal');
NormalYellow2=fitdist(hYellow2,'Normal');
NormalYellow3=fitdist(hYellow3,'Normal');

% Extract mean value from normal distribution
meanRed=[NormalRed1.mu NormalRed2.mu NormalRed3.mu];
meanGreen=[NormalGreen1.mu NormalGreen2.mu NormalGreen3.mu];
meanYellow=[NormalYellow1.mu NormalYellow2.mu NormalYellow3.mu];

%Plot average value histogram
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

%Plot 1_D Gaussian distribution
step=0:1:255;
NormRed1=normpdf(step,NormalRed1.mu,NormalRed1.sigma);
NormRed2=normpdf(step,NormalRed2.mu,NormalRed2.sigma);
NormRed3=normpdf(step,NormalRed3.mu,NormalRed3.sigma);

figure(4),plot(step,NormRed1,'red');
xlabel('Value');
ylabel('Proportion');
title('1D Gaussian Distrbution of Red Buoy in Each Color Channel');
hold on;
plot(step,NormRed2,'green');
hold on;
plot(step,NormRed3,'blue');

NormGreen1=normpdf(step,NormalGreen1.mu,NormalGreen1.sigma);
NormGreen2=normpdf(step,NormalGreen2.mu,NormalGreen2.sigma);
NormGreen3=normpdf(step,NormalGreen3.mu,NormalGreen3.sigma);

figure(5),plot(step,NormGreen1,'red');
title('1D Gaussian Distrbution of Green Buoy in Each Color Channel');
xlabel('Value');
ylabel('Proportion');
hold on;
plot(step,NormGreen2,'green');
hold on;
plot(step,NormGreen3,'blue');

NormYellow1=normpdf(step,NormalYellow1.mu,NormalYellow1.sigma);
NormYellow2=normpdf(step,NormalYellow2.mu,NormalYellow2.sigma);
NormYellow3=normpdf(step,NormalYellow3.mu,NormalYellow3.sigma);

figure(6), plot(step,NormYellow1,'red');
title('1D Gaussian Distrbution of Yellow Buoy in Each Color Channel');
xlabel('Value');
ylabel('Proportion');
hold on;
plot(step,NormYellow2,'green');
hold on;
plot(step,NormYellow3,'blue'); 