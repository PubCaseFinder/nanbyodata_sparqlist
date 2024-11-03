# NANDOから糖鎖のデータを取るためのテスト+GlyCosmos gene data　＆　GO Molecular functionの表示
## Parameters
* `nando_id` NANDO ID
  * default: 2200093
  * examples: 1200403
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
SELECT *
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  ?nando_sub rdfs:subClassOf* ?nando.
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
                                 BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .
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
({
  json({ gene }) {
    let rows = gene.results.bindings;
    let glycogene_ids = [];
    
    // 重複を削除するための処理を追加
    for (let i = 0; i < rows.length; i++) {
      if (rows[i].ncbi_id) {
        glycogene_ids.push(rows[i].ncbi_id.value);
      } else {
        glycogene_ids.push("NA");
      }
    }

    // 重複を削除するためにSetを使用
    let unique_ids = [...new Set(glycogene_ids)];

    // unique_idsを文字列に結合して返す
    //return "glycogene:" + unique_ids.join(' glycogene:');//コメントアウト
    //return "http://glycosmos.org/glycogene/" + unique_ids.join(', http://glycosmos.org/glycogene/');
    return unique_ids;//うまくいく方
  }
})



```
## Endpoint
https://ts.glycosmos.org/sparql
## `ncbi2glyco` get glycodata geneid
```sparql
PREFIX glycan: <http://purl.jp/bio/12/glyco/glycan#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX glycogene: <http://glycosmos.org/glycogene/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX ggdb: <http://acgg.asia/ggdb2/>
PREFIX ggdb_owl: <http://purl.jp/bio/12/ggdb/2015/6/owl#>
PREFIX taxonomy: <http://identifiers.org/taxonomy/>
PREFIX sio:<http://semanticscience.org/resource/>
PREFIX up: <http://purl.uniprot.org/core/>
PREFIX go: <http://www.geneontology.org/formats/oboInOwl#>

SELECT DISTINCT ?ncbigene_id ?gene_idStr ?description ?go ?go_term #?go_id
#(GROUP_CONCAT(DISTINCT ?evidence ; separator = "|") AS ?evidences)
#(GROUP_CONCAT(DISTINCT ?pmid_id ; separator = ",") AS ?pmid_ids)
FROM<http://rdf.glycosmos.org/glycogenes> #FROM1
FROM <http://purl.obolibrary.org/obo/go.owl> #FROM2
FROM <http://purl.obolibrary.org/obo/eco.owl> #FROM3

WHERE{
  #VALUES ?glycogene_id { {{ncbigene_id_list}} }
  VALUES ?glycogene_id { {{#each ncbigene_id_list}} <http://glycosmos.org/glycogene/{{this}}> {{/each}} }
  #VALUES ?ncbigene_id { {{#each ncbigene_id_list}} <{{this}}> {{/each}} }
    #BIND (CONCAT("http://glycosmos.org/glycogene/",?ncbigene_id)AS ?glycogene_id)
  ?glycogene_id rdfs:seeAlso ?ggdbgene ;
           a glycan:Glycogene ;
           dcterms:description ?description ;
           glycan:has_taxon taxonomy:9606 .
  ?glycogene_id sio:SIO_000255 ?b .
  ?b up:classifiedWith ?go .
  ?go rdfs:label ?go_term . #below this, FROM2,3 are needed
  ?go go:id ?go_id . 
  ?go go:hasOBONamespace "molecular_function" .
  OPTIONAL{
      ?b dcterms:references ?pmid .
    }
  OPTIONAL{
      ?b sio:SIO_000772 ?eco .
      ?eco go:hasExactSynonym ?evi_label .
      ?eco go:id ?evi_code .
    }
  BIND((CONCAT(?evi_label, ":", ?evi_code)) AS ?evidence)
  BIND(REPLACE(STR(?pmid), "http://identifiers.org/pubmed/", "") AS ?pmid_id)
  BIND(IF(isIRI(?glycogene_id),STRAFTER(STR(?glycogene_id),"glycogene/"),STR(?glycogene_id)) AS ?gene_idStr)
         
}


```