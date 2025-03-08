# Get overview data

## Parameters

* `nando_id` NANDO ID
  * default: 1200473
  * examples: 1200009, 2200865

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `nando2mondo` get mondo_id correspoinding to nando_id

```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT *
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  OPTIONAL {
    ?nando skos:closeMatch | skos:exactMatch ?mondo .
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

https://dev-nanbyodata.dbcls.jp/sparql

## `medgen` retrieve information from medgen

```sparql
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix mo: <http://med2rdf/ontology/medgen#>
prefix obo: <http://purl.obolibrary.org/obo/>
prefix nci: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
prefix dct: <http://purl.org/dc/terms/>

SELECT DISTINCT ?medgen ?concept ?concept_id ?concept_name ?definition (GROUP_CONCAT(?label, ":") AS ?labels) ?mondo_uri AS ?mondo
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/pcf>
FROM <https://nanbyodata.jp/rdf/medgen>
WHERE {
  VALUES ?mondo_uri { {{mondo_uri_list}} }
  ?mgconso rdfs:seeAlso ?mondo_uri ;
    dct:source mo:MONDO ;
    rdfs:label ?label .
  ?concept a mo:ConceptID ;
    mo:mgconso ?mgconso ;
    skos:definition ?definition ;
    rdfs:label ?concept_name ;
    dct:identifier ?concept_id .
  ?medgen rdfs:seeAlso ?concept .        
}
GROUP BY ?medgen ?concept ?definition ?concept_id ?concept_name ?mondo_uri
LIMIT 100

```

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `inheritance` retrieve inheritances associated with the mondo uri

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX mondo: <http://purl.obolibrary.org/obo/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX nando: <http://nanbyodata.jp/ontology/nando#>
PREFIX obo: <http://purl.obolibrary.org/obo/>

SELECT distinct ?inheritance ?inheritance_ja ?inheritance_en
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/pcf>
FROM <https://nanbyodata.jp/rdf/ontology/hp>

WHERE{
  {{#if mondo_uri_list}}
	VALUES ?mondo_uri { {{mondo_uri_list}} }
  {{/if}}

  ?disease rdfs:seeAlso ?mondo_uri ;
           nando:hasInheritance ?inheritance .
  OPTIONAL {
    ?inheritance rdfs:label ?inheritance_ja .
    FILTER (lang(?inheritance_ja) = "ja")
  }
  #optional { ?inheritance rdfs:label ?inheritance_en . FILTER (lang(?inheritance_en) = "en") }
  OPTIONAL {
    ?inheritance rdfs:label ?inheritance_en .
    FILTER (lang(?inheritance_en) = "")
  }
}
ORDER BY ?inheritance
```

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result` retrieve a NANDO class

```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mondo: <http://purl.obolibrary.org/obo/mondo#>

SELECT DISTINCT ?nando ?nando_id ?label_ja ?label_hira ?label_en ?alt_label_ja ?alt_label_en ?notification_number 
                ?source ?description ?mondo ?mondo_id ?mondo_description ?site ?db_xref ?altLabel ?kegg_description
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/ordo>
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?nando a owl:Class ;
    dcterms:identifier "NANDO:{{nando_id}}" .
  OPTIONAL {
    ?nando rdfs:label ?label_ja
    FILTER(LANG(?label_ja) = 'ja')
  }
  OPTIONAL {
    ?nando rdfs:label ?label_hira
    FILTER(LANG(?label_hira) = 'ja-hira')
  }
  OPTIONAL {
    ?nando rdfs:label ?label_en
    FILTER(LANG(?label_en) = 'en')
  }
  OPTIONAL {
    ?nando skos:altLabel ?alt_label_en
    FILTER(LANG(?alt_label_en) = 'en')
  }
  OPTIONAL {
    ?nando skos:altLabel ?alt_label_ja
    FILTER(LANG(?alt_label_ja) = 'ja')
  }
  OPTIONAL {
    ?nando dcterms:source ?source 
  }
  OPTIONAL {
    ?nando nando:hasNotificationNumber ?notification_number
  }
  OPTIONAL {
    ?nando dcterms:description ?description  
  }
  OPTIONAL {
    ?nando skos:exactMatch | skos:closeMatch ?mondo .
    ?mondo oboInOwl:id ?mondo_id .
    ?mondo skos:exactMatch ?db_xref .
    ?mondo obo:IAO_0000115 ?mondo_description .
    ?mondo oboInOwl:hasExactSynonym ?altlabel .
  }
  OPTIONAL {
    ?nando rdfs:seeAlso ?site
  }
  OPTIONAL {
    ?nando oboInOwl:hasDbXref ?kegg .
    ?kegg dc:description ?kegg_description .
           }
  BIND({{nando_id}} AS ?nando_id)
}
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `ordo_desc` retrieve a orphanet description

