# get_disease_list

  
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `search` 

```sparql

PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX oa: <http://www.w3.org/ns/oa#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX HP: <http://purl.obolibrary.org/obo/HP_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT DISTINCT ?disease ?id ?label_ja ?label_en ?label_hira ?notification_number ?u_class ?u2_class ?u3_class ?u4_class (GROUP_CONCAT(DISTINCT STR(?hpo_uri); SEPARATOR=",") AS ?hpo_urls)
(GROUP_CONCAT(DISTINCT ?hpo_id; SEPARATOR=",") AS ?hpo_ids) (GROUP_CONCAT(DISTINCT ?hpo_label_en; SEPARATOR=" | ") AS ?hpo_labels_en) (GROUP_CONCAT(DISTINCT ?hpo_label_ja; SEPARATOR=" | ") AS ?hpo_labels_ja)

FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/hp>
FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
  ?disease a owl:Class ;
         dcterms:identifier ?id;
            rdfs:label ?label_ja.
    FILTER(LANG(?label_ja) = 'ja')
 OPTIONAL {
    ?disease rdfs:label ?label_en.
    FILTER(LANG(?label_en) = 'en') 
    }
 OPTIONAL {
      ?disease rdfs:label ?label_hira.
      FILTER(LANG(?label_hira) = 'ja-hira')
    }
   OPTIONAL {
      ?disease nando:hasNotificationNumber ?notification_number.
    }

 OPTIONAL {
      ?disease rdfs:subClassOf ?u_class.
    }
OPTIONAL {
  ?disease rdfs:subClassOf/rdfs:subClassOf ?u2_class .
    }
OPTIONAL {
  ?disease rdfs:subClassOf/rdfs:subClassOf/rdfs:subClassOf ?u3_class .
   }
OPTIONAL {
  ?disease rdfs:subClassOf/rdfs:subClassOf/rdfs:subClassOf/rdfs:subClassOf ?u4_class .
   }
 # disease -> MONDO -> HPO（+ HPO詳細）
  OPTIONAL {
    ?disease (skos:exactMatch|skos:closeMatch) ?mondo_uri .

    ?an rdf:type oa:Annotation ;
        oa:hasBody ?hpo_uri ;
        oa:hasTarget ?t ;
        dcterms:source ?src .
    ?t rdfs:seeAlso ?mondo_uri .
    ?src dcterms:creator ?creator .
    FILTER(?creator NOT IN ("Database Center for Life Science"))

    # ---- HPOのIDとラベル（※このブロックの中に置くのが大事）----
    ?hpo_uri oboInOwl:id ?hpo_id .
    ?hpo_uri rdfs:label ?hpo_label_en .
    FILTER(LANG(?hpo_label_en) = "")

    OPTIONAL {
      ?hpo_uri rdfs:label ?hpo_label_ja .
      FILTER(LANG(?hpo_label_ja) = "ja")
    }
  }
}
GROUP BY
  ?disease ?id ?label_ja ?label_en ?label_hira ?notification_number
  ?u_class ?u2_class ?u3_class ?u4_class

```
## Output

```javascript

({ search }) => {
  let tree = [];
  let uniqueCheck = new Set();

  const P11 = "http://nanbyodata.jp/ontology/NANDO_11";
  const P21 = "http://nanbyodata.jp/ontology/NANDO_21";

  function findGroup(d) {
    const ancestors = [
      d.u_class?.value,
      d.u2_class?.value,
      d.u3_class?.value,
      d.u4_class?.value,
    ].filter(Boolean);

    for (const uri of ancestors) {
      if (uri.startsWith(P11)) return uri;
      if (uri.startsWith(P21)) return uri;
    }
    return null;
  }

  // "a,b,c" → ["a","b","c"] + 重複除去 + trim
  function toList(str) {
    if (!str) return [];
    return [...new Set(
      str.split(",")
        .map(s => s.trim())
        .filter(s => s.length > 0)
    )];
  }

  search.results.bindings.forEach(d => {
    const id = d.id.value;

    if (uniqueCheck.has(id)) return;
    uniqueCheck.add(id);

    const numeric = id.replace(/^NANDO:/, "");
    const prefix = numeric[0];

    const typeMap = { "1": "shitei", "2": "syoman" };
    const category = typeMap[prefix] ?? "other";

    const group = findGroup(d);

    const symptomsEnStr = d.hpo_labels_en?.value ?? "";
    const symptomsJaStr = d.hpo_labels_ja?.value ?? "";

    tree.push({
      id: id,
      label_en: d.label_en?.value ?? "",
      label_ja: d.label_ja?.value ?? "",
      yomigana: d.label_hira?.value ?? "",
      url: d.disease?.value ?? "",
      notificationNumber: d.notification_number?.value ?? "",
      category: category,
      group: group,

      // 文字列版（従来互換）
  //   symptoms_en: symptomsEnStr,
  //    symptoms_ja: symptomsJaStr,

      // 配列版
      symptoms_en_list: toList(symptomsEnStr),
      symptoms_ja_list: toList(symptomsJaStr)
    });
  });

  return tree;
};




```


## Description
- 検索用のAPI 2026/02/16 高月