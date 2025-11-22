# NANDO_link_count8_Glyco gene

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `shoman_nando2mondo2gene` get mondo_id corresponding to nando_id
```sparql
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
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT ?ncbi_id
 FROM <https://nanbyodata.jp/rdf/ontology/nando>
 FROM <https://nanbyodata.jp/rdf/ontology/mondo>
 FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
      OPTIONAL {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
      ?mondo  skos:exactMatch | skos:closeMatch ?exactMatch_disease .
     FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
     BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
  ?gene_id dcterms:identifier ?ncbi_id .
}

```
## `shoman_ncbigene_id_list`

```javascript
({
  json({ shoman_nando2mondo2gene }) {
    let rows = shoman_nando2mondo2gene.results.bindings;
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

## `result1_shoman` get glycodata geneid
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

SELECT  count(DISTINCT ?gene_idStr) as ?num 

FROM<http://rdf.glycosmos.org/glycogenes> #FROM1
FROM <http://purl.obolibrary.org/obo/go.owl> #FROM2
FROM <http://purl.obolibrary.org/obo/eco.owl> #FROM3

WHERE{
  VALUES ?glycogene_id { {{#each shoman_ncbigene_id_list}} <http://glycosmos.org/glycogene/{{this}}> {{/each}} }

  ?glycogene_id rdfs:seeAlso ?ggdbgene ;
           a glycan:Glycogene ;
           dcterms:description ?description ;
           rdfs:label ?genesymbol ; #genesymbol
           glycan:has_taxon taxonomy:9606 .
           BIND(IF(isIRI(?glycogene_id),STRAFTER(STR(?glycogene_id),"glycogene/"),STR(?glycogene_id)) AS ?gene_idStr)
  
}

           
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `shitei_nando2mondo2gene2` get mondo_id corresponding to nando_id
```sparql
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
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT ?ncbi_id
 FROM <https://nanbyodata.jp/rdf/ontology/nando>
 FROM <https://nanbyodata.jp/rdf/ontology/mondo>
 FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
      OPTIONAL {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
      ?mondo  skos:exactMatch | skos:closeMatch ?exactMatch_disease .
     FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
     BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
  ?gene_id dcterms:identifier ?ncbi_id .
}

```
## `shitei_ncbigene_id_list`

```javascript
({
  json({ shitei_nando2mondo2gene2 }) {
    let rows = shitei_nando2mondo2gene2.results.bindings;
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

## `result2_shitei` get glycodata geneid
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

SELECT  count(DISTINCT ?gene_idStr) as ?num 

FROM<http://rdf.glycosmos.org/glycogenes> #FROM1
FROM <http://purl.obolibrary.org/obo/go.owl> #FROM2
FROM <http://purl.obolibrary.org/obo/eco.owl> #FROM3

WHERE{
  VALUES ?glycogene_id { {{#each shitei_ncbigene_id_list}} <http://glycosmos.org/glycogene/{{this}}> {{/each}} }

  ?glycogene_id rdfs:seeAlso ?ggdbgene ;
           a glycan:Glycogene ;
           dcterms:description ?description ;
           rdfs:label ?genesymbol ; #genesymbol
           glycan:has_taxon taxonomy:9606 .
           BIND(IF(isIRI(?glycogene_id),STRAFTER(STR(?glycogene_id),"glycogene/"),STR(?glycogene_id)) AS ?gene_idStr)
  
}
                          
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `total_nando2mondo2gene` get mondo_id corresponding to nando_id
```sparql
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
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT ?ncbi_id
 FROM <https://nanbyodata.jp/rdf/ontology/nando>
 FROM <https://nanbyodata.jp/rdf/ontology/mondo>
 FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
      OPTIONAL {
       ?sub rdfs:subClassOf+ nando:0000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
      ?mondo  skos:exactMatch | skos:closeMatch ?exactMatch_disease .
     FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
     BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
  ?gene_id dcterms:identifier ?ncbi_id .
}

```
## `total_ncbigene_id_list`

```javascript
({
  json({ total_nando2mondo2gene }) {
    let rows = total_nando2mondo2gene.results.bindings;
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

## `result3_total` get glycodata geneid
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

SELECT  count(DISTINCT ?gene_idStr) as ?num 

FROM<http://rdf.glycosmos.org/glycogenes> #FROM1
FROM <http://purl.obolibrary.org/obo/go.owl> #FROM2
FROM <http://purl.obolibrary.org/obo/eco.owl> #FROM3

WHERE{
  VALUES ?glycogene_id { {{#each total_ncbigene_id_list}} <http://glycosmos.org/glycogene/{{this}}> {{/each}} }

  ?glycogene_id rdfs:seeAlso ?ggdbgene ;
           a glycan:Glycogene ;
           dcterms:description ?description ;
           rdfs:label ?genesymbol ; #genesymbol
           glycan:has_taxon taxonomy:9606 .
           BIND(IF(isIRI(?glycogene_id),STRAFTER(STR(?glycogene_id),"glycogene/"),STR(?glycogene_id)) AS ?gene_idStr)
  
}

           
```



## Output
```javascript
({result1_shoman,result2_shitei,result3_total}) => {
  const namedResults = {
    glyco_gene_shoman: result1_shoman,
    glyco_gene_shitei: result2_shitei,
    glyco_gene_total: result3_total
  };

  const processed = {};

  for (const [name, result] of Object.entries(namedResults)) {
    const data = result.results.bindings[0];
    processed[name] = Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  }

  return processed;
}


```
