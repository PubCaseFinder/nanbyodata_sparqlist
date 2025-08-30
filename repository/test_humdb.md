# Get Human DataBase data by the given NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 2200460
  * examples: 1200044、2200091

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `nando2humandb` get human database info corresponding to nando_id
```sparql
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX hum: <https://humandbs.dbcls.jp/>
PREFIX mondo: <http://purl.obolibrary.org/obo/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio: <http://semanticscience.org/resource/>
SELECT *
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?hum_uri rdfs:seeAlso nando:{{nando_id}} .
  
  ?hum_uri a sio:SIO_000756 ;
            dcterms:identifier ?hum_id .
  OPTIONAL {
    ?hum_uri rdfs:label ?label_ja .
    FILTER (lang(?label_ja) = "ja")
  }
  OPTIONAL {
    ?hum_uri rdfs:label ?label_en .
    FILTER (lang(?label_en) = "en")
  }
  OPTIONAL {
    ?hum_uri dcterms:accessRights ?type_data_ja .
    FILTER (lang(?type_data_ja) = "ja")
  }
  OPTIONAL {
    ?hum_uri dcterms:accessRights ?type_data_en .
    FILTER (lang(?type_data_en) = "en")
  }
}


```

## Output
```javascript

({
  json({ nando2humandb }) {
    return nando2humandb.results.bindings.map((row) => {

      // 各プロパティの存在をチェックし、デフォルト値を設定
      return {
        "hum_uri": row.hum_uri?.value || "",
        "hum_id": row.hum_id?.value || "",
        "label_ja": row.label_ja?.value || "",
        "label_en": row.label_en?.value || "",
        "type_data_ja": row.type_data_ja?.value || "",
        "type_data_en": row.type_data_en?.value || ""
        
      };
    });
  }
});

```