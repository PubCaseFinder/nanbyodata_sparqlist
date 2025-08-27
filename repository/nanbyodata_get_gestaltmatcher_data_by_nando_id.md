# Get gestaltmatcher face image data
## Parameters
* `nando_id` NANDO ID
  * default: 1200922
  
## Endpoint
https://nanbyodata.jp/sparql

## `gm` retrieve gm information by the given NANDO ID

```sparql
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix gm: <https://db.gestaltmatcher.org/patients/>
prefix obo: <http://purl.obolibrary.org/obo/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix : <http://nanbyodata.jp/ontology/NANDO_>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix xml: <http://www.w3.org/XML/1998/namespace>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix owl: <http://www.w3.org/2002/07/owl#>
prefix dcterms: <http://purl.org/dc/terms/>
prefix sio: <http://semanticscience.org/resource/>
prefix OMIM: <https://omim.org/entry/>
prefix bibo: <http://purl.org/ontology/bibo/>
prefix wd: <http://www.wikidata.org/entity/>
prefix wdt: <http://www.wikidata.org/prop/direct/>
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix foaf: <http://xmlns.com/foaf/0.1/>
prefix time: <http://www.w3.org/2006/time#>

SELECT DISTINCT   ?nando ?mondo ?exactMatch_disease ?person ?disease_name ?id ?image ?gender ?gene ?ncbi ?minzoku ?minzokumemo ?image_id ?image_desc
?update ?pmid ?pmid_url ?year ?month ?age_memo 
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  # NANDO → MONDO → OMIM
  ?nando dcterms:identifier "NANDO:{{nando_id}}"  .
  ?nando skos:exactMatch ?mondo .
  ?mondo skos:exactMatch ?exactMatch_disease .
  FILTER(STRSTARTS(STR(?exactMatch_disease), "https://omim.org/entry/"))
  
  # GM 側（ブランクノードを介して person と接続）
  ?b1 rdfs:seeAlso ?exactMatch_disease;
      rdfs:label ?disease_name .   
  ?person sio:SIO_001279 ?b1 .
  
  # person 基本情報
  ?person dcterms:identifier ?id ;
          foaf:depiction ?image .
  OPTIONAL { ?person foaf:gender ?gender . }
  
  # 遺伝子
  OPTIONAL {
    ?person sio:SIO_000008 ?geneNode .
    OPTIONAL { ?geneNode rdfs:label ?gene . }
    OPTIONAL { ?geneNode (rdfs:seeAlso|skos:exactMatch|owl:sameAs) ?ncbi . }
  }
  
   # 民族
  OPTIONAL {
    ?person wdt:P172 ?eth .
    OPTIONAL { ?eth rdfs:label    ?minzoku . }
    OPTIONAL { ?eth dc:description ?minzokumemo . }
  }

    # 画像情報
  OPTIONAL { ?image dcterms:identifier ?image_id . }
  OPTIONAL { ?image dc:description ?image_desc . }
  OPTIONAL { ?image dcterms:modified ?update . }
  

  # 参考文献
  OPTIONAL {
    ?image dcterms:references ?ref .
    OPTIONAL { ?ref dcterms:identifier ?pmid . }
    OPTIONAL { ?ref rdfs:seeAlso ?pmid_url . }
  }
  
   # 年齢情報
  OPTIONAL {
    ?image gm:age ?ageB .
    OPTIONAL { ?ageB dc:description ?age_memo . }
    OPTIONAL { ?ageB time:year  / sio:SIO_000216 ?year . }
    OPTIONAL { ?ageB time:month / sio:SIO_000216 ?month . }
  }
}

```
## Output

```javascript

({ gm }) => {
  // 値が無ければ空文字にする
  const v = (x) => (x && x.value) ? x.value : "";

  // OMIM: URL → CURIE（OMIM:612219）
  const toOmimCurie = (url) =>
    (typeof url === "string" && url.startsWith("https://omim.org/entry/"))
      ? url.replace("https://omim.org/entry/", "OMIM:")
      : "";

  // MONDO: URL → CURIE（MONDO:0012817）
  // 例: http(s)://purl.obolibrary.org/obo/MONDO_0012817 → MONDO:0012817
  const toMondoCurie = (url) => {
    if (typeof url !== "string") return "";
    // すでに CURIE ならそのまま返す
    if (/^MONDO:\d+$/i.test(url)) return url.toUpperCase();
    // OBO PURL から抽出
    const m = url.match(/\/MONDO_(\d+)\b/i);
    return m ? `MONDO:${m[1].padStart(7, "0")}` : "";
  };

  const tree = [];

  gm.results.bindings.forEach(d => {
    const mondoUrl = v(d.mondo);
    const omimUrl  = v(d.exactMatch_disease);

    tree.push({
      // 既存
      mondo_url:    mondoUrl,
      omim_url:     omimUrl,

      // 追加（ID/CURIE）
      mondo_id:     toMondoCurie(mondoUrl),
      omim_id:      toOmimCurie(omimUrl),

      person:       v(d.person),
      id:           v(d.id),
      disease:      v(d.disease_name),
      image:        v(d.image),
      gender:       v(d.gender),
      gene:         v(d.gene),
      ncbi:         v(d.ncbi),
      minzoku:      v(d.minzoku),
      minzokumemo:  v(d.minzokumemo),
      image_id:     v(d.image_id),
      image_desc:   v(d.image_desc),
      image_update: v(d.update),
      pmid:         v(d.pmid),
      pmid_url:     v(d.pmid_url),
      age_year:     v(d.year),
      age_month:    v(d.month),
      age_memo:     v(d.age_memo),
    });
  });

  return tree;
};


```
## Description
- 2025/08/26作成、顔画像データを取るためのAPI (2025/8/26 高月)
