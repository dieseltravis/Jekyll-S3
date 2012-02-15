@ECHO OFF
SET pngbatfile=%~f1
SET pngbatpath=%~dp1
SET imagepath=%~f2
echo Running %pngbatfile% in %pngbatpath% on images in: %imagepath%
start "PNG Compression" /D %pngbatpath% cmd /C %pngbatfile%  "%imagepath%"