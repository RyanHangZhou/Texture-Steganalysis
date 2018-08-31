% =========================================================================
% An example code of parameter estimation for the algorithm proposed in
%
% Hang Zhou, Kejiang Chen, Weiming Zhang, Zhenxing Qian, and Nenghai Yu.
% "Targeted Attack and Security Enhancement on Texture Synthesis Based 
% Steganography", JVCIR 2018.
%
%
% Written by Hang Zhou @ EEIS USTC
% May, 2017.
% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zhou Hang 2017/5/13
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;
addpath(genpath(pwd));

%% Input parameters
tw = 488; th = 488;

%% Acquire candidate parameters
count = 0;
n = 2;
for pd = 4:tw/4
    for pw = 2*pd+n:tw/4
        r = (tw-pd)/(pw-pd);
        if(round(r)==r && (pw-2*pd)*r<tw && pd<=pw-2*pd)
            for ph = 2*pd+n:th/4
                r2 = (th-pd)/(ph-pd);
                if(round(r2)==r2 && (ph-2*pd)*r2<th && pd<=ph-2*pd)
                    fid = fopen('results\candidate.txt','a');
                    fprintf(fid, 'pw:%d, ph:%d, pd:%d, tpw:%d, tph:%d\r\n', pw, ph, pd, r, r2);
                    fclose(fid);
                    temp.pd(count+1) = pd; temp.kh(count+1) = ph-2*pd; temp.kw(count+1) = pw-2*pd;
                    count = count + 1;
                end
            end
        end
    end
end
p.pn = count;

%% Estimate parameters
imgnum = 20; bpp = 12;
pr.pd = 8; pr.kh = 32; pr.kw = 32; pr.ph = 2*pr.pd+pr.kh; pr.pw = 2*pr.pd+pr.kw;

for i = 1:imgnum
    i
    tag = 0; tag2 = 0; tag3 = 0;
    for k = 1:p.pn
        % inImg = fullfile('testimg\noemb\', ['bpp', num2str(bpp)], '\',[num2str(i), '.bmp']);
        inImg = fullfile('testimg\emb\', ['bpp', num2str(bpp)], '\', [num2str(i), '.bmp']);
        p.pd = temp.pd(k); p.kh = temp.kh(k); p.kw = temp.kw(k); p.ph = 2*p.pd+p.kh; p.pw = 2*p.pd+p.kw;
        [flag, flag2(k)] = estimate_param(inImg, p);
        if(flag==1 && pr.pd==p.pd && pr.pw==p.pw && pr.ph==p.ph)
            tag = 1;
        end
        if(flag==1 && (pr.pd~=p.pd || pr.pw~=p.pw || pr.ph~=p.ph))
            tag2 = 1;
        end
        if(flag==1)
            tag3 = 1;
        end
    end
    flag3 = find(flag2==max(flag2));
    if(tag2==1)
        fid = fopen('results\P_FA.txt', 'a');
        fprintf(fid, '1\r\n');
        fclose(fid);
    end
    if(tag==1 && tag2 ==0)
        fid2 = fopen('results\P_ACC.txt', 'a');
        fprintf(fid2, '1\r\n');
        fclose(fid2);
    end
    if(tag3==0)
        fid3 = fopen('results\P_MA.txt', 'a');
        fprintf(fid3, '1\r\n');
        fclose(fid3);
    end
end
