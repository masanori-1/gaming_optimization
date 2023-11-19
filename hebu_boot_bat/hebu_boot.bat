@ECHO OFF
setlocal enabledelayedexpansion

:: ----�o�b�`�t�@�C���̖��O���擾(�g���q�Ȃ�)-----
SET bat_file_name=%~n0

:: ------���O�t�H���_�����O�e�L�X�g�̃p�X�ݒ�---
SET LOG_DIR_PATH=%HOMEDRIVE%%HOMEPATH%\Documents\BAT_LOG\%bat_file_name%
SET LOG_FILE_PATH=%LOG_DIR_PATH%\BAT_LOG.txt

REM =====�ʃv�����v�g�ŕ��s�I�ɃT�u���[�`������������======
:: ----���g(%0)���ċA�I�ɌĂяo��.���̎�����(%1)��^���邱�ƂŃ��x������s��������-----
IF "%1"=="" (
	ECHO ORIGINAL
	START "�T�u���[�`��_GAMING_AUTO_SCRIPT_SEARCH" "%~0" callmyself
)ELSE IF "%1"=="callmyself" (
	ECHO CALLMYSELF
	CALL :GAMING_AUTO_SCRIPT_SEARCH
)

PUSHD "%HOMEDRIVE%%HOMEPATH%\Documents\"
IF exist "%LOG_DIR_PATH%" (
	ECHO �o�b�`�̃��O�i�[�t�H���_�͊��ɑ��݂��Ă��܂�
) ELSE (
	MKDIR "%LOG_DIR_PATH%"
	ECHO �o�b�`�̃��O�i�[�t�H���_���쐬���܂���
)
PUSHD %LOG_DIR_PATH%
ECHO �㏑���o�͂Ń��O���o�͂��܂�. > "%LOG_FILE_PATH%"

REM =====�Ώۂ̃t�H���_��T����FOR�Ŏ󂯎�鏈��====
SET TIMES_1=0
PUSHD %HOMEDRIVE%%HOMEPATH%
:: ------usebackq�̓R�}���h�̏o�͂� for�̑ΏۂƂł���i���񂾂�dir�R�}���h)----
:: ------/b�͏o�͂��Ȍ���(�����Ȃǂ͕\�������Ƀt�@�C�����̂�)�A/s�͍ċA�I�����A/a-d�̓f�B���N�g���ΏۊO----
FOR /f "usebackq delims=" %%a IN (`dir /b /s /a-d *�w�u���o�[���Y���b�h.url ^|^| ECHO *ERROR*`) DO (
	
	:: -----DIR�őΏۂ�����Ȃ������ꍇ�̓G���[------
	IF %%a==*ERROR* (
		CALL :ERROR_APP_PATH_SERCH
	)
		
	SET /a TIMES_1+=1
	SET object_path=%%a
	IF !TIMES_1!==1 GOTO :NEXT
)

:NEXT
REM =====�擾�����t�@�C�����N������(""�̓^�C�g�����Ȃ����Ƃ�����)=====
START /max "" "%object_path%"

REM =====�N�����60�b�ҋ@(�R�}���h���͎󂯕t���Ȃ�)=====
timeout /t 60 /nobreak

endlocal
PAUSE
EXIT


REM ---------�ȍ~���x��--------------

REM =======���s����(START�ŌĂԃT�u���[�`��)���x��=======
:: ���s�ŃX�N���v�g��T���Ă��鏈��
:GAMING_AUTO_SCRIPT_SEARCH
PUSHD %HOMEDRIVE%%HOMEPATH%
SET TIMES_2=0
FOR /f "usebackq delims=" %%b IN (`dir /b /s /a-d *hebu_auto_script.py ^|^| ECHO *ERROR*`) DO (
	
	REM -----DIR�őΏۂ�����Ȃ������ꍇ�̓G���[------
	IF %%b==*ERROR* (
		CALL :ERROR_SCRIPT_PATH_SEARCH
	)
	
	SET /a TIMES_2+=1
	SET python_path=%%b
	timeout /t 30 /nobreak
	IF !TIMES_2!==1 GOTO :PYTHON
)

:PYTHON
python -B "%python_path%"
pause
endlocal
EXIT



REM =========�ȍ~�A�G���[���x��===========

:ERROR_APP_PATH_SEARCH
ECHO ERROR:�N���Ώۂ̃t�@�C����������܂���ł��� >> "%LOG_FILE_PATH%"
ECHO PC���Ƀt�@�C�������邩�ǂ������m�F���Ă������� >> "%LOG_FILE_PATH%"
EXIT /b

:ERROR_SCRIPT_PATH_SEARCH
ECHO ERROR:�X�N���v�g�t�@�C����������܂���ł��� >> "%LOG_FILE_PATH%"
ECHO �X�N���v�g�t�@�C���̑��݂܂��̓t�@�C�������m�F���Ă������� >> "%LOG_FILE_PATH%"
EXIT /b