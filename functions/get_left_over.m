function [ptd, result] = get_left_over(patch, kernel2, p, c)
%% Find Right Overlapped Region

%% Get parameters
pd = p.pd; kh = p.kh; kw = p.kw; ph = p.ph;
chl = c.chl; cd = c.cd; cw = c.cw;

%% Read Remaining 2 Right Overlapped Regions
mxot = patch(pd+1:pd+chl, kw+pd+1-cd:kw+pd+cw); %top region
mxob = patch(ph-pd-chl+1:ph-pd, kw+pd+1-cd:kw+pd+cw); %bottom region

%% Find Left Top Overlapped Region
[i, j] = findsubmat(kernel2, mxot);
[i2, j2] = findsubmat(kernel2, mxob);

i3 = i2+chl;
[t1, t2, t3] = intersect(i, i3);

result = [];

if isempty(t1)
    ptd = -1;
else
    try
        rep1 = kernel2(i(t2(1)):kh,j(t2(1))+cd:j(t2(1))+cd+pd-1);
        rep2 = kernel2(1:i2(t3(1))+chl-1, j2(t3(1))+cd:j2(t3(1))+cd+pd-1);
        result = [rep1;rep2];
        ptd = 1;
    catch
        ptd = -1;
    end
end

end
