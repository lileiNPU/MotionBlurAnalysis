function data_ave = average_feature(data, re_num, over_lap)
data_ave = {};
sample_num = length(data);
 
for r = 1 : over_lap : sample_num
    index_begin = r;
    index_end = r + re_num - 1;
    if index_end > sample_num
        break;
    end
    img_select = [];
    for i = index_begin : index_end
        if isempty(img_select)
            img_select(:, :, end) = data{i};
        else
            img_select(:, :, end + 1) = data{i};
        end     
    end
    data_ave{end + 1} = img_select;
end


