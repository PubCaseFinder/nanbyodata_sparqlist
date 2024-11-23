# Get stats on patient number shitei

## Endpoint

https://dev-pubcasefinder.dbcls.jp/sparql/

## `result` 
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX sio: <http://semanticscience.org/resource/>

SELECT DISTINCT ?s ?year ?num_of_patients  ?nando ?label ?label_en ?number
WHERE{
graph<https://pubcasefinder.dbcls.jp/rdf/nanbyodata>{
  ?s sio:SIO_000216 ?year_data .
  ?year_data  nando:has_aYearOfStatistics/sio:SIO_000300 ?year .
  ?year_data nando:has_theNumberOfPatients/sio:SIO_000300 ?num_of_patients.}

graph<https://pubcasefinder.dbcls.jp/rdf/ontology/nando> {
   ?s dcterms:identifier ?nando.
     BIND (SUBSTR(?nando, 7, 1) AS ?nando1)
     FILTER REGEX(?nando1,"1")
   ?s rdfs:label ?label .
    FILTER (lang(?label) = "ja") .
    OPTIONAL {    ?s rdfs:label ?label_en .
                FILTER (lang(?label_en) = "en")
    }
    OPTIONAL {?s nando:hasNotificationNumber ?number.}
}
} ORDER BY ?nando ?year

```
## Output

```javascript
({result}) => {
  let tree = []; // 結果リスト
  result.results.bindings.forEach(d => {
    const nando = d.nando.value
    // 既に nando_id のデータが tree 内にあれば、年の患者数を更新
    const index = tree.findIndex(v => v.nando === nando)
    if (index > -1) {
      tree[index][`num_of_${d.year.value}`] = Number(d.num_of_patients.value)
      return
    }
    // 以下は新しい nando_id が出てきた最初の行の処理(まだ nando_id のデータが tree にない)
    // 各年の患者数を null にしたオブジェクトを作成
    let newData = {
      s: d.s.value,
      nando,
      label: d.label.value,
      label_en: d.label_en.value,
      number: Number(d.number.value),
      num_of_2015: null,
      num_of_2016: null,
      num_of_2017: null,
      num_of_2018: null,
      num_of_2019: null,
      num_of_2020: null,
      num_of_2021: null,
      num_of_2022: null
    };
    // この行に含まれる年の患者数を更新
    newData[`num_of_${d.year.value}`] = Number(d.num_of_patients.value) || null
    tree.push(newData)
  });
  return tree;
};


```
## Description
- 2024/10/21 タイトル変更
- 2024/03/21 タイトルを変更しました。旧："nanbyoData_the_number_of_patients_list"
- 2024/03/13 タイトルを修正して新規に作成、患者数のデータを2021年、2022年を追加しました。
- NanbyoDataで希少難病疾患の患者数を表示させるために利用しているSPARQListです。
- RDFのデータは高月の方で作成し、PubcaseFinderのエンドポイントにデータはあります。
- 編集：高月（2024/01/12)


