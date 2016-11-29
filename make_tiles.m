

function make_tiles(input_filename_no_ext, output_folder, cur_image, im_size, patch_size)

input_filename_ext = '.tif';

% Remove tiles folder if exists
output_tiles_folder = strcat(output_folder, input_filename_no_ext, '_tiles/');
if exist(output_tiles_folder, 'dir')
    rmdir(output_tiles_folder, 's');
end;
mkdir (output_tiles_folder);
%% Preparing tiles
        t1 = floor(im_size / patch_size);
        x_tiles = t1(1);
        y_tiles = t1(2);
        for i_x = 1:x_tiles
            for i_y = 1:y_tiles
                % Cutting
                tile_coordinates = [i_x-1, i_y-1, i_x, i_y] * patch_size + [1, 1, 0, 0];
                tile_image = cur_image(tile_coordinates(1):tile_coordinates(3), tile_coordinates(2):tile_coordinates(4));
                % Saving
                % Preparing the filename
                output_filename = strcat(input_filename_no_ext, '_tile_',...
                    num2str(tile_coordinates(1)), '_', num2str(tile_coordinates(3)),...
                    '_', num2str(tile_coordinates(2)), '_', num2str(tile_coordinates(4)),...
                    input_filename_ext);
                output_filename_full = strcat(output_tiles_folder, output_filename);
                % Outputting the mask file
                imwrite(tile_image, output_filename_full, 'TIFF');
            end;
        end;
          
        
end




