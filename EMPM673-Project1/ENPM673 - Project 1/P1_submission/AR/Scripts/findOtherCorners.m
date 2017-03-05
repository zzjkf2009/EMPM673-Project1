function [Upleft,Botleft,BotRight]=findOtherCorners(UpRight_index,OutCorner)
%*@File SortCornersCW.m
%*@Author Zejiang Zeng
%*@Copyright 2017.2-2017.5 University of Maryland, Zejiang Zeng (zzeng@terpmail.umd.edu)
Upleft_index=UpRight_index+1;
Botleft_index=UpRight_index+2;
BotRight_index=UpRight_index+3;
    
if (Upleft_index<5)
    Upleft=OutCorner(Upleft_index,:);
else
    Upleft=OutCorner(rem(Upleft_index,4),:);
end

if (Botleft_index<5)
    Botleft=OutCorner(Botleft_index,:);
else
    Botleft=OutCorner(rem(Botleft_index,4),:);
end

if (BotRight_index<5)
    BotRight=OutCorner(BotRight_index,:);
else
    BotRight=OutCorner(rem(BotRight_index,4),:);
end

end
