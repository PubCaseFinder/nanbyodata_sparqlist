# test get Glycogene data and NanbyoData ヒトの糖鎖遺伝子（糖鎖関連遺伝子含む）

## Endpoint
https://ts.glycosmos.org/sparql

## `glycogenelist`get glycogenelist for glycogene
```sparql
DEFINE input:inference 'http://purl.obolibrary.org/obo/go.owl'
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


SELECT DISTINCT ?glycogene_id  ?genesymbol 


FROM<http://rdf.glycosmos.org/glycogenes> #FROM1
FROM <http://purl.obolibrary.org/obo/go.owl> #FROM2
FROM <http://purl.obolibrary.org/obo/eco.owl> #FROM3

WHERE{
VALUES ?parent {<http://purl.obolibrary.org/obo/GO_0016757>}
  ?glycogene_id rdfs:seeAlso ?ggdbgene ;
           a glycan:Glycogene ;
           dcterms:description ?description ;
           rdfs:label ?genesymbol ; #genesymbol
           glycan:has_taxon taxonomy:9606 .
  ?glycogene_id sio:SIO_000255 ?b .
   
}


```

## Output
```javascript
({
  json({glycogenelist}) {
    return glycogenelist.results.bindings.map((row) => {
      let glycogene_id = row.glycogene_id.value;
      let genesymbol = row.genesymbol.value;
      
      return {
        "glycosmosgene": glycogene_id,
        "genesymbol":genesymbol
      };
    });
  }
});
```
      