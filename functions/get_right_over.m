function [ptd, result] = get_right_over(patch, kernel2, p, c)
%% Find Right Overlapped Region

%% Get parameters
pd = p.pd; kh = p.kh; kw = p.kw; ph = p.ph;
chr = c.chr; cd = c.cd; cw = c.cw;

%% Read Remaining 2 Right Overlapped Regions
mxot = patch(pd+1:pd+chr, pd-cw+1:pd+cd); %top region
mxob = patch(ph-pd-chr+1:ph-pd, pd-cw+1:pd+cd); %bottom region

%% Find Left Top Overlapped Region
[ix, jx] = findsubmat(kernel2, mxot);
[i2, j2] = findsubmat(kernel2, mxob);
jx = jx+cw-pd;

i3 = i2+chr;
[t1, t2, t3] = intersect(ix, i3);

result = [];

if isempty(t1)
    ptd = -1;
else
    try
        rep1 = kernel2(ix(t2(1)):kh,jx(t2(1)):jx(t2(1))+pd-1);
        rep2 = kernel2(1:i2(t3(1))+chr-1, j2(t3(1)):j2(t3(1))+pd-1);
        result = [rep1;rep2];
        ptd = 1;
    catch
        ptd = -1;
    end
end

end