```sparql
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mondo: <http://purl.obolibrary.org/obo/mondo#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX efo: <http://www.ebi.ac.uk/efo/>

SELECT DISTINCT ?nando ?mondo ?exactMatch_disease as ?ordo ?desc
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/ordo>

WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  
  OPTIONAL {
    ?nando skos:exactMatch | skos:closeMatch ?mondo ;
           ?property ?mondo .
    ?mondo oboInOwl:id ?mondo_id .
    ?mondo skos:exactMatch ?exactMatch_disease.
  }
   FILTER (CONTAINS(STR(?exactMatch_disease), "http://www.orpha.net/ORDO/Orphanet_")).
  OPTIONAL {
    ?exactMatch_disease efo:definition ?desc.
  }
}
```

## Output
```javascript
({
  json({result, medgen, inheritance, ordo_desc}) {
    let rows = result.results.bindings;
    let medgen_rows = medgen.results.bindings;
    let inheritance_rows = inheritance.results.bindings;
    let ordo_desc_rows = ordo_desc.results.bindings;
    let data = {};
    let mondo_ids = [];
    let mondo_decs = [];
 　 let inheritance_uris = [];
    let ordo_dif = [];
    

    for (let i = 0; i < rows.length; i++) {
      // 安全に nando_id を読み取る
      if (rows[i].nando_id && rows[i].nando_id.value) {
        data.nando_id = rows[i].nando_id.value;
      }
      if (rows[i].label_en && rows[i].label_en.value) {
        data.label_en = rows[i].label_en.value;
      }
      if (rows[i].label_ja && rows[i].label_ja.value) {
        data.label_ja = rows[i].label_ja.value;
      }
      if (rows[i].label_hira && rows[i].label_hira.value) {
        data.ruby = rows[i].label_hira.value;
      }

      // alt_label_en
      if (rows[i].alt_label_en && rows[i].alt_label_en.value) {
        if (data.alt_label_en) {
          if (!data.alt_label_en.includes(rows[i].alt_label_en.value)) {
            data.alt_label_en.push(rows[i].alt_label_en.value);
            data.alt_label_en.sort((a, b) => a.localeCompare(b));
          }
        } else {
          data.alt_label_en = [rows[i].alt_label_en.value];
          data.alt_label_en.sort((a, b) => a.localeCompare(b));
        }
      }

      // alt_label_ja
      if (rows[i].alt_label_ja && rows[i].alt_label_ja.value) {
        if (data.alt_label_ja) {
          if (!data.alt_label_ja.includes(rows[i].alt_label_ja.value)) {
            data.alt_label_ja.push(rows[i].alt_label_ja.value);
            data.alt_label_ja.sort((a, b) => a.localeCompare(b, 'ja'));
          }
        } else {
          data.alt_label_ja = [rows[i].alt_label_ja.value];
          data.alt_label_ja.sort((a, b) => a.localeCompare(b, 'ja'));
        }
      }

      // notification_number
      if (rows[i].notification_number && rows[i].notification_number.value) {
        data.notification_number = rows[i].notification_number.value;
      }

      // description
      if (rows[i].description && rows[i].description.value) {
        data.description = rows[i].description.value;
      }

      // kegg description
      if (rows[i].kegg_description && rows[i].kegg_description.value) {
        data.kegg_description = rows[i].kegg_description.value;
      }
      
      // source
      if (rows[i].source && rows[i].source.value) {
        data.source = rows[i].source.value;
      }

      // site
      if (rows[i].site && rows[i].site.value) {
        switch (true) {
          case /entry/.test(rows[i].site.value):
            data.nanbyou = {
              id: rows[i].site.value.split("/").slice(-1)[0],
              url: rows[i].site.value
            };
            break;
          case /mhlw/.test(rows[i].site.value):
            data.mhlw = {
              id: rows[i].site.value.split("/").slice(-1)[0],
              url: rows[i].site.value
            };
            break;
          case /wp-content/.test(rows[i].site.value):
            data.mhlw = {
              id: rows[i].site.value.split("/").slice(-1)[0],
              url: rows[i].site.value
            };
            break;
          case /shouman/.test(rows[i].site.value):
            data.shouman = {
              id: rows[i].site.value.split("/").slice(-2)[0],
              url: rows[i].site.value
            };
            break;
        }
      }

 // mondo / mondo_id / mondo_description
      // ここは rows[i].mondo があっても mondo_id や mondo_description が無いことがあるので
      // 個別に null チェックをする
      if (rows[i].mondo && rows[i].mondo.value) {
        // MONDO-ID の存在を確かめる
        if (rows[i].mondo_id && rows[i].mondo_id.value) {
          // data.mondos
          if (data.mondos) {
            if (!mondo_ids.includes(rows[i].mondo_id.value)) {
              data.mondos.push({
                url: rows[i].mondo_id.value.replace(
                  'MONDO:',
                  'https://monarchinitiative.org/MONDO:'
                ),
                id: rows[i].mondo_id.value
              });
              mondo_ids.push(rows[i].mondo_id.value);
            }
          } else {
            data.mondos = [];
            data.mondos.push({
              url: rows[i].mondo_id.value.replace(
                'MONDO:',
                'https://monarchinitiative.org/MONDO:'
              ),
              id: rows[i].mondo_id.value
            });
            mondo_ids.push(rows[i].mondo_id.value);
          }
        }

       

        // mondo_description
        if (rows[i].mondo_description && rows[i].mondo_description.value) {
          if (data.mondo_decs) {
            if (!mondo_decs.includes(rows[i].mondo_description.value)) {
              data.mondo_decs.push({
                url: rows[i].mondo.value,
                id: rows[i].mondo_description.value
              });
              mondo_decs.push(rows[i].mondo_description.value);
            }
          } else {
            data.mondo_decs = [];
            data.mondo_decs.push({
              url: rows[i].mondo.value,
              id: rows[i].mondo_description.value
            });
            mondo_decs.push(rows[i].mondo_description.value);
          }
        }
      } // if (rows[i].mondo && rows[i].mondo.value)
    } // for rows

    // medgen_data
    let medgen_data = [];
    if (medgen_rows.length > 0) {
      for (let i = 0; i < medgen_rows.length; i++) {
        // 1行ぶんのオブジェクトを一旦作ってから埋める
        let mgObj = {};

        if (medgen_rows[i].medgen && medgen_rows[i].medgen.value) {
          mgObj.medgen = medgen_rows[i].medgen.value;
          mgObj.medgen_id = medgen_rows[i].medgen.value
            .split("/")
            .slice(-1)[0];
        }
        if (medgen_rows[i].concept && medgen_rows[i].concept.value) {
          mgObj.concept = medgen_rows[i].concept.value;
        }
        if (medgen_rows[i].concept_id && medgen_rows[i].concept_id.value) {
          mgObj.concept_id = medgen_rows[i].concept_id.value;
        }
        if (medgen_rows[i].concept_name && medgen_rows[i].concept_name.value) {
          mgObj.concept_name = medgen_rows[i].concept_name.value;
        }
        if (medgen_rows[i].definition && medgen_rows[i].definition.value) {
          mgObj.definition = medgen_rows[i].definition.value;
        }

        // labels
        if (medgen_rows[i].labels && medgen_rows[i].labels.value) {
          mgObj.labels = Array.from(
            new Set(medgen_rows[i].labels.value.split(":"))
          );
          // concept_name を labels から除外
          if (
            mgObj.concept_name &&
            mgObj.labels.indexOf(mgObj.concept_name) !== -1
          ) {
            mgObj.labels.splice(mgObj.labels.indexOf(mgObj.concept_name), 1);
          }
        } else {
          mgObj.labels = [];
        }

        medgen_data.push(mgObj);
      }

      // medgen_data[0] が存在するか確かめてから alt_label_en に合流
      if (medgen_data[0]) {
        if (data.alt_label_en) {
          for (let i = 0; i < medgen_data[0].labels.length; i++) {
            if (!data.alt_label_en.includes(medgen_data[0].labels[i])) {
              data.alt_label_en.push(medgen_data[0].labels[i]);
            }
          }
          data.alt_label_en.sort((a, b) => a.localeCompare(b));
        } else {
          data.alt_label_en = [...medgen_data[0].labels];
          data.alt_label_en.sort((a, b) => a.localeCompare(b));
        }

        // medgen_data[0] の情報を data にコピー
        if (medgen_data[0].medgen_id) {
          data.medgen_id = medgen_data[0].medgen_id;
        }
        if (medgen_data[0].medgen) {
          data.medgen_uri = medgen_data[0].medgen;
        }
        if (medgen_data[0].concept) {
          data.concept = medgen_data[0].concept;
        }
        if (medgen_data[0].concept_name) {
          data.concept_name = medgen_data[0].concept_name;
        }
        if (medgen_data[0].concept_id) {
          data.concept_id = medgen_data[0].concept_id;
        }
        if (medgen_data[0].definition) {
          data.medgen_definition = medgen_data[0].definition;
        }
      }
    }

    // inheritance_rows
    if (inheritance_rows.length > 0) {
      for (let i = 0; i < inheritance_rows.length; i++) {
        // inheritance, inheritance_ja, inheritance_en を安全に取り出す
        let inheritance_uri = null;
        let inheritance_ja = null;
        let inheritance_en = null;

        if (
          inheritance_rows[i].inheritance &&
          inheritance_rows[i].inheritance.value
        ) {
          inheritance_uri = inheritance_rows[i].inheritance.value;
        }
        if (
          inheritance_rows[i].inheritance_ja &&
          inheritance_rows[i].inheritance_ja.value
        ) {
          inheritance_ja = inheritance_rows[i].inheritance_ja.value;
        }
        if (
          inheritance_rows[i].inheritance_en &&
          inheritance_rows[i].inheritance_en.value
        ) {
          inheritance_en = inheritance_rows[i].inheritance_en.value;
        }

        if (inheritance_uri) {
          if (data.inheritance_uris) {
            if (!inheritance_uris.includes(inheritance_uri)) {
              data.inheritance_uris.push({
                uri: inheritance_uri,
                id: inheritance_ja,
                id_en: inheritance_en
              });
              inheritance_uris.push(inheritance_uri);
            }
          } else {
            data.inheritance_uris = [];
            data.inheritance_uris.push({
              uri: inheritance_uri,
              id: inheritance_ja,
              id_en: inheritance_en
            });
            inheritance_uris.push(inheritance_uri);
          }
        }
      }
    }
 // ordo_desc_rows
    if (ordo_desc_rows.length > 0) {
      for (let i = 0; i < ordo_desc_rows.length; i++) {
        let ordo_uri = null;
        let desc = null;
   
        if (
          ordo_desc_rows[i].ordo &&
          ordo_desc_rows[i].ordo.value
        ) {
          ordo_uri = ordo_desc_rows[i].ordo.value;
        }
        if (
          ordo_desc_rows[i].desc &&
          ordo_desc_rows[i].desc.value
        ) {
          desc = ordo_desc_rows[i].desc.value;
        }
       
        if (ordo_uri) {
          if (data.ordo_dif) {
            if (!ordo_dif.includes(ordo_uri)) {
              data.ordo_dif.push({
                uri: ordo_uri,
                data: desc
             });
              ordo_dif.push(ordo_uri);
            }
          } else {
            data.ordo_dif = [];
            data.ordo_dif.push({
              uri: ordo_uri,
              data: desc
             });
            ordo_dif.push(ordo_uri);
          }
        }
      }
    }


    return data;
  }
})
