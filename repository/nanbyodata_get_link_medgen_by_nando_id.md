# Get MedGen id by NANDO id
## Parameters
* `nando_id` NANDO ID
  * default: 2200317

## Endpoint

https://pubcasefinder-rdf.dbcls.jp/sparql

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
    ?nando skos:closeMatch|skos:exactMatch ?mondo .
    ?mondo rdfs:label ?mondo_label_ja .
    FILTER (lang(?mondo_label_ja) = "ja")
  }

  # 英語ラベルの取得、または言語タグがない場合
  OPTIONAL {
    ?nando skos:closeMatch|skos:exactMatch ?mondo .
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

  if (result && result.results && result.results.bindings) {
    result.results.bindings.forEach(d => {
      let originalDisease = d.medgen ? d.medgen.value : null;
      let modifiedDisease = originalDisease;

      if (modifiedDisease) {
        if (modifiedDisease.includes("http://www.ncbi.nlm.nih.gov/medgen/")) {
          modifiedDisease = modifiedDisease.replace("http://www.ncbi.nlm.nih.gov/medgen/", "MedGen UID:");
        } 
      }

      let nando = d.nando ? d.nando.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:") : null;
      let mondo_id = d.mondo_id ? d.mondo_id.value : null;

      // nando, mondo_id, originalDisease のすべてが存在する場合のみJSONを生成
      if (nando && mondo_id && originalDisease) {
        let nandoNode = {
          id: nando, // 親ノード (nando)
          uid: d.nando ? d.nando.value : null,
          type: 'parent', // 親ノードであることを示す
        };

        let mondoNode = {
          parent: nando, // nando の子として配置
          id: mondo_id, // 子ノード (mondo_id)
          mondo_label_ja: d.mondo_label_ja ? d.mondo_label_ja.value : null,
          mondo_label_en: d.mondo_label_en ? d.mondo_label_en.value : null,
          mondo_url: mondo_id.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
        };

        let originalDiseaseNode = {
          id: modifiedDisease,
          displayid: modifiedDisease,
          displayid2: d.concept_id ? d.concept_id.value : null,
          mondolink: d.mondo ? d.mondo.value : null,
          parent: mondo_id,
          property: d.property ? d.property.value : null,
          mondo_label_ja2: d.mondo_label_ja ? d.mondo_label_ja.value : null,
          medgen_label: d.concept_name ? d.concept_name.value : null,
          original_disease: originalDisease,
        };

        tree.push(nandoNode);
        tree.push(mondoNode);
        tree.push(originalDiseaseNode);
      }
    });
  }

  return tree;
};

```
## Description
- 2024/11/22 新規設定　NANDO-MONDO-MedGenのLinkを取るSPARQListです　高月