function F = fea_extract(ranks)

F = zeros(1, 4);

%median
F(1, 1) = median(ranks);

%mean
F(1, 2) = mean(ranks);

%variance
F(1, 3) = std(ranks);

%kurtosis
F(1, 4) = kurtosis(ranks);

end