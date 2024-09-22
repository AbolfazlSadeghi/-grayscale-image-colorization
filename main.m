clear; close all;
clc;

tic
% get & show the target image & source image
% fprintf('Enter target image name:')
% imname_t=input('','s');
imname_t = 'm.jpg';
TI_Ch = imread(imname_t);
TI=rgb2gray(TI_Ch);
[hist_vals_t, bins_t] = imhist(TI);

% fprintf('Enter source image name:')
% imname_s=input('','s');
imname_s='m-s.jpg';
SI = imread(imname_s);
SI_g=rgb2gray(SI);
[hist_vals_s, bins_s] = imhist(SI_g);

figure
subplot(1,3,1); imshow(TI)
title('target image')
subplot(1,3,2); imshow(SI)
title('source image')
subplot(1,3,3); imshow(SI_g)
title('the grayscale of source image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute curve
Theta_t = LWregression(bins_t,hist_vals_t);
Theta_s = LWregression(bins_s,hist_vals_s);

y_t=(Theta_t(2,:).*bins_t')+Theta_t(1,:);
figure;
subplot(3,1,1); plot(bins_t,hist_vals_t,bins_t,y_t,'r'); grid on;
title('histogram & fitting curve of target image')
legend('histogram','curve')
subplot(3,1,2); plot(Theta_t(1,:)); grid on;
title('the y-intercepts of target image')
subplot(3,1,3); plot(Theta_t(2,:)); grid on
title('the slope o-sf target image')

y_s=(Theta_s(2,:).*bins_s')+Theta_s(1,:);
figure;
subplot(3,1,1); plot(bins_s,hist_vals_s,bins_s,y_s,'r'); grid on;
title('histogram & fitting curve of source image')
legend('histogram','curve')
subplot(3,1,2); plot(Theta_s(1,:)); grid on;
title('the y-intercepts of source image')
subplot(3,1,3); plot(Theta_s(2,:)); grid on
title('the slope of source image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the extrema point
dy_t = Theta_t(2,:);
dy_s = Theta_s(2,:);

[z_t,t_t] = extrema(dy_t,y_t);

[z_s,t_s] = extrema(dy_s,y_s);

fprintf('fitting curve extrema points for target image:\n')
disp(z_t);
disp(t_t);

fprintf('fitting curve extrema points for source image:\n')
disp(z_s);
disp(t_s);

delta=abs(length(z_t) - length(z_s));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diff_ext=length(z_t) - length(z_s);
if mod(diff_ext,2 )==0
    fprintf('different of extreme number is even \n\n')
end

if mod(diff_ext,2)~=0
    fprintf('different of extreme number is odd \n\n')
        % eliminate a point until different the extrema point is even
    if diff_ext > 0
        if t_s(1) == t_t(1)
            z_t(end)=[];
            t_t(end) = [];
            fprintf('eliminate the "last" point of the target image extreme \n')
            disp(z_t); disp(t_t)
        else
            z_t(1)=[];
            t_t(1) = [];
            fprintf('eliminate the "first" point of the target image extreme \n')
            disp(z_t); disp(t_t);
        end
    end
    
    if diff_ext < 0
        if t_s(1) == t_t(1)
            z_s(end)=[];
            t_s(end)=[];
            fprintf('eliminate the "last" point of the source image extreme \n')
            disp(z_s);disp(t_s)
        else
            z_s(1)=[];
            t_s(1)=[];
            fprintf('eliminate the "first" point of the source image extreme \n')
            disp(z_s);disp(t_s)
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % eliminate pair point's 
[z_s, t_s, z_t, t_t ] = pairpoints(z_s, t_s, z_t, t_t, y_s, y_t);

fprintf('extrema points for target image:\n')
disp(z_t);
disp(t_t);

fprintf('extrema points for source image:\n')
disp(z_s);
disp(t_s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

im_src = SI;
im_trg = TI;
im_trg_gray2rgb = colorizedImage(im_src, im_trg, z_s, z_t);
figure;
subplot(1,2,1); imshow(im_trg); title('Target image')
subplot(1,2,2); imshow(im_trg_gray2rgb); title('Colorized Target Image')
imwrite(im_trg_gray2rgb,'colorizedImage.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error=(sum(sum(sum((im_trg_gray2rgb - TI_Ch).^2)) ./ (prod(size(TI_Ch))))) ^ (1/2);
disp(['mean_sqr_error=',num2str(error)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1 = exp(- delta / length(z_t));
G_t = conf(hist_vals_t , z_t , y_t);
G_s = conf(hist_vals_s , z_s , y_s);
q2 = (G_s' * G_t) / (norm(G_s) * norm(G_t));
q = norm(q1 * q2);
disp(['colorization confidence=' , num2str(q)]);

toc