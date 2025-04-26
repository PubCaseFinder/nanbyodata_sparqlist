## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `data` get mondo_id correspoinding to nando_id
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
SELECT DISTINCT?nando  ?gene_id ?hgnc_gene_symbol ?ncbi_id  ?nando_id ?mondo_id
 WHERE{
       {SELECT ?disease  ?mondo_id ?mondo_label ?nando ?nando_id
                        WHERE { ?nando skos:closeMatch ?mondo ;
                                       dcterms:identifier ?nando_id.
                               ?mondo  oboInOwl:id ?mondo_id ;
                                               rdfs:label ?mondo_label;
                                               skos:exactMatch ?exactMatch_disease .
                                 FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
                                 BIND (IRI(replace(STR(?exactMatch_disease), 'http://identifiers.org/omim/', 'http://identifiers.org/mim/')) AS ?disease) .
    }
  }
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
  ?gene_id rdf:type ncit:C16612.
  ?gene_id dcterms:identifier ?ncbi_id.
}
order by ?nando_id,?hgnc_gene_symbol
```
## Output
```javascript
({data})=>{
  return data.results.bindings.map(data => {
    return Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  });
}
//高月さんからいただいた全NANDO Idに対する遺伝子などの全情報を取得するSPARQL（2024/9/18）
//2025年4月24日時点で、全てを取得できなくなっていることを確認
```