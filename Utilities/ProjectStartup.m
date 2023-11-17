function ProjectStartup
% Set up check for version number
proj = currentProject;
if isMATLABReleaseOlderThan("R2023b")
    cd(proj.RootFolder)
    try
        % Check for old navigation files, if required
        files = dir(fullfile(proj.RootFolder,"Utilities","OldVersions","*Old.mlx"));
        if ~isempty(files)
            for idx = 1:length(files)
                curName = files(idx).name;
                scriptName = extractBefore(curName,"Old.mlx");
                if scriptName == "MainMenu" || scriptName == "README"
                    movefile(fullfile(proj.RootFolder,scriptName+".mlx"), fullfile("Utilities","OldVersions",scriptName+"New.mlx"))
                    movefile(fullfile("Utilities","OldVersions",curName),fullfile(proj.RootFolder,scriptName+".mlx"))
                else
                    error("Unexpected file name: " + curName)
                    warning("File not moved, please rename.")
                end
            end
        end
    catch ME
        disp("Failed to move OldVersions navigation files because: " + ME.message)
    end
    try
        % Check for files that switch from 23a to 23b
        files = dir(fullfile(proj.RootFolder,"Utilities","OldVersions","*23a.mlx"));
        if ~isempty(files)
            for idx = 1:length(files)
                curName = files(idx).name;
                scriptName = extractBefore(curName,"23a");
                movefile(fullfile("Scripts",scriptName+".mlx"), fullfile("Utilities","OldVersions",scriptName+"23b.mlx"))
                movefile(fullfile("Utilities","OldVersions",curName),fullfile("Scripts",scriptName+".mlx"))
            end
        end
    catch ME
        disp("Failed to move OldVersions Script files because: " + ME.message)
    end
end
ProjectStartupApp
end