%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of the TomoBEAR software.
% Copyright (c) 2021-2023 TomoBEAR Authors <https://github.com/KudryashevLab/TomoBEAR/blob/main/AUTHORS.md>
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as
% published by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Affero General Public License for more details.
% 
% You should have received a copy of the GNU Affero General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function results = compileTomoBEAR(build_destination, default_configuration_path)
% TODO: automate compilation
%https://www.mathworks.com/help/compiler/compiler.runtime.download.html
%https://www.mathworks.com/help/compiler/mcrinstaller.html
%[installer_path, major, minor, platform] = mcrinstaller
%https://www.mathworks.com/help/compiler/mcrversion.html
%[major,minor] = mcrversion
build = false;
if nargin == 0
    build_destination = "cryo_et_pipeline";
    default_configuration_path = "configurations/defaults.json";
    results = [];
end

configuration_parser = ConfigurationParser();
[default_configuration, ~] = configuration_parser.parse(default_configuration_path);

if build == true
    if ~verLessThan("matlab", "9.9") % R2020b
        opts = compiler.build.StandaloneApplicationOptions("pipeline/runPipeline.m");
        opts.ExecutableName = "run_TomoBEAR";
        opts.CustomHelpTextFile = "README";
        opts.ExecutableVersion = "0.0.0.1";
        opts.AutoDetectDataFiles = false;
        dynamo_files = getDynamoFiles("dynamo");
        opts.AdditionalFiles = [...
            "modules/BatchRunTomo.m",...
            ...%"./modules/BinarizeStacks.m",...
            "modules/BinStacks.m",...
            "modules/CreateStacks.m",...
            "modules/DynamoTiltSeriesAlignment.m",...
            "modules/DynamoTemplateMatching.m",...
            "modules/DynamoCleanStacks.m",...
            "modules/DynamoTemplateMatching.m",...
            "modules/EMDTemplateGeneration.m",...
            "modules/TemplateGenerationFromFile.m",...
            "modules/GainCorrection.m",...
            "modules/GCTFCtfphaseflipCTFCorrection.m",...
            "modules/MetaData.m",...
            "modules/Module.m",...
            "modules/MotionCor2.m",...
            "modules/Reconstruct.m",...
            "modules/SortFiles.m",...
            "modules/SUSAN.m",...
            "modules/TemplateMatchingPostProcessing.m",...
            "modules/TomoAlign.m",...
            "configuration/ConfigurationParser.m",...
            "environment/concatAndAddPathsRecursive.m",...
            "environment/initializeEnvironment.m",...
            "json/JSON.m",...
            "pipeline/Pipeline.m",...
            dynamo_files(:)'
            ];
        if isfield(default_configuration.general, "SUSAN_path") && default_configuration.general.SUSAN_path ~= ""
            opts.AdditionalFiles = [ opts.AdditionalFiles,...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/ParticlesInfo.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_calc_min_distance.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_defocus_per_ptcl.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_discard_min_distance.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_euZXZ_2_euZYZ.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_euZYZ_2_euZXZ.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_load_by_blocks.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_save_by_blocks.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_select_by_tilt_angle.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ParticlesInfo/private/ParticlesInfo_shift_rot.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@ReferenceInfo/ReferenceInfo.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Data/@TomosInfo/TomosInfo.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+IO/read_mrc.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Modules/@Aligner/Aligner.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Modules/@Aligner/private/Aligner_list_cone_search.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Modules/@Aligner/private/Aligner_list_inplane_search.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Modules/@Aligner/private/Aligner_list_points_cylinder.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Modules/@Aligner/private/Aligner_list_points_ellipsoid.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Modules/@Averager/Averager.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Modules/@CtfEstimator/CtfEstimator.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Project/@Manager/Manager.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/RawRW.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/TxtRW.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/exist_file.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/fsc_get.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/get_mrc_info.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/is_extension.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/mask_sphere.m",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/private/fsc_get_core.mexa64",...
                default_configuration.general.SUSAN_path + filesep "+SUSAN/+Utils/private/mask_sphere_core.mexa64"
                ];
        end
        opts.TreatInputsAsNumeric = false;
        opts.Verbose = true;
        opts.OutputDir = build_destination;
        results = compiler.build.standaloneApplication(opts);
    else
        error("ERROR: not supported in this version of MATLAB, R2020b needed, please run the application compiler app!")
    end
end
if exist(default_configuration.general.pipeline_location + filesep + default_configuration.general.project_name, "dir")
    system("chmod ug+x " + default_configuration.general.project_name + "/for_redistribution_files_only/run_" + default_configuration.general.project_name + ".sh");
    system("chmod ug+x " + default_configuration.general.project_name + "/for_redistribution_files_only/" + default_configuration.general.project_name);
    fid = fopen(default_configuration.general.project_name + filesep + "for_redistribution_files_only" + filesep + "run_" + default_configuration.general.project_name + ".sh", "r+");
    counter = 1;
    while ~feof(fid)
        text_line{counter} = string(fgets(fid));
        if contains(text_line{counter}, "LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64 ;")
            if default_configuration.general.ld_library_path == ""
                text_line{counter} = strrep(text_line{counter}, "LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64 ;",...
                    "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:.:${MCRROOT}/runtime/glnxa64 ;");
            else
                text_line{counter} = strrep(text_line{counter}, "LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64 ;",...
                    "LD_LIBRARY_PATH=" + default_configuration.general.ld_library_path + ":.:${MCRROOT}/runtime/glnxa64 ;");
            end
        end
        counter = counter + 1;
    end

    fseek(fid, 0, "bof");
    for i = 1:counter-1
        fprintf(fid, "%s", text_line{i});
    end
    fclose(fid);
end
end
