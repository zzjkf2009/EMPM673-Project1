%-----------------------------------------------------------------%
%This function takes number of gaussians N, data and plot_path
%Output: the array N*D mean and N*D*D covariance model parameters

function[mean, covariance]=EM(N,data,plot_path)

%{
%the number of gaussain
N=N;
% data
data=data;
%plot_path
plot_path=plot_path;
%}

GMM=fitgmdist(double(data),N,'RegularizationValue',0.5);
mean=GMM.mu;
covariance=GMM.Sigma;


%Create steps
x=-3:0.01:12;
%x=0:255;
GMMn=0;
%rng(2);
for i=1:N
    GMMn=GMMn+normpdf(x,GMM.mu(i),GMM.Sigma(i));
end
figure(1),plot(x,GMMn);
Title=strcat('GMM model with',' ',num2str(N),' components');

title(Title);

%legend ('Original GMM','GMM Data Samples','Fitted GMM');
filename=strcat('EM1D',num2str(N),'D','.jpg');
fullname=fullfile(plot_path,filename);
saveas(figure(1),fullname);







