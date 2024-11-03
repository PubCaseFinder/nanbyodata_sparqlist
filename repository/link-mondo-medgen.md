# NANDOのリンク情報を表示する (medgen)
## Parameters
* `nando_id` NANDO ID
  * default: 2200317

## Endpoint

https://dev-pubcasefinder.dbcls.jp/sparql/

## `result`
```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mo: <http://med2rdf/ontology/medgen#>
PREFIX nci: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX dct: <http://purl.org/dc/terms/>

SELECT DISTINCT ?nando ?mondo ?mondo_id ?property ?medgen ?concept ?concept_id ?concept_name ?mondo_label_en ?mondo_label_ja
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  
  OPTIONAL {
    {
      ?nando skos:closeMatch ?mondo .
    }
    UNION
    {
      ?nando skos:exactMatch ?mondo .
    }
    ?nando ?property ?mondo.
    ?mondo oboInOwl:id ?mondo_id .
  }

  # 日本語ラベルの取得
  OPTIONAL {
    ?mondo rdfs:label ?mondo_label_ja .
    FILTER (lang(?mondo_label_ja) = "ja")
  }

  # 英語ラベルの取得、または言語タグがない場合
  OPTIONAL {
    ?mondo rdfs:label ?mondo_label_en .
    FILTER (lang(?mondo_label_en) = "en" || lang(?mondo_label_en) = "")
  }

  ?mgconso rdfs:seeAlso ?mondo ;
           dct:source mo:MONDO .
  ?concept a mo:ConceptID ;
           mo:mgconso ?mgconso ;
           rdfs:label ?concept_name ;
           dct:identifier ?concept_id .
  ?medgen rdfs:seeAlso ?concept .        
}


```

## Output

```javascript

({ result }) => {
  let tree = [];

  result.results.bindings.forEach(d => {
    // 結果をtreeに追加
    tree.push({
      nando: d.nando.value,
      property: d.property.value,
      mondo_id: d.mondo_id.value,
      mondo_label_ja: d.mondo_label_ja.value,
      mondo_label_en: d.mondo_label_en.value,
      mondo_url: d.mondo_id.value.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
      concept_id: d.concept_id.value,
      concept_name: d.concept_name.value,
      medgen: d.medgen.value
    });
  });

  return tree;
};


```