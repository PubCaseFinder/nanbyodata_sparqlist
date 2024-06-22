# Get overview data

## Parameters

* `nando_id` NANDO ID
  * default: 1200005
  * examples: 1200009, 2200865

## Endpoint

https://pubcasefinder-rdf.dbcls.jp/sparql

## `nando2mondo` get mondo_id correspoinding to nando_id

```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT DISTINCT ?mondo_id
FROM <https://pubcasefinder.dbcls.jp/rdf/ontology/nando>
FROM <https://pubcasefinder.dbcls.jp/rdf/ontology/mondo>
WHERE {
  ?nando a owl:Class ;
    dcterms:identifier "NANDO:{{nando_id}}" .
  OPTIONAL {
    ?nando skos:closeMatch ?mondo .
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

https://pubcasefinder-rdf.dbcls.jp/sparql

## `medgen` retrieve information from medgen

```sparql
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix mo: <http://med2rdf/ontology/medgen#>
prefix obo: <http://purl.obolibrary.org/obo/>
prefix dcterms: <http://purl.org/dc/terms/>

SELECT DISTINCT ?medgen ?concept ?concept_id ?concept_name ?definition (GROUP_CONCAT(?label, ":") AS ?labels) ?mondo_uri AS ?mondo
FROM <https://pubcasefinder.dbcls.jp/rdf/ontology/medgen>
WHERE {
  VALUES ?mondo_uri { {{mondo_uri_list}} }
  ?mgconso rdfs:seeAlso ?mondo_uri ;
    dcterms:source mo:MONDO ;
    rdfs:label ?label .
  ?concept a mo:ConceptID ;
    mo:mgconso ?mgconso ;
    skos:definition ?definition ;
    rdfs:label ?concept_name ;
    dcterms:identifier ?concept_id .
  ?medgen rdfs:seeAlso ?concept .        
}
GROUP BY ?medgen ?concept ?definition ?concept_id ?concept_name ?mondo_uri
LIMIT 100

```

## Endpoint

https://pubcasefinder-rdf.dbcls.jp/sparql

## `inheritance` retrieve inheritances associated with the mondo uri

```sparql
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX nando: <http://nanbyodata.jp/ontology/nando#>
PREFIX obo: <http://purl.obolibrary.org/obo/>

SELECT DISTINCT ?inheritance ?inheritance_ja
FROM <https://pubcasefinder.dbcls.jp/rdf/pcf>
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
}
ORDER BY ?inheritance
```

## Endpoint

https://pubcasefinder-rdf.dbcls.jp/sparql

## `result` retrieve a NANDO class

```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT DISTINCT ?nando ?nando_id ?label_ja ?label_hira ?label_en ?alt_label_ja ?alt_label_en ?notification_number 
                ?source ?description ?mondo ?mondo_id ?mondo_description ?site ?db_xref ?altlabel
