function var = get_all_mse(rep1, ker, num, direction)
%% Compute all Posible MSEs
[kh, kw] = size(ker{1, 1});

if(direction==0)
    [~, rw] = size(rep1);
    
    indx = 1;
    for i = 1:num
        for j = 1:kw-rw+1
            var(indx) = sum(sum((double(ker{i, 1}(1:kh, j:j+rw-1))-double(rep1)).^2));
            indx = indx + 1;
        end
    end
else
    [rw, ~] = size(rep1);
    
    indx = 1;
    for i = 1:num
        for j = 1:kw-rw+1
            var(indx) = sum(sum((double(ker{i, 1}(j:j+rw-1, 1:kh))-double(rep1)).^2));
            indx = indx + 1;
        end
    end
end

end