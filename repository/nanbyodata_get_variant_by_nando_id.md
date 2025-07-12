# Get variant data in ClinVar or MGeND

## Parameters

* `nando_id` NANDO ID
  * default: 2200053
  * examples: 1200061 1200216 (variant found in mgend)
* `target` target database (either clinvar or mgend)
  * default: clinvar
  * examples: clinvar mgend
  
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

SELECT DISTINCT ?mondo ?medgen_id ?medgen_cid 
WHERE {
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    nando:{{nando_id}} skos:exactMatch | skos:closeMatch ?mondo .
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

## `medgen2togovar`

```javascript
async ({medgen}) => {
  let query = {
    query: {
      disease: {
      "relation": "eq",
      "terms": medgen.map(b => b.replace("http://ncbi.nlm.nih.gov/medgen/",""))
      }
    }
  };

  return await fetch('https://grch38.togovar.org/api/search/variant.json', {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(query)
  }).then(res => res.json());
}
```

## `result`
```javascript
({target, medgen, medgen2togovar, nando2mondo2medgen}) => {
  const medgen_cids = medgen.map(b => b.replace("http://ncbi.nlm.nih.gov/medgen/",""))

  return medgen_cids.flatMap(medgen_cid => {
    return medgen2togovar.data
      .filter(x =>
        x.significance?.some(entry => 
          entry.source === target &&
          entry.conditions.some(cond => cond.medgen == medgen_cid)
        )
      )
      .map(x => {
        const tgv_id = x.id ? x.id : "";

        const tgv_link = tgv_id ? "https://grch38.togovar.org/variant/" + tgv_id : "";

        const position = x.chromosome + ":" + x.position;

        const external_link = target == "clinvar" ? x.external_link.clinvar[0]?.xref : x.external_link.mgend[0]?.xref;

        const external_id = target == "clinvar" ? x.external_link.clinvar[0]?.title : x.external_link.mgend[0]?.title

        const interpretations = x.significance.find(entry => 
          entry.source === target &&
          entry.conditions.medgen == medgen_cid
        )?.interpretations.join(", ");
   
        const type = x.type
   
        const mondo = nando2mondo2medgen.results.bindings.find(
          record => record.medgen_cid.value === "http://ncbi.nlm.nih.gov/medgen/" + medgen_cid).mondo.value
        
        const total_aac = x.frequencies?.reduce((sum, record) => {
          return sum + (record.aac || 0);
        }, 0);

        const total_arc = x.frequencies?.reduce((sum, record) => {
          return sum + (record.arc || 0);
        }, 0);

        return {
          tgv_id: tgv_id,
          tgv_link: tgv_link,
          position: position,
          title: "",
          external_link: external_link,
          external_id: external_id,
          Interpretation: interpretations,
          type: type,
          MedGen_id: medgen_cid,
          MedGen_link: "http://ncbi.nlm.nih.gov/medgen/" + medgen_cid,
          mondo: mondo,
          mondo_id: mondo.replace("http://purl.obolibrary.org/obo/", ""),
          num_homozygous: total_aac > 0 ? total_aac : "",
          num_heterozygous: total_arc > 0 ? total_arc : ""
        };
      });
  });
}
```

## Description
- TogoVarの情報をVirtuosoではなくTogoVarAPIから取得するように変更 三橋 (2025/7/10)
- MedGenのRDFの形式が変わったことによる変更 2024/12/05
- NANDO改変に伴う変更　2024/11/22
- APIの名前の変更（2024/06/27)
- NanbyoDataでヴァリアントの情報を表示させるために利用しているSPARQListです。
- Togovarのエンドポイントを利用しています。
- SPARQListの大元はTogovarから頂いています。
- NANDOからMONDO,MONDOからMedGenのIDに変更して、Clinvarのデータを取得しています。
- 編集：高月（2024/01/12)