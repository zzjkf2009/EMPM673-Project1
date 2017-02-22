%*@File runMe.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
%*@Brief This is the main code for detection the four corners of a ARtag
%        one frame of a video will be given, in this frame: one person is holding a
%        paper with ARtag on it, the code here will detect the corners of the tag
%*@Reference: Thanks for the toolbox from Peter Kovesi 
%%
clc 
clear
close all
im=imread('../Data/Tag8.jpg');
im=rgb2gray(im);    % Convert image from RGB to gray 
[Gmag,Gdir] = imgradient(im,'IntermediateDifference');
[row,col]=find(Gmag>0.60*max(max(Gmag)));
pts(1,:)=row;
pts(2,:)=col;  
%     figure, imshow(im);
%     hold on
%     scatter(col,row)
[cim, r, c] = harris(im, 1, .04, 'N', 20, 'display', true);
thDist=1.7;
thInlrRatio=0.07;
[corner]=RANSCA_corner(im,pts,c,r,thDist,thInlrRatio);
Num_corner_find=length(corner);
hold on
mapshow(corner(:,2),corner(:,1),'DisplayType','point','Marker','o');
% [nr,nc]=size(im);
% [dx,dy] = gradient(double(im));
% [x y] = meshgrid(1:nc,1:nr);
% u = dx;
% v = dy;
% hold on
% quiver(x,y,u,v)
%%
% clc
% clear 
% close all
% % % Read the image/ frame
% im=imread('../Data/Tag1.jpg');
% im=rgb2gray(im);    % Convert image from RGB to gray 
%     %figure(1), imshow(im); title('Gray');
% h = fspecial('gaussian',5,5); % Blur the image to remove the influence of the background
% Iblur=imfilter(im,h);
%     %figure(2), imshow(Iblur); title('Blured Image');
% 
% %[Gmag,Gdir] = imgradient(Iblur,'intermediate');
% %[Gx, Gy]=imgradientxy(im,'intermediate');
% %[Gx, Gy]=imgradientxy(Iblur,'intermediate');
% [Gmag,Gdir] = imgradient(im,'intermediate');
% [row,col]=find(Gmag>0.60*max(max(Gmag)));
% pts(1,:)=row;
% pts(2,:)=col;
%     figure, imshow(im);
%     hold on
%     scatter(col,row)
% %
% % Define the parameters for the RANSAC function to find the stright line
% % segment
% iterNum=round(length(row)/2);
% thDist=0.8;
% thInlrRatio=0.05;
% [ theta,rho,inlrNum] = ransac( pts,iterNum,thDist,thInlrRatio);
% % First set to get several possible lines to start with
% 
% 
% %[theta_out,rho_out,inlrNum_out,theta_store,rho_store]=EliminateLines(theta,rho,inlrNum)
% 
% [theta_draw,rho_draw]=finalLines(theta,rho,inlrNum);
% %
% Num_Lines=length(find(theta_draw));
% [height,width]=size(im);
% X=0:width;
% Y=zeros(Num_Lines,length(X));
% 
% figure, imshow(im);
% hold on 
% for i=1:Num_Lines;
% Y(i,:)=(rho_draw(i) - X* cos(theta_draw(i)))/ sin(theta_draw(i));
% plot(X,round(Y(i,:)));
% hold on
% end
% if(Num_Lines>1)
%     if(Num_Lines==2)
%         [xi, yi] = polyxpoly(X, Y(1,:), X, Y(2,:));
%       mapshow(xi,yi,'DisplayType','point','Marker','o');
%     end
% if(Num_Lines>2)
% for k=1:Num_Lines-1
%     for l=k+1:Num_Lines
% [xi, yi] = polyxpoly(X, Y(k,:), X, Y(l,:));
% mapshow(xi,yi,'DisplayType','point','Marker','o')
% hold on
%     end
% end
% end
% end
%%
% Find edges using the Canny operator with hysteresis thresholds of 0.1
    % and 0.2 with smoothing parameter sigma set to 1.
% edgeim = edge(Iblur,'canny', [0.2 0.4], 1);
% 
%     figure(2), imshow(edgeim); title('edge');
%%
% Y=round(Y);
% [in,on]=inpolygon(row,col,X,Y(1,:));
% points=pts(find(on));
% rad2deg(cos(theta_draw(:))/ sin(theta_draw(:)));
%%
% clear all;
% im=imread('../Data/Tag2.jpg');
% im=rgb2gray(im);    % Convert image from RGB to gray 
% [nr,nc]=size(im);
% [dx,dy] = gradient(double(im));
% [x y] = meshgrid(1:nc,1:nr);
% u = dx;
% v = dy;
% imshow(im);
% hold on
% quiver(x,y,u,v)
%%
im=imread('../Data/Tag8.jpg'); im=rgb2gray(im);    % Convert image from
% RGB to gray
im(im<200) = NaN; 
color = 50; 
im(im>0) = color;
figure, imshow(im)
hold on 
C = centerOfMass(im);
mapshow(C(1,2),C(1,1),'DisplayType','point','Marker','o');
%%
clear
close all
% im=imread('../Data/Tag4.jpg'); 
im=imread('../Data/Marker.jpg');
im=rgb2gray(im);  
newim = adjcontrast(im, 16, 0.7);
% figure
% imshow(newim)
[Gmag,Gdir] = imgradient(newim,'intermediate');
[row,col]=find(Gmag>0.60*max(max(Gmag)));
pts(1,:)=row;
pts(2,:)=col;
%     figure, imshow(newim);
%     hold on
%     scatter(col,row)
[cim, r, c] = harris(newim, 1, .04, 'N', 20, 'display', true);
thDist=1.7;
thInlrRatio=0.055;
[corner]=RANSCA_corner(newim,pts,c,r,thDist,thInlrRatio);
Num_corner_find=length(corner);
hold on
mapshow(corner(:,2),corner(:,1),'DisplayType','point','Marker','o');
%%
v=VideoReader('../Tag0.mp4');
video = readFrame(v,'native');
%%
clear
I1 = rgb2gray(imread('../Data/Tag4.jpg'));
I2 = rgb2gray(imread('../Data/ref_marker.png'));
% points1 = detectHarrisFeatures(I1);
% points2 = detectHarrisFeatures(I2);
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);
[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);
indexPairs = matchFeatures(features1,features2);
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
%%
I2 = imread('../Data/ref_marker.png');
A=ones(220);
for i=1:200
    for j=1:200
        A(i+10,j+10)=I2(i,j);
    end
end
figure, imshow(A);
