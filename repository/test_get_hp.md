# Get phenotype data

## Endpoint

https://dev-pubcasefinder.dbcls.jp/sparql/

## `nando2mondo` get mondo_id correspoinding to nando_id

```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT ?nand ?nandoid ?mondo ?mondo_id
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier ?nandoid .
  OPTIONAL {
    {
      ?nando skos:closeMatch ?mondo .
    }
    UNION
    {
      ?nando skos:exactMatch ?mondo .
    }
    ?mondo oboInOwl:id ?mondo_id
  }
   }
```

## `mondo_uri_list` get mondo uri

```javascript
({
  json({nando2mondo}) {
    let rows = nando2mondo.results.bindings;
    let mondo_uris = [];
    
    for (let i = 0; i < rows.length; i++) {
      if (rows[i].mondo_id) {
        mondo_uris.push((rows[i].mondo_id.value).replace('MONDO:', 'MONDO_'));
      } else {
        mondo_uris.push("NA");
      }
    }
    //return mondo_uris[0]
    return "obo:" + mondo_uris.join(' obo:')
  }
})
```


## Endpoint

https://dev-pubcasefinder.dbcls.jp/sparql/

## `phenotype` retrieve phenotypes associated with the mondo uri

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX mim: <http://identifiers.org/mim/>
PREFIX oa: <http://www.w3.org/ns/oa#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX dcterms: <http://purl.org/dc/terms/>

SELECT DISTINCT
?hpo_id
?hpo_url
?hpo_label_en
?hpo_label_ja
WHERE { 
  {{#if mondo_uri_list}}
	VALUES ?mondo_uri { {{mondo_uri_list}} }
  {{/if}}
    
  ?an rdf:type oa:Annotation ;
      oa:hasTarget [rdfs:seeAlso ?mondo_uri] ;
      oa:hasBody ?hpo_url ;
      dcterms:source [dcterms:creator ?creator] .
  FILTER(?creator NOT IN("Database Center for Life Science"))
    
  GRAPH <https://pubcasefinder.dbcls.jp/rdf/ontology/hp>{
    optional { ?hpo_category rdfs:subClassOf obo:HP_0000118 . }
    ?hpo_url rdfs:label ?hpo_label_en .
    ?hpo_url <http://www.geneontology.org/formats/oboInOwl#id> ?hpo_id .
    ?hpo_url obo:IAO_0000115 ?definition .
  }
    
 optional { ?hpo_url rdfs:label ?hpo_label_ja . FILTER (lang(?hpo_label_ja) = "ja") }    
}

```
## Output

```html

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nando to HPO Mapping</title>
</head>
<body>
    <h1>Nando to HPO Mapping Results</h1>
    <pre id="results"></pre> <!-- 結果を表示する場所 -->

    <script>
        // データの仮定したSPARQLクエリ結果
        const nando2mondoResults = [
            { nando: "nando:001", mondo_id: "MONDO:00001" },
            { nando: "nando:002", mondo_id: "MONDO:00002" },
            { nando: "nando:003", mondo_id: "MONDO:00003" }, // 対応なしデータ
        ];

        const phenotypeResults = [
            { mondo_id: "MONDO_00001", hpo_id: "HP:0004322" },
            { mondo_id: "MONDO_00001", hpo_id: "HP:0001250" },
            { mondo_id: "MONDO_00002", hpo_id: "HP:0004322" },
        ];

        // データ検証関数
        function validateData(data, name) {
            if (!data || data.length === 0) {
                console.error(`${name} is missing or empty.`);
                return false;
            }
            return true;
        }

        // フォーマット統一関数
        function normalizeMondoId(mondoId) {
            if (mondoId.includes("_")) {
                return mondoId.replace("_", ":");
            } else if (mondoId.includes(":")) {
                return mondoId.replace(":", "_");
            }
            return mondoId;
        }

        // nandoとhpoの対応付けを行う関数
        function mapNandoToHpo(nando2mondo, phenotype) {
            const result = [];

            nando2mondo.forEach((nandoItem) => {
                if (!nandoItem.mondo_id) {
                    console.warn(`Missing mondo_id for nando: ${nandoItem.nando}`);
                    result.push({
                        nando: nandoItem.nando,
                        mondo_id: nandoItem.mondo_id || "No MONDO ID",
                        hpo_id: "No associated HPO",
                    });
                    return;
                }

                // `nandoItem.mondo_id`を統一
                const normalizedMondoId = normalizeMondoId(nandoItem.mondo_id);

                // phenotypeResultsから対応するmondo_idを探す
                const relatedPhenotypes = phenotype.filter(
                    (phenotypeItem) =>
                        normalizeMondoId(phenotypeItem.mondo_id) === normalizedMondoId
                );

                if (relatedPhenotypes.length > 0) {
                    // 対応がある場合
                    relatedPhenotypes.forEach((phenotypeItem) => {
                        result.push({
                            nando: nandoItem.nando,
                            mondo_id: nandoItem.mondo_id,
                            hpo_id: phenotypeItem.hpo_id,
                        });
                    });
                } else {
                    // 対応がない場合
                    result.push({
                        nando: nandoItem.nando,
                        mondo_id: nandoItem.mondo_id,
                        hpo_id: "No associated HPO",
                    });
                }
            });

            return result;
        }

        // 実行処理
        function main() {
            // データ検証
            if (
                !validateData(nando2mondoResults, "nando2mondoResults") ||
                !validateData(phenotypeResults, "phenotypeResults")
            ) {
                return; // エラー時は処理を終了
            }

            // マッピング処理
            const nandoToHpoMapping = mapNandoToHpo(nando2mondoResults, phenotypeResults);

            // 結果をテキスト形式に変換
            const resultText = nandoToHpoMapping
                .map(
                    (item) =>
                        `${item.nando}\t${item.mondo_id}\t${item.hpo_id}`
                )
                .join("\n");

            console.log("Mapping Results:");
            console.log(resultText);

            // 結果をWebページに表示
            document.getElementById("results").textContent = resultText;
        }

        // 実行
        main();
    </script>
</body>
</html>





```
## Description
- NanbyoDataで症状を表示させるためのSPARQListです。
- NANDOからMONDOへ変更し、MONDOからHPOのIDを取得しています。
- 編集：高月（2024/01/12)