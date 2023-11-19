@ECHO OFF
setlocal enabledelayedexpansion

:: ----バッチファイルの名前を取得(拡張子なし)-----
SET bat_file_name=%~n0

:: ------ログフォルダ＆ログテキストのパス設定---
SET LOG_DIR_PATH=%HOMEDRIVE%%HOMEPATH%\Documents\BAT_LOG\%bat_file_name%
SET LOG_FILE_PATH=%LOG_DIR_PATH%\BAT_LOG.txt

REM =====別プロンプトで並行的にサブルーチンを処理する======
:: ----自身(%0)を再帰的に呼び出す.その時引数(%1)を与えることでラベルを並行処理する-----
IF "%1"=="" (
	ECHO ORIGINAL
	START "サブルーチン_GAMING_AUTO_SCRIPT_SEARCH" "%~0" callmyself
)ELSE IF "%1"=="callmyself" (
	ECHO CALLMYSELF
	CALL :GAMING_AUTO_SCRIPT_SEARCH
)

PUSHD "%HOMEDRIVE%%HOMEPATH%\Documents\"
IF exist "%LOG_DIR_PATH%" (
	ECHO バッチのログ格納フォルダは既に存在しています
) ELSE (
	MKDIR "%LOG_DIR_PATH%"
	ECHO バッチのログ格納フォルダを作成しました
)
PUSHD %LOG_DIR_PATH%
ECHO 上書き出力でログを出力します. > "%LOG_FILE_PATH%"

REM =====対象のフォルダを探してFORで受け取る処理====
SET TIMES_1=0
PUSHD %HOMEDRIVE%%HOMEPATH%
:: ------usebackqはコマンドの出力を forの対象とできる（今回だとdirコマンド)----
:: ------/bは出力を簡潔に(時刻などは表示せずにファイル名のみ)、/sは再帰的検索、/a-dはディレクトリ対象外----
FOR /f "usebackq delims=" %%a IN (`dir /b /s /a-d *ヘブンバーンズレッド.url ^|^| ECHO *ERROR*`) DO (
	
	:: -----DIRで対象が一個もなかった場合はエラー------
	IF %%a==*ERROR* (
		CALL :ERROR_APP_PATH_SERCH
	)
		
	SET /a TIMES_1+=1
	SET object_path=%%a
	IF !TIMES_1!==1 GOTO :NEXT
)

:NEXT
REM =====取得したファイルを起動する(""はタイトルがないことを示す)=====
START /max "" "%object_path%"

REM =====起動後の60秒待機(コマンド入力受け付けない)=====
timeout /t 60 /nobreak

endlocal
PAUSE
EXIT


REM ---------以降ラベル--------------

REM =======並行処理(STARTで呼ぶサブルーチン)ラベル=======
:: 並行でスクリプトを探してくる処理
:GAMING_AUTO_SCRIPT_SEARCH
PUSHD %HOMEDRIVE%%HOMEPATH%
SET TIMES_2=0
FOR /f "usebackq delims=" %%b IN (`dir /b /s /a-d *hebu_auto_script.py ^|^| ECHO *ERROR*`) DO (
	
	REM -----DIRで対象が一個もなかった場合はエラー------
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



REM =========以降、エラーラベル===========

:ERROR_APP_PATH_SEARCH
ECHO ERROR:起動対象のファイルが見つかりませんでした >> "%LOG_FILE_PATH%"
ECHO PC内にファイルがあるかどうかを確認してください >> "%LOG_FILE_PATH%"
EXIT /b

:ERROR_SCRIPT_PATH_SEARCH
ECHO ERROR:スクリプトファイルが見つかりませんでした >> "%LOG_FILE_PATH%"
ECHO スクリプトファイルの存在またはファイル名を確認してください >> "%LOG_FILE_PATH%"
EXIT /b