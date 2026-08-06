# 🚀 openChromeInMultiTabs

## 概要
`openChromeInMultiTabs` は、Windows 環境であらかじめ指定した複数のウェブページを新しい Google Chrome ウィンドウで自動的に開くためのシンプルなバッチツールです。起動時にプロジェクト関連ページや情報収集ページを一括で開きたいときに便利です。

この PR では README を読みやすくし、特に `url.txt` の文字コードや書式に関する注意点・理由・回避方法を追記しました。

---

## 使い方（簡潔）

1. リポジトリをダウンロードして展開します。
2. `url.txt` に開きたい URL を 1 行に 1 つずつ記述します（下の「URL ファイルの書式」を参照）。
3. `openChrome.bat` をダブルクリックして実行します。

成功すると、新しい Chrome ウィンドウの各タブに `url.txt` の URL が順に開かれます。

---

## url.txt の書式

- 各行に 1 つの URL を書きます。例:

```
https://github.com
https://www.google.com
https://example.com/日本語パス
```

- このリポジトリに含まれるバッチスクリプトは Windows の標準コマンド環境（cmd.exe）での取り扱いを想定しているため、日本語を含む URL を正しく扱うために、従来は `Shift_JIS`（SJIS, Windows-31J）で保存する手順を案内していました。

### 重要: 文字コードについて（なぜ SJIS を案内しているのか）

- Windows の古いバッチ処理や一部のコマンドラインツールは、デフォルトで Shift_JIS ベースのロケール（CP932）を前提に動くことがあり、UTF-8 で保存されたファイルをそのまま読み込むと日本語が文字化けして URL が壊れる場合があります。
- そのため、手元の Windows 環境で `openChrome.bat` を使うときに「SJIS で保存してください」と案内していました。

ただし、最近の Windows や PowerShell、あるいは UTF-8 を想定したバッチ実装なら UTF-8（BOM 付き／無し）のままでも動かせます。以下に代替方法と検証手順を示します。

---

## 推奨（簡単で確実） — PowerShell 版（UTF-8 に対応）

Windows 10/11 では PowerShell を使う方法が簡単で、UTF-8 の URL をそのまま扱えます。`openChrome_ps1_example.ps1` のようなスクリプトを用意して、次のように実行します。

```powershell
# example: openChrome_ps1_example.ps1
Get-Content -Path .\url.txt -Encoding UTF8 | ForEach-Object { Start-Process "chrome" -ArgumentList ($_ ) }
```

- この場合は `url.txt` を UTF-8 で保存すれば日本語入り URL も問題なく開けます。

---

## もしバッチ版（openChrome.bat）を使う場合 — 推奨手順（Notepad）

1. `url_example.txt` を開いて編集例を参考にしてください（日本語 URL を含めても OK）。
2. メモ帳で編集し、保存時に「文字コード」を `ANSI` にして保存してください（メモ帳の `ANSI` は多くの日本語 Windows では CP932 / Shift_JIS 相当です）。
   - メモ帳で「名前を付けて保存」を選び、エンコード欄を `ANSI` にしてください。

注意: エディタによって `ANSI` の意味が異なる場合があります（環境が UTF-8 に統一されている場合など）。保存後に URL の日本語部分が化けていないか必ず確認してください。

---

## URL ファイルの検証（簡単な確認コマンド）

- PowerShell で確認（UTF-8 の場合）:

```powershell
Get-Content -Path .\url.txt -Encoding UTF8 | % { Write-Host $_ }
```

- バッチで読み込んだときの出力確認（cmd）:

```bat
@echo off
chcp 65001 >nul 2>&1
for /f "usebackq delims=" %%u in ("url.txt") do (
  echo %%u
)
pause
```
この出力で日本語 URL が正しく表示されれば、読み取り側の文字コードは合っています。

---

## 代替案（より良いユーザー体験）

- PR で PowerShell 版のスクリプト（UTF-8 対応）を追加しました。PowerShell を使える環境ならこちらを推奨します。
- さらに、簡易な検証バッチ（`verify_urls.bat`）や、URL を正規化してエンコードする小さい Python スクリプトを用意すると初心者に親切です。必要なら私のほうで追加 PR を作成します。

---

## サンプル `url.txt`（推奨: UTF-8 版）

```
https://github.com/qack-dev/openChromeInMultiTabs
https://www.google.com/search?q=テスト
https://ja.wikipedia.org/wiki/日本
```

---

## ライセンス

このプロジェクトは MIT ライセンスです（LICENSE を参照）。

---

## 変更点
- README の構成を整理し、なぜ Shift_JIS を案内しているかの理由を明記しました。
- UTF-8 環境向けの PowerShell 代替案と検証例を追加しました。
- ユーザーが文字化けで迷わないよう、確認コマンドと保存手順を明示しました。
