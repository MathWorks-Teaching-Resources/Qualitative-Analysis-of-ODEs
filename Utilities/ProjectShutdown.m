function ProjectShutdown
% Reset module to original state that is expected when loading in a new
% MATLAB version.
proj = currentProject;
projRootFolder = proj.RootFolder;
if isMATLABReleaseOlderThan("R2023b")
    cd(projRootFolder)
    try
        % Check for old navigation files, if required
        files = dir(fullfile(projRootFolder,"Utilities","OldVersions","*New.mlx"));
        if ~isempty(files)
            for idx = 1:length(files)
                curName = files(idx).name;
                scriptName = extractBefore(curName,"New.mlx");
                if scriptName == "MainMenu" || scriptName == "README"
                    movefile(fullfile(projRootFolder,scriptName+".mlx"), fullfile("Utilities","OldVersions",scriptName+"Old.mlx"))
                    movefile(fullfile("Utilities","OldVersions",curName),fullfile(projRootFolder,scriptName+".mlx"))
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
        files = dir(fullfile(projRootFolder,"Utilities","OldVersions","*23b.mlx"));
        if ~isempty(files)
            for idx = 1:length(files)
                curName = files(idx).name;
                scriptName = extractBefore(curName,"23b");
                movefile(fullfile("Scripts",scriptName+".mlx"), fullfile("Utilities","OldVersions",scriptName+"23a.mlx"))
                movefile(fullfile("Utilities","OldVersions",curName),fullfile("Scripts",scriptName+".mlx"))
            end
        end
    catch ME
        disp("Failed to move OldVersions Script files: " + ME.message)
    end
end
end