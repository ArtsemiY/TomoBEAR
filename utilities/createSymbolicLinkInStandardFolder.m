function [output, destination] = createSymbolicLinkInStandardFolder(configuration, source, standard_folder, log_file_id, execute)
if nargin <= 4
    execute = true;
end
if isfield(configuration, standard_folder)
    standard_folder_path = configuration.processing_path + string(filesep)...
        + configuration.output_folder + string(filesep)...
        + configuration.(standard_folder);
    [path, name, extension] = fileparts(source);
    path_parts = strsplit(path, string(filesep));
    % TODO: check for errors
    if ~exist(standard_folder_path + string(filesep)...
            + path_parts(end), "dir") && standard_folder ~= "meta_data_folder"...
            && standard_folder ~= "gain_correction_folder" && execute == true
        [success, message, message_id] = mkdir(standard_folder_path + string(filesep)...
            + path_parts(end));
    end
    if standard_folder == "motion_corrected_files_folder"...
            || standard_folder == "aligned_tilt_stacks_folder"...
            || standard_folder == "tilt_stacks_folder"...
            || standard_folder == "dose_weighted_tilt_stacks_folder"...
            || standard_folder == "dose_weighted_sum_tilt_stacks_folder"...    
            || standard_folder == "raw_files_folder"...
            || standard_folder == "binned_tilt_stacks_folder"...
            || standard_folder == "binned_aligned_tilt_stacks_folder"...
            || standard_folder == "tomograms_folder"...
            || standard_folder == "binarized_stacks_folder"...
            || standard_folder == "fid_files_folder"...
            || standard_folder == "dynamo_folder"...
            || standard_folder == "ctf_corrected_binned_tomograms_folder"...
            || standard_folder == "ctf_corrected_tomograms_folder"...
            || standard_folder == "exact_filtered_ctf_corrected_binned_tomograms_folder"...
            || standard_folder == "binned_tomograms_folder"...
            || standard_folder == "denoised_ctf_corrected_binned_tomograms_folder"...
            || standard_folder == "denoised_tilt_stacks_folder"
        destination = standard_folder_path + string(filesep)...
            + path_parts(end) + string(filesep) + name + extension;
    elseif standard_folder == "ctf_corrected_aligned_tilt_stacks_folder"...
            || standard_folder == "dose_weighted_tilt_stacks_folder"...
            || standard_folder == "dose_weighted_sum_tilt_stacks_folder"...
            || standard_folder == "even_motion_corrected_files_folder"...
            || standard_folder == "odd_motion_corrected_files_folder"...
            || standard_folder == "dose_weighted_motion_corrected_files_folder"...
            || standard_folder == "dose_weighted_sum_motion_corrected_files_folder"...
            || standard_folder == "binned_even_tilt_stacks_folder"...
            || standard_folder == "binned_odd_tilt_stacks_folder"...
            || standard_folder == "binned_aligned_even_tilt_stacks_folder"...
            || standard_folder == "binned_aligned_odd_tilt_stacks_folder"...
            || standard_folder == "binned_dose_weighted_tilt_stacks_folder"...
            || standard_folder == "binned_dose_weighted_sum_tilt_stacks_folder"...
            || standard_folder == "binned_aligned_dose_weighted_tilt_stacks_folder"...
            || standard_folder == "binned_aligned_dose_weighted_sum_tilt_stacks_folder"...
            || standard_folder == "ctf_corrected_binned_even_tomograms_folder"...
            || standard_folder == "ctf_corrected_binned_odd_tomograms_folder"...
            || standard_folder == "ctf_corrected_binned_dose_weighted_tomograms_folder"...
            || standard_folder == "ctf_corrected_binned_dose_weighted_sum_tomograms_folder"...
            || standard_folder == "exact_filtered_tomograms_folder"...
            || standard_folder == "binned_exact_filtered_tomograms_folder"...
            || standard_folder == "ctf_corrected_binned_aligned_even_tilt_stacks_folder"...
            || standard_folder == "ctf_corrected_binned_aligned_odd_tilt_stacks_folder"...
            || standard_folder == "ctf_corrected_binned_aligned_dose_weighted_tilt_stacks_folder"...
            || standard_folder == "ctf_corrected_binned_aligned_dose_weighted_sum_tilt_stacks_fold"...
            || standard_folder == "ctf_corrected_binned_aligned_tilt_stacks_folder"...
            || standard_folder == "binned_even_tomograms_folder"...
            || standard_folder == "binned_odd_tomograms_folder"...
            || standard_folder == "even_tilt_stacks_folder"...
            || standard_folder == "odd_tilt_stacks_folder"
        name_splitted = strsplit(name, "_");
        % TODO: could take the postfix length into account
        destination = standard_folder_path + string(filesep)...
            + path_parts(end) + string(filesep) + strjoin({name_splitted{1:end-1}}, "_") + extension;
    elseif standard_folder == "meta_data_folder"...
            || standard_folder == "gain_correction_folder"
        destination = standard_folder_path + string(filesep)...
            + name + extension;
    else
        error("ERROR: standard folder is not implemented yet!")
    end
    if execute == true
        if fileExists(destination)
            delete(destination);
        end
        [~, output] = createSymbolicLink(source, destination, log_file_id);
    else
        output = "";
    end
else
    error("ERROR: standard folder is not not known, check typos!")
end
end