FROM <https://pubcasefinder.dbcls.jp/rdf/ontology/nando>
FROM <https://pubcasefinder.dbcls.jp/rdf/ontology/mondo>
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
    ?nando skos:closeMatch ?mondo .
    ?mondo oboInOwl:id ?mondo_id .
    ?mondo skos:exactMatch ?db_xref .
    ?mondo obo:IAO_0000115 ?mondo_description.
    ?mondo oboInOwl:hasExactSynonym ?altlabel.  
  }
  OPTIONAL {
    ?nando rdfs:seeAlso ?site
  }
  BIND({{nando_id}} AS ?nando_id)
}
```

## Output

```javascript
/** 引数:1200005 では返ってこないobjectのデータ(テストが終わったら消す事) 
* descritpion: 1200001
* shouman: 2200001
* kegg: 2200053
* urdbms: 1200948
**/
({
  json({result, medgen, inheritance}) {
    const rows = result.results.bindings;
    const medgen_rows = medgen.results.bindings;
    const inheritance_rows = inheritance.results.bindings;
    const data = {};
    const mondo_ids = new Set();
    const mondo_decs = new Set();
    const inheritance_uris = new Set();

    const addLabel = (data, key, value) => {
      if (data[key]) {
        if (!data[key].includes(value)) {
          data[key].push(value);
        }
      } else {
        data[key] = [value];
      }
    }

    rows.forEach(row => {
      if (row.nando_id) data.nando_id = row.nando_id.value;
      if (row.label_en) data.label_en = row.label_en.value;
      if (row.label_ja) data.label_ja = row.label_ja.value;
      if (row.label_hira) data.ruby = row.label_hira.value;
      if (row.alt_label_en) addLabel(data, 'alt_label_en', row.alt_label_en.value);
      if (row.alt_label_ja) addLabel(data, 'alt_label_ja', row.alt_label_ja.value);
      if (row.notification_number) data.notification_number = row.notification_number.value;
      if (row.description) data.description = row.description.value;
      if (row.source) data.source = row.source.value;

      if (row.site) {
        const siteValue = row.site.value;
        const siteId = siteValue.split("/").slice(-1)[0];
        if (/entry/.test(siteValue)) {
          data.nanbyou = { id: siteId, url: siteValue };
        } else if (/mhlw/.test(siteValue) || /wp-content/.test(siteValue)) {
          data.mhlw = { id: siteId, url: siteValue };
        } else if (/shouman/.test(siteValue)) {
          data.shouman = { id: siteValue.split("/").slice(-2)[0], url: siteValue };
        } else if (/kegg/.test(siteValue)) {
          data.kegg = { id: siteId.replace('www_bget?ds_ja:', ''), url: siteValue };
        } else if (/UR-DBMS/.test(siteValue)) {
          data.urdbms = { id: siteId.replace('SyndromeDetail.php?winid=1&recid=', ''), url: siteValue };
        }
      }

      if (row.mondo) {
        const mondoId = row.mondo_id.value;
        if (!mondo_ids.has(mondoId)) {
          data.mondos = data.mondos || [];
          data.mondos.push({ url: mondoId.replace("MONDO:", "https://monarchinitiative.org/MONDO:"), id: mondoId });
          mondo_ids.add(mondoId);
        }

        if (row.db_xref) {
          const dbXrefUri = row.db_xref.value;
          if (!data.db_xrefs) data.db_xrefs = { orphanet: [], omim: [] }
          if (dbXrefUri.match(/Orphanet_/)) {
            const id = dbXrefUri.split("/").slice(-1)[0].replace('Orphanet_', '')
            if (!data.db_xrefs.orphanet.some(v => v.id === id)) {
              data.db_xrefs.orphanet.push({ url: dbXrefUri.replace('http://www.orpha.net/ORDO/Orphanet_', 'https://www.orpha.net/en/disease/detail/'), id });
            }
          } else if (dbXrefUri.match(/omim/)) {
            const id = dbXrefUri.split("/").slice(-1)[0]
            if (!data.db_xrefs.omim.some(v => v.id === id)) {
              data.db_xrefs.omim.push({ url: dbXrefUri.replace('omim', 'mim'), id });
            }
          }
        }

        if (row.mondo_description) {
          const mondoDescription = row.mondo_description.value;
          if (!mondo_decs.has(mondoDescription)) {
            data.mondo_decs = data.mondo_decs || [];
            data.mondo_decs.push({ url: row.mondo.value, id: mondoDescription });
            mondo_decs.add(mondoDescription);
          }
        }
      }
    });

    if (medgen_rows.length > 0) {
      const medgenData = medgen_rows.map(row => ({
        medgen: row.medgen.value,
        medgen_id: row.medgen.value.split("/").slice(-1)[0],
        concept: row.concept.value,
        concept_id: row.concept_id.value,
        concept_name: row.concept_name.value,
        definition: row.definition.value,
        labels: Array.from(new Set(row.labels.value.split(":")))
      }));

      medgenData[0].labels = medgenData[0].labels.filter(label => label !== medgenData[0].concept_name);

      if (data.alt_label_en) {
        medgenData[0].labels.forEach(label => {
          if (!data.alt_label_en.includes(label)) {
            data.alt_label_en.push(label);
          }
        });
      } else {
        data.alt_label_en = medgenData[0].labels;
      }

      Object.assign(data, {
        medgen_id: medgenData[0].medgen_id,
        medgen_uri: medgenData[0].medgen,
        concept: medgenData[0].concept,
        concept_name: medgenData[0].concept_name,
        concept_id: medgenData[0].concept_id,
        medgen_definition: medgenData[0].definition
      });
    }

    inheritance_rows.forEach(row => {
      const inheritanceUri = row.inheritance.value;
      const inheritanceJa = row.inheritance_ja.value;
      if (!inheritance_uris.has(inheritanceUri)) {
        data.inheritance_uris = data.inheritance_uris || [];
        data.inheritance_uris.push({ uri: inheritanceUri, id: inheritanceJa });
        inheritance_uris.add(inheritanceUri);
      }
    });

    return data;
  }
})

```

## Description
- 2024/03/21 タイトルを変更　旧：nanbyodata_get_metadata　及び　SPARQL修正
- 現在NanbyouDataの表示で疾患のメタ情報を表示する部分に利用しています。
- 過去のUIからの変遷の結果、部分的に必要の無いパートがあるので、それについての調整中(済）
- NanbyoDataのUI表示で不具合があり、JSの部分を変更しています。
-  case /entry/.test(rows[i].site.value)のentryは以前はnanbyou
-  case /wp-content/.test(rows[i].site.value)を新規に追加
　
- 編集：高月　2024/02/28