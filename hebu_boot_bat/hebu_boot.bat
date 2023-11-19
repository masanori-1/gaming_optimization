@ECHO OFF

REM ----バッチファイルの名前を取得(拡張子なし)-----
SET bat_file_name=%~n0

setlocal enabledelayedexpansion

rem ------ログ格納フォルダ作成---
SET LOG_DIR_PATH=%HOMEDRIVE%%HOMEPATH%\Documents\BAT_LOG\%bat_file_name%
SET LOG_FILE_PATH=%LOG_DIR_PATH%\BAT_LOG.txt

PUSHD "%HOMEDRIVE%%HOMEPATH%\Documents\"
ECHO %CD%
IF exist "%LOG_DIR_PATH%" (
	ECHO バッチのログ格納フォルダは既に存在しています
) ELSE (
	MKDIR "%LOG_DIR_PATH%"
	ECHO バッチのログ格納フォルダを作成しました
)
PUSHD %LOG_DIR_PATH%
ECHO 上書き出力でログを出力します. > "%LOG_FILE_PATH%"

REM =====対象のフォルダを探してFORで受け取る処理====
SET TIMES=0
PUSHD %HOMEDRIVE%%HOMEPATH%
ECHO %CD%
REM ------usebackqはコマンドの出力を forの対象とできる（今回だとdirコマンド)----
REM ------/bは出力を簡潔に(時刻などは表示せずにファイル名のみ)、/sは再帰的検索、/a-dはディレクトリ対象外----
FOR /f "usebackq delims=" %%a IN (`dir /b /s /a-d *SS.url ^|^| ECHO *ERROR*`) DO (
	
	REM -----DIRで対象が一個もなかった場合はエラー------
	IF %%a==*ERROR* (
		CALL :ERROR_PATH_SERCH
	)
		
	SET /a TIMES+=1
	ECHO !TIMES!回目
	SET object_path=%%a
	echo !object_path!
	IF !TIMES!==1 GOTO :NEXT
)

:NEXT
REM =====取得したファイルを起動する=====
REM オプションタイトルは空白にしないとアプリケーションと認識されない
START /max "" "%object_path%"

endlocal
PAUSE
EXIT

:ERROR_PATH_SERCH
ECHO ERROR:起動対象のファイルが見つかりませんでした >> "%LOG_FILE_PATH%"
ECHO PC内にファイルがあるかどうかを確認してください >> "%LOG_FILE_PATH%"
EXIT /b