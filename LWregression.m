% define the linear weighted regression
% theta is a 2*255 matrix
% that first row is y-intercepts and two first is slope

function Theta = LWregression(bins,hist_vals)
N_gs = max(bins);
X = [ones(1,N_gs+1);(0:1:N_gs)];

Theta = zeros(2,N_gs+1);

for j = 1 : N_gs+1
    
    mu = X(:,j);
    dif = repmat(mu,1,N_gs+1) - X;
    tau = 10;
    w = exp(-sum(dif.^2)/(2*tau^2));

    X_p = sqrt([w;w]).*X;
    Y = hist_vals';
    Y_p = sqrt(w).*Y;

    X_bar = X_p';
    Y_bar = Y_p';

    Theta(:,j) = inv(X_bar'*X_bar)*X_bar'*Y_bar;
end


