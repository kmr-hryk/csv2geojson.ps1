#csv2geojson

##これは何

平面直角座標系のX座標とY座標が含まれたCSVファイルを GeoJSON 形式で出力する PowerShell スクリプトです。

基準点のデータを GIS 系のソフトに読み込ませる時に使えるかもしれません。

##使い方

例えば、新潟市は街区基準点成果データを CSV ファイルで公開しているので、そのファイルを GeoJSON に変換するには次のように実行します。

```ps1
PS> .\csv2geojson.ps1 -X 6 -Y 7 -code 8 .\gaikukijyuntendeta.csv | Out-File .\gaikukijyuntendeta.geojson -Encoding utf8
```

###オプションについて

|オプション|意味|
|:-:|:-:|
|X|X座標のカラム番号|
|Y|Y座標のカラム番号|
|code|平面直角座標系の座標系番号|
|csv|CSV ファイルの名称|

オプションを付け忘れても足りなければシェルが聞いてくるので大丈夫(?)です。

----
Copyright (c) 2015 Hiroyuki Kimura  
[Released under the MIT LICENCE](http://opensource.org/licenses/mit-license.php)

----
2015-06-19 Hiroyuki Kimura
