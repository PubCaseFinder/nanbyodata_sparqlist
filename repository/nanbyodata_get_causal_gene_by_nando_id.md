# Retrieve Gene informations by the given NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 1200003
  * examples: 1200005
  
## Endpoint
https://nanbyodata.jp/sparql

## `gene` retrieve genes associated with the mondo uri

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT DISTINCT ?nando_sub ?nando_sub_id ?nando_label_en ?nando_label_ja ?mondo_sub_tier ?mondo_id1
?mondo_id ?mondo_label_ja ?mondo_label_en ?gene_id ?hgnc_gene_symbol ?ncbi_id ?omim_id 
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
  ?nando dcterms:identifier "NANDO:{{nando_id}}" .
  ?nando_sub rdfs:subClassOf* ?nando .

  OPTIONAL {
    ?nando_sub skos:exactMatch ?mondo ;
               dcterms:identifier ?nando_sub_id ;
               rdfs:label ?nando_label_ja, ?nando_label_en.
    FILTER (lang(?nando_label_ja) = "ja")
    FILTER (lang(?nando_label_en) = "en")
              
    
    ?mondo_sub_tier rdfs:subClassOf* ?mondo ;
                    oboInOwl:id ?mondo_id ;
                    rdfs:label ?mondo_label_en, ?mondo_label_ja ;
                    skos:exactMatch ?exactMatch_disease .
    ?mondo oboInOwl:id ?mondo_id1.
    

    FILTER (lang(?mondo_label_en) = "")  # 英語ラベルは言語タグなし
    FILTER (lang(?mondo_label_ja) = "ja")
    FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
    
    BIND (IRI(replace(STR(?exactMatch_disease), "https://omim.org/entry/", "http://identifiers.org/mim/")) AS ?disease)
  }

  # Gene 関連
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
  ?gene_id rdf:type ncit:C16612 .
  ?gene_id dcterms:identifier ?ncbi_id .
  ?gene_id rdfs:seeAlso ?omim_id .
}
ORDER BY ?hgnc_gene_symbol

```
## Output

```javascript

({ gene }) => {
  let tree = [];
  let uniqueCheck = new Set();

  gene.results.bindings.forEach(d => {
    const geneSymbol = d.hgnc_gene_symbol.value;

    tree.push({
      gene_symbol: geneSymbol,
      omim_url: d.omim_id.value,
      ncbi_id: d.ncbi_id.value,
      ncbi_url: d.gene_id.value,
      mondo_id1: d.mondo_id1.value,
      mondo_id: d.mondo_id.value,
      mondo_label: d.mondo_label_en.value,
      mondo_label_ja: d.mondo_label_ja.value,
      mondo_url: d.mondo_sub_tier.value.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
      nando: d.nando_sub.value,
      nando_id: d.nando_sub_id.value,
      nando_label_en: d.nando_label_en.value,
      nando_label_ja: d.nando_label_ja.value,
      
    });

    // 登録済みとする
    uniqueCheck.add(geneSymbol);
  });

  return tree;
};


```
## Description
- 2025/04/08 改変
- 2024/11/22 NANDO改変に伴う変更
- 2024/10/31 OMIMのURLが変更になったとの事で修正
- 2024/09/10 MONDOの日本語追加によるSPARLの修正を追加
- 2024/05/13 名称を変更
- nanbyodata_get_gene_by_nando_id =>  nanbyodata_get_causal_gene_by_nando_id
- UIで遺伝子データを表示させるためのSPARQListです。
- NANDOをMONDOに変換し、変換したMONDOを利用して遺伝子関連の情報を取得しています。
- 編集：高月（2024/01//12)


