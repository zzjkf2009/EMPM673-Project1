function [cor_orderd]=SortCornersCW(corner)
%*@File RANSCA_corner.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
%*@brief This function all sort corners in conterclosewise 

cor_orderd_x=corner(:,1);
cor_orderd_y=corner(:,2);
mean_x=mean(cor_orderd_x);
mean_y=mean(cor_orderd_y);
angle=atan2(cor_orderd_y-mean_y,cor_orderd_x-mean_x);
[~,order]=sort(angle);
cor_orderd=[cor_orderd_x(order),cor_orderd_y(order)];
end