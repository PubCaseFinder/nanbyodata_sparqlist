# Retrieve Gene informations by the given NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 1200003
  * examples: 1200005
  
## Endpoint
https://nanbyodata.jp/sparql

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

SELECT *
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  ?nando_sub rdfs:subClassOf* ?nando.
  OPTIONAL {
    ?nando_sub skos:exactMatch | skos:closeMatch ?mondo .
    ?mondo oboInOwl:id ?mondo_id
  }
}
```
## `nando_id_list`
```javascript
({nando_id}) => {
  nando_id = "NANDO:" + nando_id.charAt(0);
  return nando_id;
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
https://nanbyodata.jp/sparql
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
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
  {
    SELECT ?disease ?mondo_uri ?mondo_id ?mondo_label ?nando_ida ?nando_label_ja ?nando_label_en ?nando_idb
    WHERE {
      VALUES ?mondo_uri { {{mondo_uri_list}} }
      ?mondo_sub_tier rdfs:subClassOf* ?mondo_uri ;
                      oboInOwl:id ?mondo_id ;
                      rdfs:label ?mondo_label;
                      skos:exactMatch ?exactMatch_disease .
      FILTER (lang(?mondo_label) = "")  #shin add
      FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
      BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .

      OPTIONAL {
        ?nando_ida skos:exactMatch | skos:closeMatch ?mondo_uri ;
                   dcterms:identifier ?nando_idb ;
                   rdfs:label ?nando_label_ja ;
                   rdfs:label ?nando_label_en.
        FILTER(STRSTARTS(?nando_idb, "{{nando_id_list}}"))
        FILTER(lang(?nando_label_ja) = "ja")
        FILTER(lang(?nando_label_en) = "en")
      }
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
ORDER BY ?nando_ida ?hgnc_gene_symbol

```
## Output

```javascript

({ gene }) => {
  let tree = [];
  let uniqueCheck = new Set();

  gene.results.bindings.forEach(d => {
    const geneSymbol = d.hgnc_gene_symbol.value;

    // 既に登録済みの場合はスキップ
    if (uniqueCheck.has(geneSymbol)) return;

    tree.push({
      gene_symbol: geneSymbol,
      omim_url: d.omim_id.value,
      ncbi_id: d.ncbi_id.value,
      ncbi_url: d.gene_id.value,
      mondo_id: d.mondo_id.value,
      mondo_label: d.mondo_label.value,
      mondo_url: d.mondo_id.value.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
      nando_idb: d.nando_idb.value,
      nando_ida: d.nando_ida.value,
      nando_label_e: d.nando_label_en.value,
      nando_label_j: d.nando_label_ja.value
    });

    // 登録済みとする
    uniqueCheck.add(geneSymbol);
  });

  return tree;
};


```
## Description
- 2024/11/22 NANDO改変に伴う変更
- 2024/10/31 OMIMのURLが変更になったとの事で修正
- 2024/09/10 MONDOの日本語追加によるSPARLの修正を追加
- 2024/05/13 名称を変更
- nanbyodata_get_gene_by_nando_id =>  nanbyodata_get_causal_gene_by_nando_id
- UIで遺伝子データを表示させるためのSPARQListです。
- NANDOをMONDOに変換し、変換したMONDOを利用して遺伝子関連の情報を取得しています。
- 編集：高月（2024/01//12)


