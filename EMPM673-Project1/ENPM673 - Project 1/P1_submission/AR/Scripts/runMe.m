%*@File runMe.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
%*@Brief This is the main code for detection the four corners of a ARtag
%        one frame of a video will be given, in this frame: one person is holding a
%        paper with ARtag on it, the code here will detect the corners of the tag
%*@Reference: Thanks for the toolbox from Peter Kovesi 




%%
% clear all
% close all
% im=imread('../Data/ref_marker.png');
% % %im=imread('../Data/Tag7.jpg');
% im=rgb2gray(im);    % Convert image from
% % % RGB to gray
% % im(im<200) = NaN; 
% % color = 255; 
% % im(im>200) = color;
% [y x] = find( im );
% cent = [mean(x) mean(y)];
%   figure, imshow(im)
%  hold on 
% % C = centerOfMass(im);
% %mapshow(C(1,2),C(1,1),'DisplayType','point','Marker','o');
% mapshow(cent(1),cent(2),'DisplayType','point','Marker','o');
%%
clear
close all
im=imread('../Data/Tag6.jpg'); 
%im=imread('../Data/Marker.jpg');
%im=imread('../Data/rotated.jpg');
im=rgb2gray(im);  
%newim = adjcontrast(im, 16, 0.7);
BW_im=im2bw(im,0.8);
% figure
% imshow(newim)

se = strel('disk',6);
closeBW = imclose(BW_im,se);
figure, imshow(closeBW); title('close the hole inside the tag')

[Gmag,Gdir] = imgradient(BW_im,'intermediate');
[row,col]=find(Gmag>0.60*max(max(Gmag)));
pts(1,:)=row;
pts(2,:)=col; 
%     hold on
%     scatter(col,row)
[~, r, c] = harris(BW_im, 1, .04, 'N', 20, 'display', true);
thDist=1.7; thInlrRatio=0.05;
[corner]=RANSCA_corner(BW_im,pts,c,r,thDist,thInlrRatio);
[OutCorner]=SortCornersCW(corner);
Num_corner_find=length(OutCorner);
hold on
plot(OutCorner(:,2),OutCorner(:,1),'Color','y','Marker','o');
hold off
status = regionprops(BW_im,'BoundingBox','Orientation','Centroid');
[~, r_fill, c_fill] = harris(closeBW, 1, .04, 'N', 20, 'display', true);
[corner_inner,outStandInnerCorner]=FindInnerCorners(r_fill,c_fill,status(2).Centroid,OutCorner);
figure, imshow(BW_im)
hold on, plot(corner_inner(:,1),corner_inner(:,2),'Color','r','Marker','o');
hold off
[InnerCorner]=SortCornersCW(corner_inner);

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
% % v=VideoReader('../Tag0.mp4');
% % video = readFrame(v,'native');
%%
% clear
% close all
% im=imread('../Data/Tag5.jpg'); 
% im=rgb2gray(im); 
% BW=im2bw(im,0.8);
% figure, imshow(BW)
% status = regionprops(BW,'BoundingBox','Orientation','Centroid','Extrema');
% hold on
% subImage_2 = imcrop(im, status(2).BoundingBox);
% [center_y_index,center_x_index]=find(subImage_2);
% cent=[mean(center_x_index),mean(center_y_index)];
% %cent=centerOfMass(subImage_2);
% figure, imshow(subImage_2); hold on
% mapshow(cent(1),cent(2),'DisplayType','point','Marker','o');
%%
% Y=corner(:,1); Y=reshape(Y,[1,4]);
% X=corner(:,2); X=reshape(X,[1,4]);
% binaryImage = poly2mask(X, Y,572,815);
% measurements = regionprops(binaryImage, 'BoundingBox','Centroid');
% %croppedImage = imcrop(im, measurements.BoundingBox);
% croppedImage = imcrop(newim, measurements.BoundingBox);
% % figure, imshow(croppedImage);title('cropped image')
% mapshow(measurements.Centroid(1,1),measurements.Centroid(1,2),'DisplayType','point','Marker','o');

%%
% croppedImage_CM=croppedImage;
% % croppedImage_CM(croppedImage_CM<0.5) = NaN; 
% % color = 1; 
% % croppedImage_CM(croppedImage_CM>0.5) = color;
%  C = centerOfMass(croppedImage_CM);
% figure, imshow(croppedImage_CM); title('find center of mass')
% hold on 
% mapshow(C(1,2),C(1,1),'DisplayType','point','Marker','o');
% hold off
%%
% BW_rotate=1-BW_rotate;
% [Gmag_rotate,Gdir_rotate] = imgradient(BW_rotate,'intermediate');
% [row_rotate,col_rotate]=find(Gmag_rotate>0.60*max(max(Gmag_rotate)));
% pts_rotate(1,:)=row_rotate;
% pts_rotate(2,:)=col_rotate;
% %     figure, imshow(newim);
% %     hold on
% %     scatter(col_rotate,row_rotate)
% [cim, r_rotate, c_rotate] = harris(BW_rotate, 1, .04, 'N', 20, 'display', true);
% thDist=1.7;
% thInlrRatio=0.05;
% [corner_rotate]=RANSCA_corner(BW_rotate,pts,c_rotate,r_rotate,thDist,thInlrRatio);
% Num_corner_find_rotate=length(corner_rotate);
% hold on
% mapshow(corner_rotate(:,2),corner_rotate(:,1),'DisplayType','point','Marker','o');
%%
% corner_transpose=corner.';
% corner_transpose_new(1,:)=corner_transpose(2,:);
% corner_transpose_new(2,:)=corner_transpose(1,:);
% measurements.Centroid_transpose=measurements.Centroid.';
% dis=norm(corner_transpose_new(:,1)-measurements.Centroid_transpose)
%%
% Sort the four corners 
% cor_orderd_x=corner(:,1);
% cor_orderd_y=corner(:,2);
% mean_x=mean(cor_orderd_x);
% mean_y=mean(cor_orderd_y);
% angle=atan2(cor_orderd_y-mean_y,cor_orderd_x-mean_x);
% [~,order]=sort(angle);
% cor_orderd=[cor_orderd_x(order),cor_orderd_y(order)];
%%
% se = strel('disk',4);
% closeBW = imclose(BW_im,se);
% figure, imshow(closeBW)