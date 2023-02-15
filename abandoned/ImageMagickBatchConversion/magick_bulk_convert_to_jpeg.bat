@echo off
:input
set /p quality=enter jpg quality (1-100, 85 if empty):
if [%quality%]==[] set /A quality=85
set /p input_extension=enter input extension (without ".", png if empty):
if [%input_extension%]==[] set input_extension=png
echo input extension: %input_extension%
echo jpg quality: %quality%
echo .
set /p cont=Is this correct?([y]/n)
if [%cont%]==[y] GOTO convert
if [%cont%]==[Y] GOTO convert
if [%cont%]==[] GOTO convert
GOTO input
echo .

:convert
for /r %%i in (*.%input_extension%) do (
(magick %%~ni%%~xi -strip -interlace Plane -define jpeg:dct-method=float -quality %quality% %%~ni.jpg && echo %%~ni%%~xi converted to %%~ni.jpg) || (
echo error converting %%~ni%%~xi)
)
echo Work done
pause
