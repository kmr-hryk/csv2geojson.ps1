#�K�{�����̃`�F�b�N
Param (
   [Parameter(mandatory)]$X,
   [Parameter(mandatory)]$Y,
   [Parameter(mandatory)]$code,
   [Parameter(mandatory)]$csv
)

#CSV�t�@�C���̃t���p�X���擾
$Filename = $(Get-ChildItem $csv).FullName

#$csv_data = Import-Csv $Filename

#$json_data = ConvertTo-Json $csv_data

#Write-Output $json_data.length

#�v�f�̖��O���擾
$fieldname = $(Get-Content $Filename | Select-Object -First 1) -split ","
$Column_count = $fieldname.length

#�f�[�^���擾
$data_body = $(Get-Content $Filename | Select-Object -Skip 1)

#EPSG�R�[�h�̎w��
$code = $code - 1
$crs_collection = @( "2443", "2444", "2445", "2446", "2447", "2448", "2449", "2450", "2451", "2452", "2453", "2454", "2455", "2456", "2457", "2458", "2459", "2460", "2461")

#GeoJSON�̏o��
Write-Output $('{')
Write-Output $('"type": "FeatureCollection",')
#EPSG�R�[�h����
Write-Output $('"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:EPSG::' + $($crs_collection[$code]) + '" } },')
Write-Output $('"features": [')

#feature����
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
   #�Ō�̍s�ȊO�͍Ō�ɃJ���}��ǉ�����
   if ( $LineNum -ne ($data_body.length -1)) {
      $feature = $feature + ","
   }
   Write-Output $feature

   $LineNum++
}

#�����܂�
Write-Output ']'
Write-Output '}'