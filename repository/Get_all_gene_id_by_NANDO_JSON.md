# HPにアップロードする遺伝子ファイルを作成する（JSON)

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql/

## `nando2mondo2gene` get mondo_id correspoinding to nando_id
```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>


SELECT DISTINCT ?nando_id  ?hgnc_gene_symbol
 FROM <https://nanbyodata.jp/rdf/ontology/nando>
 FROM <https://nanbyodata.jp/rdf/ontology/mondo>
 FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
       OPTIONAL {
      ?nando skos:exactMatch | skos:closeMatch ?mondo;
             dcterms:identifier ?nando_id.
      ?mondo  skos:exactMatch ?exactMatch_disease .
     FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
     BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .}
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
}
order by ?nano_id
```

## Output

```javascript

({ nando2mondo2gene }) => {
  let tree = [];
  nando2mondo2gene.results.bindings.forEach(d => {
    // 安全に値をチェック
    const geneSymbol = d.hgnc_gene_symbol?.value || null;
    const nandoIdb = d.nando_id?.value || null;

    tree.push({
      nando_id: nandoIdb,
      gene_symbol: geneSymbol
    });
  });
  return tree;
};


```


