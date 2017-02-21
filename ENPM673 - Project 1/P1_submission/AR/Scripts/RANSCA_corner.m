function [corner]=RANSCA_corner(pts,c,r,thDist,thInlrRatio)

ptCorner(1,:)=r;
ptCorner(2,:)=c;
sampleNum = 2;
Linenum=length(c)-1;
ptNum = size(pts,2);
thInlr = round(thInlrRatio*ptNum);
k=1;
for i=1:Linenum
    for j=i+1:length(c)
    
    sampleIdx = [i,j];
    ptSample=ptCorner(:,sampleIdx);
    d = ptSample(:,2)-ptSample(:,1);
	d = d/norm(d); % direction vector of the line
    
    	n = [-d(2),d(1)]; % unit normal vector of the line
	dist1 = n*(pts-repmat(ptSample(:,1),1,ptNum));
	inlier1 = find(abs(dist1) < thDist);
    if length(inlier1) < thInlr, continue; end
    corner_index(k)=i;
    corner_index(k+1)=j;
    k=k+2;
    end
end
    corner_r=r(corner_index);
    corner_c=c(corner_index);
    corner=horzcat(corner_r,corner_c);
end
    
    
    
    