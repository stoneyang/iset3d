%% Example uploads of curated scenes to Archiva
%
% The pbrt-v2 scenes are in pbrt-v2-spectral/pbrtScenes
%
% Brian, SCIEN Team, January, 2018

%{
   rd = RdtClient('isetbio');
   rd.credentialsDialog;
%}
%{
  % You can also build the rd this way
  zipFile = fullfile('/home/wandell/pbrt-v2-spectral/pbrtScenes','villaLights.zip');
  exist(zipFile,'file')
  [artifacts, idx, rd] = piPBRTPush(zipFile);
%}
%{
  zipFile = fullfile('/home/wandell/pbrt-v2-spectral/pbrtScenes','yeahright.zip');
  exist(zipFile,'file')
  [artifacts, idx] = piPBRTPush(zipFile,'rdtclient',rd);
%}
%{
  zipFile = fullfile('/home/wandell/pbrt-v2-spectral/pbrtScenes','plantsDusk.zip');
  exist(zipFile,'file')
  [artifacts, idx] = piPBRTPush(zipFile,'rdtclient',rd);
%}
