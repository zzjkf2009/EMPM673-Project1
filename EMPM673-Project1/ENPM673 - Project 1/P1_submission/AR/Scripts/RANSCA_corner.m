function [corner]=RANSCA_corner(im,pts,c,r,thDist,thInlrRatio)
%*@File RANSCA_corner.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
%*@Brief This function will determine the corners for the ARtag if the gray
%        scale image and other param are set
%*@Param im is the gray scale image
%        pts are slected points that magnitude of the pixle gradient are larger than certain threshold
%        c and r is the col and row of the cotners respectively got from harris corner detection
%        thDist is a thresold distance to THDIST is the inlier distance threshold  
%        ROUND(THINLRRATIO*SIZE(PTS,2)) is the inlier number threshold. 


l=1;
for a=1:length(c)
    if im(r(a),c(a))>0.8  % to eliminate the corn er points that is relative bright
        continue;  % and build a new corner points matrix !! binary image for 0.8, and 150 for gray scale
    end
    r_new(l,1)=r(a);
    c_new(l,1)=c(a);
    l=l+1;
end



ptCorner(1,:)=r_new;   
ptCorner(2,:)=c_new;
Linenum=length(c_new)-1;
ptNum = size(pts,2);
thInlr = round(thInlrRatio*ptNum);
k=1;
corner_index=[];
for i=1:Linenum
    for j=i+1:length(c_new)
    
    sampleIdx = [i,j];
    ptSample=ptCorner(:,sampleIdx);
    d = ptSample(:,2)-ptSample(:,1);
	d = d/norm(d); % direction vector of the line
    
    	n = [-d(2),d(1)]; % unit normal vector of the line
	dist1 = n*(pts-repmat(ptSample(:,1),1,ptNum));  % calculate the distance
	inlier1 = find(abs(dist1) < thDist);    % find points that distance is smaller than the threshold
    if length(inlier1) < thInlr 
   continue;  % if the number of inliers is smaller than the threshold, skip the following code and move to next iteration, 
    end
    corner_index(k)=i;  % store the index number to the corner_index
    corner_index(k+1)=j;
    k=k+2;
    end
end
    corner_r=r_new(corner_index);
    corner_c=c_new(corner_index);
    corner=horzcat(corner_r,corner_c);  % combine rows and cols 
    corner=unique(corner,'rows');  % remove the duplicated points 
 
    
end
    
    
    
    