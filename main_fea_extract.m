% =========================================================================
% An example code of synthetic image steganalysis for the algorithm 
% proposed in
%
% Hang Zhou, Kejiang Chen, Weiming Zhang, Zhenxing Qian, and Nenghai Yu.
% "Targeted Attack and Security Enhancement on Texture Synthesis Based 
% Steganography", JVCIR 2018.
%
%
% Written by Hang Zhou @ EEIS USTC
% March, 2016.
% =========================================================================

clear; clc; close all;
addpath(genpath(pwd));

%% Parameters
c.chl = 2; c.chr = 2; c.cw = 3; c.cd = 3;
ratio = 2; imgnum = 20;
pr.pd = 8; pr.kh = 32; pr.kw = 32; pr.ph = 2*pr.pd+pr.kh; pr.pw = 2*pr.pd+pr.kw;
bpp = 1;
F_cover = double(zeros(imgnum, 4));
F_stego = F_cover;

%% Extract features
tic
for i = 1:imgnum
    cover_img = fullfile('data\', ['bpp', num2str(0)],[num2str(i), '.pgm']);
    stego_img = fullfile('data\', ['bpp', num2str(bpp)], [num2str(i), '.pgm']);
    F_cover(i, :) = fea_extract(get_simi(cover_img, pr, c, ratio));
    F_stego(i, :) = fea_extract(get_simi(stego_img, pr, c, ratio));
    parfor_progress;
end
toc

%% SVM classification
for j = 1:10
indice1 = crossvalind('Kfold', imgnum, 5);
indice2 = crossvalind('Kfold', imgnum, 5);

pe = [];
for i = 1:5
    valtrain = [F_cover(indice1~=i, :); F_stego(indice2~=i, :)];
    max_valtrain = max(valtrain, [], 1);
    valtrain = valtrain./repmat(max_valtrain, size(valtrain, 1), 1);
    vallabeltrain = [zeros(sum(indice1~=i), 1); ones(sum(indice2~=i), 1)];
    valtest = [F_cover(indice1==i, :); F_stego(indice2==i, :)];
    max_valtest = max(valtest, [], 1);
    valtest = valtest./repmat(max_valtest, size(valtest, 1), 1);
    vallabeltest = [zeros(sum(indice1==i), 1); ones(sum(indice2==i), 1)];
    SVMModel = fitcsvm(valtrain, vallabeltrain);
    label = predict(SVMModel, valtest);
    pe(i) = sum(abs(label-vallabeltest))/size(vallabeltest, 1);
end

pe_mean(j) = mean(pe);

end
pe_mean2 = mean(pe_mean);

fid = fopen('results\ACC.txt', 'a');
fprintf(fid, 'bpp: %d, error:  %.3f\r\n', bpp, pe_mean2);
fclose(fid);
