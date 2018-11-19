function [code codedMap] = LCBPextraction(img, shape)
fixed_param(:, :, 1) = [1, 0, 0; 0, -1, 0; 0, 0, 0];
fixed_param(:, :, 2) = [0, 1, 0; 0, -1, 0; 0, 0, 0];
fixed_param(:, :, 3) = [0, 0, 1; 0, -1, 0; 0, 0, 0];
fixed_param(:, :, 4) = [0, 0, 0; 0, -1, 1; 0, 0, 0];
fixed_param(:, :, 5) = [0, 0, 0; 0, -1, 0; 0, 0, 1];
fixed_param(:, :, 6) = [0, 0, 0; 0, -1, 0; 0, 1, 0];
fixed_param(:, :, 7) = [0, 0, 0; 0, -1, 0; 1, 0, 0];
fixed_param(:, :, 8) = [0, 0, 0; 1, -1, 0; 0, 0, 0];
img = double(img);
code_map = [];
for f = 1 : size(fixed_param, 3)
    filter = fixed_param(:, :, f);
    map = conv2(img, filter, shape);
    same_index = (map == 0);
    code_map_temp = 2.^(f-1) * same_index;
    if isempty(code_map)
        code_map = code_map_temp;
    else
        code_map = code_map + code_map_temp;
    end
end
codedMap = uint8(code_map);
code = imhist(uint8(code_map)) / numel(code_map);
code = code';
