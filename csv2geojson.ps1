#必須引数のチェック
Param (
   [Parameter(mandatory)]$X,
   [Parameter(mandatory)]$Y,
   [Parameter(mandatory)]$code,
   [Parameter(mandatory)]$csv
)

#CSVファイルのフルパスを取得
$Filename = $(Get-ChildItem $csv).FullName

#$csv_data = Import-Csv $Filename

#$json_data = ConvertTo-Json $csv_data

#Write-Output $json_data.length

#要素の名前を取得
$fieldname = $(Get-Content $Filename | Select-Object -First 1) -split ","
$Column_count = $fieldname.length

#データを取得
$data_body = $(Get-Content $Filename | Select-Object -Skip 1)

#EPSGコードの指定
$code = $code - 1
$crs_collection = @( "2443", "2444", "2445", "2446", "2447", "2448", "2449", "2450", "2451", "2452", "2453", "2454", "2455", "2456", "2457", "2458", "2459", "2460", "2461")

#GeoJSONの出力
Write-Output $('{')
Write-Output $('"type": "FeatureCollection",')
#EPSGコード部分
Write-Output $('"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:EPSG::' + $($crs_collection[$code]) + '" } },')
Write-Output $('"features": [')

#feature部分
$LineNum = 0
$data_body | ForEach-Object {
   $element = ""
   $body = $_ -split ","
   for ($i=0;$i -le $Column_count; $i++) {
      $name = $fieldname[$i]
      $value = $body[$i]
      if ( $name -ne $null) {
         $element = $element + ' "' + $name + '": "' + $value + '",'
      }
   }
   $coodinates = '[ ' + $body[$Y -1] + ', ' + $body[$X -1] + ' ]'
   $element = $element.Trim(",") + " "
   $feature = $('{ "type": "Feature", "properties": {' + $element + '}, "geometry": { "type": "Point", "coordinates": ' + $coodinates + ' } }')
   #最後の行以外は最後にカンマを追加する
   if ( $LineNum -ne ($data_body.length -1)) {
      $feature = $feature + ","
   }
   Write-Output $feature

   $LineNum++
}

#おしまい
Write-Output ']'
Write-Output '}'