function [TagID,EncodedMatrix]=Encoding(Tansfered_im)
%*@File RANSCA_corner.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)

I = rgb2gray(Tansfered_im);
BW=im2bw(I,0.8);
Measurements = regionprops(BW,'BoundingBox');

[NumofBox,~]=size(Measurements);

if NumofBox==1
%find the inner 4 by 4 coding grids
    InnerGrid = imcrop(I, Measurements.BoundingBox);
else 
    InnerGrid = imcrop(I, Measurements(2).BoundingBox);
end

fun = @(block_struct)...
     mean2(block_struct.data);

[m,n]=size(InnerGrid);
BlockSize=round((m+n)/8);
 
B=blockproc(InnerGrid,[BlockSize BlockSize],fun);

B((B<220))=0; 
B((B>=220))=1;
EncodedMatrix=B;
Binary_IDArray=[EncodedMatrix(3,2) EncodedMatrix(3,3) EncodedMatrix(2,3) EncodedMatrix(2,2)];
TagID=bi2de(Binary_IDArray);
end