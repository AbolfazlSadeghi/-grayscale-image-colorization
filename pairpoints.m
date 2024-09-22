% this function find & eliminate the candidate pairpoints
function [z_s, t_s, z_t, t_t] = pairpoints(z_s, t_s, z_t, t_t, y_s, y_t)

L_s = length(z_s);
L_t = length(z_t);

% Correspond the extrema point number
if L_s==L_t
    return
end

% different the extrema point number is odd
if mod(abs(L_s-L_t),2)~=0
    error('mod(abs(L_s-L_t),2)~=0')
    return
end

% determine the candidate pair point for elimination
swap_flag = false;
if L_t<L_s % swap source and target
    ext_tmp = z_t;
    z_t = z_s;
    z_s = ext_tmp;
    z_tmp = t_t;
    t_t = t_s;
    t_s = z_tmp;
    y_tmp = y_t;
    y_t = y_s;
    y_s = y_tmp;
    swap_flag = true;
end

if L_t<4
    if abs(z_t(1)-z_s(1)) > abs(z_t(end)-z_s(end))
        z_t(1:2) = [];
        t_t(1:2) = [];
    else
        z_t(end-1:end) = [];
        t_t(end-1:end) = [];
    end
    
elseif L_t>=4
    while length(z_s)~=length(z_t)
        candidates = [];
        candidates_diff = [];
        for i = 1 : length(z_t)-4+1
            if t_t(i)==-1 % minimum
                if ( y_t(z_t(i)) < y_t(z_t(i+2)) ) & ( y_t(z_t(i+1)) < y_t(z_t(i+3)) )
                    candidates(end+1) = i+1; % i+1 and i+2 are candidates pair to be removed
                    candidates_diff(end+1) = abs( y_t(z_t(i+1)) - y_t(z_t(i+2)) ); % if more than one pair, we use minimum diff to choose
                end
            elseif t_t(i)==+1 % maximum
                if ( y_t(z_t(i)) > y_t(z_t(i+2)) ) & ( y_t(z_t(i+1)) > y_t(z_t(i+3)) )
                    candidates(end+1) = i+1; % i+1 and i+2 are candidates pair to be removed
                    candidates_diff(end+1) = abs( y_t(z_t(i+1)) - y_t(z_t(i+2)) ); % if more than one pair, we use minimum diff to choose
                end
            end
        end
        if ~isempty(candidates)
            [junk, idx] = min(candidates_diff);
            del_idx = candidates(idx);
            z_t(del_idx:del_idx+1) = [];
            t_t(del_idx:del_idx+1) = [];
        else
            candidates_diff = abs(diff(y_t(z_t)));
            [junk, idx] = min(candidates_diff);
            del_idx = idx;
            z_t(del_idx:del_idx+1) = [];
            t_t(del_idx:del_idx+1) = [];
        end
    end
end

if swap_flag
    ext_tmp = z_t;
    z_t = z_s;
    z_s = ext_tmp;
    z_tmp = t_t;
    t_t = t_s;
    t_s = z_tmp;
    y_tmp = y_t;
    y_t = y_s;
    y_s = y_tmp;
end