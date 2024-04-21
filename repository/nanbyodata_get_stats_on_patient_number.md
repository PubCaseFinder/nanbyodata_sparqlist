## Endpoint

https://pubcasefinder-rdf.dbcls.jp/sparql

## `result` 
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX sio: <http://semanticscience.org/resource/>

SELECT ?s ?nando ?label ?label_en ?number ?year ?num_of_patients
FROM <https://pubcasefinder.dbcls.jp/rdf/ontology/nando>
{
 ?s dcterms:identifier ?nando;
    rdfs:label ?label .
    FILTER (lang(?label) = "ja") .
  OPTIONAL {
    ?s rdfs:label ?label_en .
    FILTER (lang(?label_en) = "en")
  }
  OPTIONAL {?s nando:hasNotificationNumber ?number.}
  ?s sio:SIO_000216 ?year_data .
  ?year_data  nando:has_aYearOfStatistics/sio:SIO_000300 ?year .
  ?year_data nando:has_theNumberOfPatients/sio:SIO_000300 ?num_of_patients .
} ORDER BY ?nando ?year
```
## Output

```javascript
({result}) => {
  let tree = [];
  // TODO nando ごとにグループ化して、年ごと(動的に取得)の統計値を出力する
  // 最終出力を揃える: https://nanbyodata.jp/sparqlist/nanbyodata_get_stats_on_patient_number
  return tree;
};

```
## Description
- 2024/03/21 タイトルを変更しました。旧："nanbyoData_the_number_of_patients_list"
- 2024/03/13 タイトルを修正して新規に作成、患者数のデータを2021年、2022年を追加しました。
- NanbyoDataで希少難病疾患の患者数を表示させるために利用しているSPARQListです。
- RDFのデータは高月の方で作成し、PubcaseFinderのエンドポイントにデータはあります。
- 編集：高月（2024/01/12)
