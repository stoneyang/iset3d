function piMaterialWrite(thisR)
% Write the material file from PBRT V3, as input from Cinema 4D
%
% The main scene file (scene.pbrt) includes a scene_materials.pbrt
% file.  This routine writes out the materials file from the
% information in the recipe.
%
% ZL, SCIEN STANFORD, 2018

%% We should confirm that thisR is a recipe

%% Parse the output file, working directory, stuff like that.

% Converts any jpg file names in the PBRT files into png file names
ntxtLines=length(thisR.materials.txtLines);
for jj = 1:ntxtLines
    str = thisR.materials.txtLines(jj);
    if ~isempty(contains(str,'jpg'))
        thisR.materials.txtLines(jj) = strrep(str,'jpg','png');
    end
end

%% Empty any line that contains MakeNamedMaterial
% The remaining lines have a texture definition.

output = thisR.materials.outputFile_materials;
txtLines = thisR.materials.txtLines;
for i = 1:size(txtLines)
    if ~isempty(txtLines(i))
        if contains(txtLines(i),'MakeNamedMaterial')
            txtLines{i}=[];
        end
    end
end

% Squeeze out the empty lines. Some day we might get the parsed
% textures here. 
textureLines = txtLines(~cellfun('isempty',txtLines));

%% Create txtLines for the material struct array
field =fieldnames(thisR.materials.list);
materialTxt = cell(1,length(field));
 
for ii=1:length(materialTxt)
    % Converts the material struct to text
    materialTxt{ii} = piMaterialText(thisR.materials.list.(cell2mat(field(ii)))); 
end

%% Write to scene_material.pbrt texture-material file

fileID = fopen(output,'w');

for row=1:length(textureLines)
    fprintf(fileID,'%s\n',textureLines{row});
end

% Add the materials
if contains(materialTxt{length(materialTxt)},'"paint_base"')
    fprintf(fileID,'%s\n',materialTxt{length(materialTxt)});
    fprintf(fileID,'%s\n',materialTxt{length(materialTxt)-1});
    nmaterialTxt = length(materialTxt)-2;
    for row=1:nmaterialTxt
        fprintf(fileID,'%s\n',materialTxt{row});
        
    end
else
    for row=1:length(materialTxt)
        fprintf(fileID,'%s\n',materialTxt{row});
        
    end
end
fclose(fileID);

[~,n,e] = fileparts(output);
fprintf('Material file %s written successfully.\n', [n,e]);

end

%% function that converts the struct to text
function val = piMaterialText(materials)
% For each type of material, we have a method to write a line in the
% material file.
%

val_name = sprintf('MakeNamedMaterial "%s" ',materials.name);
val = val_name;
val_string = sprintf(' "string type" "%s" ',materials.string);
val = strcat(val, val_string);

if ~isempty(materials.floatindex)
    val_floatindex = sprintf(' "float index" [%0.5f] ',materials.floatindex);
    val = strcat(val, val_floatindex);
end

if ~isempty(materials.texturekd)
    val_texturekd = sprintf(' "texture Kd" "%s" ',materials.texturekd);
    val = strcat(val, val_texturekd);
end

if ~isempty(materials.texturekr)
    val_texturekr = sprintf(' "texture Kr" "%s" ',materials.texturekr);
    val = strcat(val, val_texturekr);
end

if ~isempty(materials.textureks)
    val_textureks = sprintf(' "texture Ks" "%s" ',materials.textureks);
    val = strcat(val, val_textureks);
end

if ~isempty(materials.rgbkr)
    val_rgbkr = sprintf(' "rgb Kr" [%0.5f %0.5f %0.5f] ',materials.rgbkr);
    val = strcat(val, val_rgbkr);
end

if ~isempty(materials.rgbks)
    val_rgbks = sprintf(' "rgb Ks" [%0.5f %0.5f %0.5f] ',materials.rgbks);
    val = strcat(val, val_rgbks);
end

if ~isempty(materials.rgbkd)
    val_rgbkd = sprintf(' "rgb Kd" [%0.5f %0.5f %0.5f] ',materials.rgbkd);
    val = strcat(val, val_rgbkd);
end

if ~isempty(materials.colorkd)
    val_colorkd = sprintf(' "color Kd" [%0.5f %0.5f %0.5f] ',materials.colorkd);
    val = strcat(val, val_colorkd);
end

if ~isempty(materials.colorks)
    val_colorks = sprintf(' "color Ks" [%0.5f %0.5f %0.5f] ',materials.colorks);
    val = strcat(val, val_colorks);
end

if ~isempty(materials.floaturoughness)
    val_floaturoughness = sprintf(' "float uroughness" [%0.5f] ',materials.floaturoughness);
    val = strcat(val, val_floaturoughness);
end

if ~isempty(materials.floatvroughness)
    val_floatvroughness = sprintf(' "float vroughness" [%0.5f] ',materials.floatvroughness);
    val = strcat(val, val_floatvroughness);
end

if ~isempty(materials.floatroughness)
    val_floatroughness = sprintf(' "float roughness" [%0.5f] ',materials.floatroughness);
    val = strcat(val, val_floatroughness);
end

if ~isempty(materials.spectrumkd)
    val_spectrumkd = sprintf(' "spectrum Kd" "%s" ',materials.spectrumkd);
    val = strcat(val, val_spectrumkd);
end

if ~isempty(materials.spectrumks)
    val_spectrumks = sprintf(' "spectrum Ks" "%s" ',materials.spectrumks);
    val = strcat(val, val_spectrumks);
end

if ~isempty(materials.stringnamedmaterial1)
    val_stringnamedmaterial1 = sprintf(' "string namedmaterial1" "%s" ',materials.stringnamedmaterial1);
    val = strcat(val, val_stringnamedmaterial1);
end

if ~isempty(materials.stringnamedmaterial2)
    val_stringnamedmaterial2 = sprintf(' "string namedmaterial2" "%s" ',materials.stringnamedmaterial2);
    val = strcat(val, val_stringnamedmaterial2);
end

end
