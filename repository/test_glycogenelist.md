# Retrieve Glycan-related Gene informations in GlyCosmos  by the given NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 2000001
  * examples: 2200093、1200044、1200147
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `nando2mondo` get mondo_id corresponding to nando_id
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
SELECT *
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  ?nando_sub rdfs:subClassOf* ?nando.
   OPTIONAL {
    {
      ?nando_sub skos:closeMatch ?mondo .
    }
    UNION
    {
      ?nando_sub skos:exactMatch ?mondo .
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
https://dev-nanbyodata.dbcls.jp/sparql

## `gene` retrieve genes associated with the mondo uri
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
SELECT DISTINCT ?mondo_uri ?mondo_id ?mondo_label ?gene_id ?hgnc_gene_symbol ?ncbi_id ?omim_id ?nando_ida ?nando_label_ja ?nando_label_en ?nando_idb
 WHERE{
       {SELECT ?disease ?mondo_uri ?mondo_id ?mondo_label ?nando_ida ?nando_label_ja ?nando_label_en ?nando_idb
                        WHERE { VALUES ?mondo_uri { {{mondo_uri_list}} }
                               ?mondo_sub_tier rdfs:subClassOf* ?mondo_uri ;
                                               oboInOwl:id ?mondo_id ;
                                               rdfs:label ?mondo_label;
                                               skos:exactMatch ?exactMatch_disease .
                               FILTER (lang(?mondo_label) = "")  #shin add
                                 FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
                                 BIND (IRI(replace(STR(?exactMatch_disease), 'http://identifiers.org/omim/', 'http://identifiers.org/mim/')) AS ?disease) .
                                OPTIONAL {?nando_ida skos:closeMatch ?mondo_uri;
                                                     dcterms:identifier ?nando_idb;
                                          rdfs:label ?nando_label_ja;
                                          rdfs:label ?nando_label_en.
                                 FILTER( STRSTARTS( ?nando_idb, "{{nando_id_list}}" ))
                                 FILTER( lang(?nando_label_ja)= "ja")
                                 FILTER( lang(?nando_label_en)= "en")}
    }
  }
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
  ?gene_id rdf:type ncit:C16612.
  ?gene_id dcterms:identifier ?ncbi_id.
  ?gene_id rdfs:seeAlso ?omim_id.
}

```
## `ncbigene_id_list`

```javascript
//({
//  json({ gene }) {
//    let rows = gene.results.bindings;
//    let glycogene_ids = [];
//    
//    // 重複を削除するための処理を追加
//    for (let i = 0; i < rows.length; i++) {
//      if (rows[i].ncbi_id) {
//        glycogene_ids.push(rows[i].ncbi_id.value);
//      } else {
//        glycogene_ids.push("NA");
//      }
//    }
//
//    // 重複を削除するためにSetを使用
//    let unique_ids = [...new Set(glycogene_ids)];
//
//    // unique_idsを文字列に結合して返す
//    //return "glycogene:" + unique_ids.join(' glycogene:');//コメントアウト
//    //return "http://glycosmos.org/glycogene/" + unique_ids.join(', http://glycosmos.org/glycogene/');
//    return unique_ids;//うまくいく方
//  }
//})

//補足：上の ncbigene_id_list では ncbi_id が無いときに "NA" を push していますが、正確なユニーク件数が欲しいなら 
//"NA" を入れずにスキップして、配列をだして、件数を表示する
 ({
  json({ gene }) {
    const rows = gene.results.bindings;
    const ids = [];
    for (const r of rows) {
      if (r.ncbi_id && r.ncbi_id.value) ids.push(r.ncbi_id.value);
    }
    const unique = [...new Set(ids)];
    //return unique;            // こちらは配列（従来通り）
    return unique.length;  // 件数だけ返したいならこちら
  }
})
