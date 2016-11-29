set (0, 'DefaultAxesFontSize', 20);


input_folder = './input/';
output_folder = './output/';

%% Constants
patch_size = 600;
mask_colors(1, :) = [0, 255, 255];  % Light blue (cyan)
mask_colors(2, :) = [0, 255, 0];  % Green
mask_colors(3, :) = [255, 0, 255];  % Magenta
mask_colors(4, :) = [0, 0, 255];  % Deep blue
masks_number = size(mask_colors, 1);

% % max_distance_for_presence = 10;



%% Getting the list of files in the input folder
image_list = dir(fullfile(input_folder, '*.tif'));
file_count = length(image_list);

%% Checking if the output folder exists
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end;


%% Parsing files in the input folder
for file_num=1:file_count
    % Loading the image
    input_filename_full = strcat(image_list(file_num).folder, '/', image_list(file_num).name);
    [~, ~, input_filename_ext] = fileparts(image_list(file_num).name);
    [~, input_filename_no_ext, ~] = fileparts(image_list(file_num).name);
    cur_image = imread(input_filename_full, 'TIFF');
    % Identifying file type
    if strfind(image_list(file_num).name, 'f1.t')
        file_type = 1;
    elseif strfind(image_list(file_num).name, 'f2.t')
        file_type = 2;
    else
        file_type = 0;
    end;
    
% %     a = 400;
% %     cur_image = cur_image(1:a, 1:a, :);
    im_size = size(cur_image);
    im_size = im_size(1:2);
    
%     figure(1);
%     image(cur_image);
    
% % %     %% Identifying exact mask colors
% % %     % Mask 1
% % %     % Computing distances to the mask 1 color
% % %     dist = cur_image;
% % %     for chan = 1:3
% % %         dist(:, :, chan) = dist(:, :, chan) - mask_1_color(chan);
% % %     end;
% % %     dist = sqrt(sum(dist.^2, 3));
% % %     min_dist = min(min(dist));
% % %     if min_dist <= max_distance_for_presence
% % %         bl_mask_found = 1;
% % %         color_location = 
% % %         cur_mask_color = find(
    
    %% If file type is 0, then it's the original file. We'll just copy it to the destination
    %% and cut it in pieces 
    if file_type == 0
        % Copy the file
        output_filename_full = strcat(output_folder, image_list(file_num).name);
        imwrite(cur_image, output_filename_full, 'TIFF');
        % Making tiles
        make_tiles(input_filename_no_ext, output_folder, cur_image, im_size, patch_size);
    else 
        %% Extracting masks
        masks = zeros([im_size, masks_number], 'logical');
        for mask_ind = 1:masks_number
            %% Extracting masks
            masks(:, :, mask_ind) = ~(abs(single(cur_image(:, :, 1)) - mask_colors(mask_ind, 1)) + ...
                abs(single(cur_image(:, :, 2)) - mask_colors(mask_ind, 2)) + ...
                abs(single(cur_image(:, :, 3)) - mask_colors(mask_ind, 3)));

            %% Outputting non-zero masks
            if sum(sum(masks(:, :, mask_ind))) > 0
                % Preparing the filename
                output_filename_no_ext = strcat(input_filename_no_ext, '_mask_', num2str(mask_ind));
                output_filename = strcat(output_filename_no_ext, input_filename_ext);
                output_filename_full = strcat(output_folder, output_filename);
                % Outputting the mask file
                imwrite(masks(:, :, mask_ind), output_filename_full, 'TIFF');
                % Making tiles
                make_tiles(output_filename_no_ext, output_folder, masks(:, :, mask_ind), im_size, patch_size);
            end;

        end;
        
% %         %% Whatever the 
        
    end;
    
    


    
    
    
    
    
    
    
end;

% j=4;
% figure(2);
% image(masks(:, :, j)*255);
% 
% figure(3);





