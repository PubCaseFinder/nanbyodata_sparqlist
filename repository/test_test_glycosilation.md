# GlyCosmos Glycoproteins Glycosylation

## Parameters

* `id`
  * default: P08603
  * example: Q9NR99

## Endpoint

https://rdfportal.org/sib/sparql

## `uniprot`

```sparql
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX up: <http://purl.uniprot.org/core/>
SELECT DISTINCT ?uniprot_id ?position ?description (GROUP_CONCAT(DISTINCT ?pubmed_id ; separator = ",") AS ?pubmed_ids)
WHERE{
  VALUES ?uniprot_id {"{{id}}"}
  BIND(IRI(CONCAT("http://purl.uniprot.org/uniprot/", ?uniprot_id)) AS ?protein)
  ?protein rdf:type up:Protein .
  ?state rdf:subject ?protein .
  # Citation
  ?state rdf:predicate up:annotation .
  ?state rdf:object ?object .
  ?object a up:Glycosylation_Annotation .
  ?object rdfs:comment ?description .
  ?object up:range ?range .
  ?range faldo:begin/faldo:position ?position .
  ?state up:attribution ?attr .
  OPTIONAL{
    ?attr up:source ?source .
    ?source a up:Journal_Citation .
    ?source skos:exactMatch ?pubmed_url .
    BIND(STRAFTER(STR(?pubmed_url), "http://purl.uniprot.org/pubmed/") AS ?pubmed_id)
  }
  OPTIONAL{
    ?attr up:evidence ?evi .
    ?evi rdfs:label ?evi_label .
  }
}
GROUP BY ?uniprot_id ?position ?description
ORDER BY ?uniprot_id ?position
```

## `uniprot_data`

```javascript
({
  json({uniprot}){
    let obj = {};
    uniprot.results.bindings.forEach(row => {
      // let source = [];
      // source.push({
      //   "label":"UniProt",
      //   "id": "https://www.uniprot.org/uniprot/" + row.uniprot_id.value + "#ptm_processing"
      // });
      obj[row.position.value] = {
      "description": row.description.value,
      "pubmed_ids": row.pubmed_ids.value.split(','),
      // "source": source
    }
    });
    return obj;
  }
})
```

## Endpoint

https://ts.glycosmos.org/sparql


## `glytoucan`

```sparql
#http://glycosmos-endpoint-proxy:3000/sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX glycan: <http://purl.jp/bio/12/glyco/glycan#>
PREFIX gco: <http://purl.jp/bio/12/glyco/conjugate#>
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
PREFIX mass: <https://glycoinfo.gitlab.io/wurcsframework/org/glycoinfo/wurcsframework/1.0.1/wurcsframework-1.0.1.jar#>
PREFIX sio: <http://semanticscience.org/resource/>
SELECT DISTINCT ?uniprot_id ?site (GROUP_CONCAT(DISTINCT ?output ; separator = ",") AS ?outputs) (GROUP_CONCAT(DISTINCT ?db ; separator = ",") AS ?dbs)
FROM <http://rdf.glycosmos.org/glycoprotein>
FROM <http://rdf.glycosmos.org/glycans/seq>
FROM <http://rdf.glycosmos.org/glycans/subsumption>
WHERE{
  VALUES ?uniprot_id {"{{id}}"}
  VALUES ?protein {<http://glycosmos.org/glycoprotein/{{id}}>}
  ?protein gco:glycosylated_at ?glycosylated .
  ?glycosylated sio:SIO_000772 ?db .
  OPTIONAL{
    ?glycosylated gco:has_saccharide ?gtc .
  }
  BIND(STRAFTER(STR(?gtc), "http://rdf.glycoinfo.org/glycan/") AS ?gtc_id)
  ?glycosylated faldo:location ?location .
  OPTIONAL{
  ?location faldo:position ?site .
  }
  OPTIONAL
  {
    ?gtc glycan:has_glycosequence ?wurcs .
    FILTER(REGEX(STR(?wurcs), "wurcs"))
    ?wurcs glycan:has_sequence ?wurcs_sequence .
    ?wurcs_key_uri rdfs:label ?wurcs_sequence .
    ?wurcs_key_uri mass:WURCSMassCalculator ?mass .
    #BIND(replace(str(?type), "http://www.glycoinfo.org/glyco/owl/relation#", "") AS ?subsumption)
  }
  BIND((CONCAT(?gtc_id, "|", ?mass)) AS ?output)
}
GROUP BY ?uniprot_id ?site
```

## `glytoucan_data`

```javascript
({
  json({glytoucan}){
    let obj = {};
    glytoucan.results.bindings.forEach(row => {
      if(row.site){
        site = row.site.value;
      }else{
        site = "unknown"
      }
      let array1 = [];
      let array2 = [];
      if(row.outputs){
        if(row.outputs.value){
          array1 = row.outputs.value.split(',');
        }
        array1.forEach((value) => array2.push({
          "gtc": value.split('|')[0],
          "mass": Number(value.split('|')[1]).toFixed(2)
        }));
        array2.sort((a, b) => b.mass - a.mass);
      }
      let source = [];
      let dbs = [];
      if(row.dbs.value){
         dbs = row.dbs.value.split(',');
       }
        dbs.forEach((value) => {
          if(value.match(/oglcnac/)){
            label1 = "The O-GlcNAc Database"
            id1 = value.replace("http://rdf.glycoinfo.org/dbid/oglcnac/","https://www.oglcnac.mcw.edu/search/?query_protein=")
          }else if(value.match(/gpdb2/)){
            label1 = "GlycoProtDB"
            id1 = value.replace("http://acgg.asia/gpdb2/","https://acgg.asia/db/gpdb/")
          }else if(value.match(/glyconnect/)){
            label1 = "GlyConnect"
            id1 = value.replace("https://purl.org/glyconnect/protein/","https://glyconnect.expasy.org/all/proteins/")
          }else if(value.match(/glygen/)){
            label1 = "GlyGen"
            id1 = value.replace("http://rdf.glycoinfo.org/dbid/glygen/","https://glygen.org/protein/")
          }else if(value.match(/pubmed/)){
            label1 = "PMID:34782609"
            id1 = value
          }else if(value.match(/uniprot/)){
            label1 = "UniProt"
            id1 = "https://www.uniprot.org/uniprot/" + row.uniprot_id.value + "#ptm_processing"
          }
          source.push({
            "label":label1,
            "id": id1
          })
        });
      obj[site] = {
      "glytoucan_ids": array2,
      "source": source
    }
    });
    return obj;
  }
})
```

## Output

```javascript
({
  json({uniprot_data, glytoucan_data}){
    let set = new Set(Object.keys(uniprot_data).concat(Object.keys(glytoucan_data)));
    let arr = [];
    set.forEach(key => arr.push({
      "position": Number(key),
      "description": uniprot_data[key] ? uniprot_data[key]['description'] : "",
      "pubmed_ids": uniprot_data[key] ? uniprot_data[key]['pubmed_ids'] : [],
      "glytoucan_ids": glytoucan_data[key] ? glytoucan_data[key]['glytoucan_ids'] : [],
      "source": glytoucan_data[key] ? glytoucan_data[key]['source'] :[]
    }));
    arr.sort(function(a,b){
      if(a.position<b.position) return -1;
      if(a.position > b.position) return 1;
      return 0;
    });
    return arr;
  }
})
```
