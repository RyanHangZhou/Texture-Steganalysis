function [flag, flag2] = estimate_param(inImg, p)

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

%% Estimate parameters
flag = 0;
iter = 25;
tag = zeros(iter, 1);
former2 = -2;
for i = 2:iter
    [tag(i), former] = pat_simi(ker{i}, ker2, i);
    if(former2==former)
        tag(i) = 0;
    end
    former2 = former;
end
flag2 = sum(tag)/iter;
if(flag2>0.7)
    flag = 1;
end



end