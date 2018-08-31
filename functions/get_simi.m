function per = get_simi(inImg, p, c, ratio)

%% Get parameters
pd = p.pd; kh = p.kh; kw = p.kw; ph = p.ph; pw = p.pw;

%% Read an image
inImg = imread(inImg);
[imh, imw] = size(inImg);

%% Read all patches & kernels
num = 1;
pat = cell((imh-pd)/(pd+kh), 1); pat(:) = {0};
ker = cell((imh-pd)/(pd+kh), 1); ker(:) = {0};
ker2 = uint8(zeros(kh, (imh-pd)/(pd+kh)*(imw-pd)/(pd+kw)*kw));
for i = 1:(imh-pd)/(pd+kh)
    for j = 1:(imw-pd)/(pd+kw)
        pat{num, 1} = inImg(1+(kh+pd)*(i-1):(kh+2*pd)+(kh+pd)*(i-1), 1+(kw+pd)*(j-1):(kw+2*pd)+(kw+pd)*(j-1));
        ker{num, 1} = pat{num, 1}(pd+1: ph-pd, pd+1:pw-pd);
        ker2(:, (num-1)*kw+1:num*kw) = uint8(ker{num, 1});
        num = num + 1;
    end
end

num = num - 1;
num = num/ratio;

%% Find left overlapped regions
per = [];
cnt = 1;

for i = 1:fix(num)
    %Eliminate side patches
    if(mod(i, (imh-pd)/(pd+kh))~=0)
        %Find left overlapped regions
        [pn, rep1] = get_left_over(pat{i, 1}, ker2, p, c);
        if(pn>0)
            %Find right overlapped region
            [ptd, rep2] = get_right_over(pat{i+1, 1}, ker2, p, c);
            if(ptd>0)
                %Recover source MSE
                var0 = sum(sum((double(rep1)-double(rep2)).^2));
                %Compute all posible MSEs
                vara = get_all_mse(rep1, ker, num, 0);
                %Count smaller MSEs
                per(cnt) = floor(sum(vara<var0));
                cnt = cnt + 1;
            end
        end
    end
end

end