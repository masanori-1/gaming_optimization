@ECHO OFF

REM ----�o�b�`�t�@�C���̖��O���擾(�g���q�Ȃ�)-----
SET bat_file_name=%~n0

setlocal enabledelayedexpansion

rem ------���O�i�[�t�H���_�쐬---
SET LOG_DIR_PATH=%HOMEDRIVE%%HOMEPATH%\Documents\BAT_LOG\%bat_file_name%
SET LOG_FILE_PATH=%LOG_DIR_PATH%\BAT_LOG.txt

PUSHD "%HOMEDRIVE%%HOMEPATH%\Documents\"
ECHO %CD%
IF exist "%LOG_DIR_PATH%" (
	ECHO �o�b�`�̃��O�i�[�t�H���_�͊��ɑ��݂��Ă��܂�
) ELSE (
	MKDIR "%LOG_DIR_PATH%"
	ECHO �o�b�`�̃��O�i�[�t�H���_���쐬���܂���
)
PUSHD %LOG_DIR_PATH%
ECHO �㏑���o�͂Ń��O���o�͂��܂�. > "%LOG_FILE_PATH%"

REM =====�Ώۂ̃t�H���_��T����FOR�Ŏ󂯎�鏈��====
SET TIMES=0
PUSHD %HOMEDRIVE%%HOMEPATH%
ECHO %CD%
REM ------usebackq�̓R�}���h�̏o�͂� for�̑ΏۂƂł���i���񂾂�dir�R�}���h)----
REM ------/b�͏o�͂��Ȍ���(�����Ȃǂ͕\�������Ƀt�@�C�����̂�)�A/s�͍ċA�I�����A/a-d�̓f�B���N�g���ΏۊO----
FOR /f "usebackq delims=" %%a IN (`dir /b /s /a-d *SS.url ^|^| ECHO *ERROR*`) DO (
	
	REM -----DIR�őΏۂ�����Ȃ������ꍇ�̓G���[------
	IF %%a==*ERROR* (
		CALL :ERROR_PATH_SERCH
	)
		
	SET /a TIMES+=1
	ECHO !TIMES!���
	SET object_path=%%a
	echo !object_path!
	IF !TIMES!==1 GOTO :NEXT
)

:NEXT
REM =====�擾�����t�@�C�����N������=====
REM �I�v�V�����^�C�g���͋󔒂ɂ��Ȃ��ƃA�v���P�[�V�����ƔF������Ȃ�
START /max "" "%object_path%"

endlocal
PAUSE
EXIT

:ERROR_PATH_SERCH
ECHO ERROR:�N���Ώۂ̃t�@�C����������܂���ł��� >> "%LOG_FILE_PATH%"
ECHO PC���Ƀt�@�C�������邩�ǂ������m�F���Ă������� >> "%LOG_FILE_PATH%"
EXIT /b