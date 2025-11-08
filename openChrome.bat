rem chromeを複数タブで開く。

@echo off

rem 遅延環境変数の使用を宣言
setlocal enabledelayedexpansion

rem カレントフォルダへ移動
cd %~dp0

rem 変数（chromeを新しいタブで開く。）
set OPENCHROME="chrome.exe" "--new-window"

rem 「url.txt」を一行ずつ読み込む。
for /f %%i in (./url.txt) do (
	rem 文字列を結合
	set OPENCHROME=!OPENCHROME! %%i
)

rem chromeを開く
start "" %OPENCHROME%

rem コマンドプロンプトを終了
exit /B 0