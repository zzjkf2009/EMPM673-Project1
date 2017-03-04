function [corner_inner,outStandInnerCorner]=FindInnerCorners(r,c,centerOfMass,outCorners)
%*@File RANSCA_corner.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
%*@Brief This function will determine the inner corners for the ARtag when
%the center of mass and the four out corners are given by calculating the
%distance of each possible corners and centerofMass, if it is smaller than
%a certain threshold, it will be take as a inner corner. IMPORTANT, this
%method is HIGHLY depend on the quality of the harris corner detection 

%*@Param r and c are row and cols of the corners detected by harris corner
%detection, centerOfMass is center of mass of the inner tag (white
%portion. outCorners are four out corners (black background)

possible_corners(:,1)=c;
possible_corners(:,2)=r;

% calculate the distance between four corners and the center of mass 
for i=1: length(outCorners)
    dis_outter(i)=norm([outCorners(i,2),outCorners(i,1)]-centerOfMass);
end

threshold_distance=max(dis_outter)/2;
max_dis=0; max_index=0;
% calculate the distance between each point and the center of mass
x=1;
for j=1:length(c)
    dis_inner=norm(possible_corners(j,:)-centerOfMass); 
if dis_inner>threshold_distance
    continue;
end
corner_inner(x,:)=possible_corners(j,:);
x=x+1;
if dis_inner>max_dis
    max_index=j;
    max_dis=dis_inner;
end  
end
outStandInnerCorner=possible_corners(max_index,:);


end