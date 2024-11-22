# Get stats on patient number shoman
- 小児慢性の受給者数の一覧を表示する

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
     FILTER REGEX(?nando1,"2")
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
    const nando = d.nando ? d.nando.value : null;
    const year = d.year ? d.year.value : null;
    const num_of_patients = d.num_of_patients ? Number(d.num_of_patients.value) : null;
    
    // nando または year が null の場合はスキップ
    if (nando === null || year === null) return;

    // 既に nando_id のデータが tree 内にあれば、年の患者数を更新
    const index = tree.findIndex(v => v.nando === nando);
    if (index > -1) {
      tree[index][`num_of_${year}`] = num_of_patients;
      return;
    }

    // 以下は新しい nando_id が出てきた最初の行の処理(まだ nando_id のデータが tree にない)
    // 各年の患者数を null にしたオブジェクトを作成
    let newData = {
      s: d.s ? d.s.value : null,
      nando,
      label: d.label ? d.label.value : null,
      label_en: d.label_en ? d.label_en.value : null,
      number: d.number && d.number.value ? Number(d.number.value) : null,
      num_of_2015: null,
      num_of_2016: null,
      num_of_2017: null,
      num_of_2018: null
    };

    // この行に含まれる年の患者数を更新
    newData[`num_of_${year}`] = num_of_patients;
    tree.push(newData);
  });
  return tree;
};

```
## Description
- 2024/10/21　新規追加　小児慢性の患者数の表示用
