function G = conf( hist_vals , z , g )

landa = (sum(hist_vals))/256;
sigma = (sum( (hist_vals - repmat(landa,256,1) ) .^ 2 ) / 256 ) ^ (1/2);

G=zeros(1,length(z));
for j=1:length(z)
G(j) = (g(z(j)) - landa ) / sigma;
end
end

