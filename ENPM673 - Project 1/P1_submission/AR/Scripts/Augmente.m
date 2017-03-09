function [augmented_image]=Augmente(Frame,SourceImg,H)
%*@File Compute_homography.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
%*@Brief This function will place the source image to the frame
[Ref_m,Ref_n,~]=size(SourceImg);
for i=1:Ref_m
    for j=1:Ref_n
        New_T=H\[i;j;1];
        New_T=round(New_T/New_T(3,1));
        Frame(New_T(2,1),New_T(1,1),:)=SourceImg(i,j,:);
    end
end
augmented_image=Frame;

end