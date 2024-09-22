function im_trg_gray2rgb = colorizedImage(im_src, im_trg, z_s, z_t)

im_src_gray = rgb2gray(im_src);
color_src = zeros(256,3); % average color associated to each luminance
cnt_src = zeros(256,1); % 

for j = 0 : 255
    [ix, iy] = find(im_src_gray==j);
    for k = 1:length(ix)
        color_src(j+1,:) = color_src(j+1,:) + double( reshape( im_src( ix(k) , iy(k) , 1:3 ), 1 , 3 ));
        cnt_src(j+1) = cnt_src(j+1)+1;
    end
end

cnt_src(cnt_src==0) = 1;
cnt_src = repmat(cnt_src,1,3); 
color_src = color_src./cnt_src; % averaging colors
color_src = round(color_src);

S_src = z_s;
S_trg = z_t;

color_trg = zeros(256,3);

for j = 0 : 255
    for trg_segment_idx = 1 : length(S_trg)
        if (trg_segment_idx==1) && (j<=S_trg(trg_segment_idx))
            delta_src = S_src(trg_segment_idx)+1; % include 0 hence we add 1
            delta_trg = S_trg(trg_segment_idx)+1; % include 0 hence we add 1
            eta_src = 0;
            eta_trg = 0;
            break
        elseif (trg_segment_idx<length(S_trg)) && (j>S_trg(trg_segment_idx)) && (j<=S_trg(trg_segment_idx+1))
            delta_src = S_src(trg_segment_idx+1) - S_src(trg_segment_idx);
            delta_trg = S_trg(trg_segment_idx+1) - S_trg(trg_segment_idx);
            eta_src = S_src(trg_segment_idx);
            eta_trg = S_trg(trg_segment_idx);
            break
        elseif (trg_segment_idx==length(S_trg)) && (j>S_trg(trg_segment_idx))
            delta_src = 255 - S_src(trg_segment_idx);
            delta_trg = 255 - S_trg(trg_segment_idx);
            eta_src = S_src(trg_segment_idx);
            eta_trg = S_trg(trg_segment_idx);
            break
        elseif (trg_segment_idx==length(S_trg))
            error('something weird happened!!')
        end
    end
    mu = (j - eta_trg)*delta_src/delta_trg + eta_src;
    tau = delta_src/delta_trg;
    w = zeros(256,1);
    for i = 0 : 255
        x = i;
        w(i+1) = exp(-((x-mu).^2)/(2*tau^2));
    end
    for i = 0 : 255
        color_trg(j+1,:) = color_trg(j+1,:) + w(i+1)*color_src(i+1,:);
    end
    color_trg(j+1,:) = color_trg(j+1,:)/sum(w);
end
color_trg = round(color_trg);

im_trg_gray2rgb = zeros([size(im_trg),3]);

for j = 0 : 255
    [ix, iy] = find(im_trg==j);
    for k = 1:length(ix)
        im_trg_gray2rgb(ix(k),iy(k),:) = reshape(color_trg(j+1,:),1,1,3);
    end
end

im_trg_gray2rgb = uint8(im_trg_gray2rgb);
