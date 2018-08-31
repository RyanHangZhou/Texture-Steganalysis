function [tag, former] = pat_simi(A, ker2, iter)

%% Initialization
ker2 = [ker2(1:end, 1:size(A, 2)*(iter-1)) ker2(1:end, size(A,2)*iter+1:end)];
row = fix(size(A, 1)/4);
col = fix(size(A, 2)/4);
tag = 0;
former = -1;

temp1 = A(1:row, 1:col);
[i, j] = findsubmat(ker2, temp1);
i_left = size(ker2, 1)-i+1-row;
j_left = mod(j, size(A, 2));
j_left(j_left==0) = size(A, 2);
j_left = size(A, 2)-j_left+1-col;
i(j_left<0) = [];
j(j_left<0) = [];
i_left(j_left<0) = [];
j_left(j_left<0) = [];
if(isempty(i_left))
else
    for k = 1:length(i_left)
        temp1_1 = A(1:row+i_left(k), 1:col+j_left(k));
        if(sum(sum(double(temp1_1)-double(ker2(i(k):end, j(k):j(k)+size(temp1_1, 2)-1))))==0)
            temp1_2 = A(row+i_left(k)+1:size(A,1), col+j_left(k)+1:size(A,2));
            [i2, j2] = findsubmat(ker2, temp1_2);
            j2 = mod(j2, size(A, 2));
            i2(i2~=1) = [];
            j2(j2~=1) = [];
            if(isempty(i2)==0 && isempty(j2)==0)
                tag = 1;
                former = size(temp1_2, 1);
                break;
            end
        end
    end
end

end