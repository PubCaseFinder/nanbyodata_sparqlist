# HPにアップロードする遺伝子ファイルを作成する（TXT)

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql/
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

SELECT ?nando ?mondo ?mondo_id
WHERE {
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
      ?nando skos:exactMatch | skos:closeMatch ?mondo .  
    }
  }
  GRAPH <https://nanbyodata.jp/rdf/ontology/mondo> {
    ?mondo oboInOwl:id ?mondo_id .
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
https://dev-nanbyodata.dbcls.jp/sparql/
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

SELECT DISTINCT ?hgnc_gene_symbol ?nando_idb
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
                   dcterms:identifier ?nando_idb.
        ?nando_ida rdfs:label ?nando_label_ja ;
                   rdfs:label ?nando_label_en.
        FILTER(STRSTARTS(?nando_idb, "NANDO:1"))
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

## Description
- 2024/11/20設定


