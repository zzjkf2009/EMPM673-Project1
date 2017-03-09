%*@File runMe.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
%*@Brief This is the main code for detection the four corners of a ARtag
%        one frame of a video will be given, in this frame: one person is holding a
%        paper with ARtag on it, the code here will detect the corners of the tag
%*@Reference: Thanks for the toolbox from Peter Kovesi 

%%
clear
close all
tic
im=imread('../Data/Tag6.jpg'); 
im_gray=rgb2gray(im);  
BW_im=im2bw(im_gray,0.8);
%figure, imshow(BW_im);

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
mapshow(OutCorner(:,2),OutCorner(:,1),'DisplayType','point','Marker','o');
hold off
status = regionprops(BW_im,'BoundingBox','Orientation','Centroid');
[corner_inner,outStandInnerCorner]=FindInnerCorners(r,c,status(2).Centroid,OutCorner);
[UpRightCorner,UpRight_index]=findUpRightCorner(outStandInnerCorner,OutCorner);
[Upleft,Botleft,BotRight]=findOtherCorners(UpRight_index,OutCorner);


im_reference=imread('../Data/ref_marker.png');
im_lena=imread('../Data/Lena.png');
% Corners in frame
Homo_Points_affine=[UpRightCorner(2) Upleft(2) Botleft(2) BotRight(2);
                    UpRightCorner(1) Upleft(1) Botleft(1) BotRight(1)  ];
                         

% corners in reference tag
Homo_Points_plain= [ 200   200    1    1       
                     200    1     1    200 ];
                 
                 
Homo_Lena_Plain=[1   1  512  512;
                 512  1   1   512];                 
                                   
 

H=Compute_homography(Homo_Points_affine,Homo_Points_plain);
H_norm=H/H(3,3);  % Normalize the H
[HomoImage,~,~]=imagehomog(im,H_norm,'m',4);
figure, imshow(HomoImage);
[TagID,EncodedMatrix]=Encoding(HomoImage);

H_Lena=Compute_homography(Homo_Points_affine,Homo_Lena_Plain);




text=['TagID is ' num2str(TagID)];
FinalFrame=insertText(im,status(2).Centroid,text,'FontSize',20,'BoxColor','white','TextColor','black');
figure, imshow(FinalFrame); title('Findal Frame deispced'); hold on
plot(UpRightCorner(2),UpRightCorner(1),'Marker','o','Color','g')
plot(Upleft(2),Upleft(1),'Marker','o','Color','r')
plot(BotRight(2),BotRight(1),'Marker','o','Color','b')
plot(Botleft(2),Botleft(1),'Marker','o','Color','y')
hold off

[augmented_image]=Augmente(im,im_lena,H_Lena);

figure, imshow(augmented_image); title('OMG, I Place the Lena Image on Frame')
toc
RunningTime = toc
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
% Sort the four corners 
% cor_orderd_x=corner(:,1);
% cor_orderd_y=corner(:,2);
% mean_x=mean(cor_orderd_x);
% mean_y=mean(cor_orderd_y);
% angle=atan2(cor_orderd_y-mean_y,cor_orderd_x-mean_x);
% [~,order]=sort(angle);
% cor_orderd=[cor_orderd_x(order),cor_orderd_y(order)];
%%
% close all
% clear
% I1 = rgb2gray(imread('../Data/ref_marker.png'));
% fun = @(block_struct)...
%      mean2(block_struct.data);
%      
% B=blockproc(I1,[25 25],fun);
% B(find(B==255))=1;
%%
% Homo_Points_affine=[UpRightCorner(2) Upleft(2) Botleft(2) BotRight(2);
%                     UpRightCorner(1) Upleft(1) Botleft(1) BotRight(1)  
%                        1                 1         1             1    ];
% Homo_Points_plain= [ 200   200    1    1       
%                      200    1     1    200 
%                       1      1     1    1   ];       
%  H_f= homography2d(Homo_Points_affine,Homo_Points_plain);
%  H_a=Compute_homography(Homo_Points_affine,Homo_Points_plain);
%%
Homo_Points_Cube=[100 1 1 100;
                  1 1 100 100];
camera_Matrix =[1406.08415449821,0,0; 2.20679787308599, 1417.99930662800,0;1014.13643417416, 566.347754321696,1]';
H_inv=Compute_homography(Homo_Points_Cube,Homo_Points_affine);
p=cross(H_inv(:,1),H_inv(:,2));
Projection_Matrix=camera_Matrix*[H_inv(:,1) H_inv(:,2) p H_inv(:,3)];
im_cube=im;
for i=1:100
    for j=1:100
        for k=1:100
       % New_T=H\[i;j;1];
        New_T=Projection_Matrix*[i;j;-k;1];
        New_T=round(New_T/New_T(3,1));
        im_cube(New_T(1,1),New_T(2 ,1),:)=0;
        end
    end
end
figure, imshow(im_cube); title('OMG, I Place the Virtual Cube on Frame')
   