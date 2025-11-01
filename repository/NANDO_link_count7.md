# NANDO_link_count7_clinvar

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `nando2mondo2medgen`
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX mo: <http://med2rdf/ontology/medgen#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT ?medgen_cid 
WHERE {
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
  }
  GRAPH <https://nanbyodata.jp/rdf/medgen> { 
    ?medgen_uri
    dct:identifier ?medgen ;
    mo:mgconso ?mgconso .
    ?mgconso
    dct:source mo:MONDO ;
    rdfs:seeAlso ?mondo.
    BIND (CONCAT("http://ncbi.nlm.nih.gov/medgen/",?medgen)AS ?medgen_id)
    BIND (IRI(?medgen_id)AS ?medgen_cid)
  }
}
 ```
 ## `medgen`
 ```javascript
({nando2mondo2medgen}) => {
  return nando2mondo2medgen.results.bindings.map(b => b.medgen_cid.value);
}

```
## Endpoint
https://grch38.togovar.org/sparql

## `result1`
```sparql
PREFIX cvo:    <http://purl.jp/bio/10/clinvar/>
PREFIX dct:    <http://purl.org/dc/terms/>
PREFIX medgen: <http://ncbi.nlm.nih.gov/medgen/>
PREFIX rdfs:   <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio:    <http://semanticscience.org/resource/>
PREFIX tgvo:   <http://togovar.biosciencedbc.jp/vocabulary/>

SELECT count(distinct ?clinvar) as ?num
WHERE {
  VALUES ?med_id { {{#each medgen}} <{{this}}> {{/each}} } 

  GRAPH <http://togovar.org/clinvar> {
    ?med_id ^dct:references ?_classified_condition .

    ?_classified_condition ^cvo:classified_condition/^cvo:classified_condition_list ?_rcv ;
      rdfs:label ?condition .

    ?_rcv cvo:rcv_classifications/cvo:germline_classification/cvo:description/cvo:description ?interpretation ;
      cvo:rcv_classifications/cvo:germline_classification/cvo:description/cvo:date_last_evaluated ?last_evaluated ;
      ^cvo:rcv_accession/^cvo:rcv_list/^cvo:classified_record ?clinvar .
  }
}
                    
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `nando2mondo2medgen2`
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX mo: <http://med2rdf/ontology/medgen#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT ?medgen_cid 
WHERE {
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
  }
  GRAPH <https://nanbyodata.jp/rdf/medgen> { 
    ?medgen_uri
    dct:identifier ?medgen ;
    mo:mgconso ?mgconso .
    ?mgconso
    dct:source mo:MONDO ;
    rdfs:seeAlso ?mondo.
    BIND (CONCAT("http://ncbi.nlm.nih.gov/medgen/",?medgen)AS ?medgen_id)
    BIND (IRI(?medgen_id)AS ?medgen_cid)
  }
}
 ```
 ## `medgen`
 ```javascript
({nando2mondo2medgen2}) => {
  return nando2mondo2medgen2.results.bindings.map(b => b.medgen_cid.value);
}

```
## Endpoint
https://grch38.togovar.org/sparql

## `result2`
```sparql
PREFIX cvo:    <http://purl.jp/bio/10/clinvar/>
PREFIX dct:    <http://purl.org/dc/terms/>
PREFIX medgen: <http://ncbi.nlm.nih.gov/medgen/>
PREFIX rdfs:   <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio:    <http://semanticscience.org/resource/>
PREFIX tgvo:   <http://togovar.biosciencedbc.jp/vocabulary/>

SELECT count(distinct ?clinvar) as ?num
WHERE {
  VALUES ?med_id { {{#each medgen}} <{{this}}> {{/each}} } 

  GRAPH <http://togovar.org/clinvar> {
    ?med_id ^dct:references ?_classified_condition .

    ?_classified_condition ^cvo:classified_condition/^cvo:classified_condition_list ?_rcv ;
      rdfs:label ?condition .

    ?_rcv cvo:rcv_classifications/cvo:germline_classification/cvo:description/cvo:description ?interpretation ;
      cvo:rcv_classifications/cvo:germline_classification/cvo:description/cvo:date_last_evaluated ?last_evaluated ;
      ^cvo:rcv_accession/^cvo:rcv_list/^cvo:classified_record ?clinvar .
  }
}
                    
```
## Output
```javascript
({result1, result2}) => {
  const namedResults = {
    shoman_clinvar: result1,
    shitei_clinvar: result2
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