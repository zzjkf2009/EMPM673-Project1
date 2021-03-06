function [theta_draw,rho_draw]=finalLines(theta,rho,inlrNum)

NoZero_index=find(theta);
theta_Start=theta(NoZero_index);
rho_Start=rho(NoZero_index);
inlrNum_Start=inlrNum(NoZero_index);
i=1;
theta_in=theta_Start;
rho_in=rho_Start;
inlrNum_in=inlrNum_Start;
while(isempty(theta_in)==0)
    
[theta_out,rho_out,inlrNum_out,theta_store,rho_store]=EliminateLines(theta_in,rho_in,inlrNum_in);
    if (isempty(theta_out)==0)
    theta_draw(i)=theta_store;
    rho_draw(i)=rho_store;
    i=i+1;
    end
    theta_in=theta_out;
    rho_in=rho_out;
    inlrNum_in=inlrNum_out;
end



end