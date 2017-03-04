function new_data = superimposeLines(data,x0,y0,color)
% This function draws lines over an input image
% data is a (n x m x 3) matrix
% x0 and y0 are (L x 2) matrices representing x and y positions of
% L couple of points defining L lines
% color is a vector of size (1 x 3)

L = size(x0,1);

% for all lines
for l=1:L
    x1 = x0(l,1);
    x2 = x0(l,2);
    y1 = y0(l,1);
    y2 = y0(l,2);
    % if line isn't vertical
    if (x1 ~= x2)
        y_old = y1;
        
        if x1 <= x2
            u = x1:x2;
        else
            u = x1:-1:x2;
        end
        
        for j=u
            y = (y2-y1)/(x2-x1)*(j-x1) + y1;
            y = round(y);
            
            if y_old <= y
                v = y_old:y;
            else
                v = y_old:-1:y;
            end
            
            for i=v
                new_data(i,j,:) = color;
            end
            y_old = y;
        end
    else % else line is vertical
        for i=y1:y2
            new_data(i,x1,:) = color;
        end
    end
end
