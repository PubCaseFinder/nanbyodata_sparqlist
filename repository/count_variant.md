# Get variant data in ClinVar (count)

## Parameters

* `med_id` medgen ID
   * default:http://ncbi.nlm.nih.gov/medgen/C4083008


## Endpoint
https://grch38.togovar.org/sparql

## `result`
```sparql
PREFIX cvo:    <http://purl.jp/bio/10/clinvar/>
PREFIX dct:    <http://purl.org/dc/terms/>
PREFIX medgen: <http://ncbi.nlm.nih.gov/medgen/>
PREFIX rdfs:   <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio:    <http://semanticscience.org/resource/>
PREFIX tgvo:   <http://togovar.biosciencedbc.jp/vocabulary/>

SELECT DISTINCT COUNT(DISTINCT ?clinvar) AS ?clinvar_c
WHERE {
  VALUES ?med_id { <{{med_id}}> }  # 変数を適切に挿入
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
({result})=>{ 
  return result.results.bindings.map(data => {
    return Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  });
}
```
## coment
- Clinvarとのリレーションの数をとりたいが、数が多すぎて、TogoVarのエンドポイントにはじかれたので、URL単位で数を出すためのAPIとして利用
