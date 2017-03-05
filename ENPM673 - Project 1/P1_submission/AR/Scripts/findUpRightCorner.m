function [outStandOutCorner,Min_index]=findUpRightCorner(outStandInnerCorner,Outcorners)
%*@File SortCornersCW.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
for i=1:length(Outcorners)
    dis(i)=norm([Outcorners(i,2),Outcorners(i,1)]-outStandInnerCorner);
    
end

[~,Min_index]=min(dis);
outStandOutCorner=Outcorners(Min_index,:);
end