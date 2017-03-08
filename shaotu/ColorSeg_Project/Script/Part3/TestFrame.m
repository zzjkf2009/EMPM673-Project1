clear;
clc;
close all;
%Test frame
%!!!Change to your own Directory
%frame=imread('D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Images\TestSet\Frames\frame17.jpg');
%frame=imread('D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Images\TestSet\Frames\frame29.jpg');
%frame=imread('D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Images\TestSet\Frames\frame136.jpg');
frame=imread('D:\Cygwin\home\shaot\ENPM673 - Project 1\P1_submission\ColorSeg\Images\TestSet\Frames\frame200.jpg');
%Test estimate function
%reshape frame to N by 3 matrix
RGBframe=reshape(frame,[480*640 3]);
[mu sigma]=estimate(RGBframe);
%Test detectBuoy function
detectBuoy(frame);
