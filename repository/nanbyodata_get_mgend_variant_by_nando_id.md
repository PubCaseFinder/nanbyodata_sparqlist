# Get variant data in MGeND

## Parameters

* `nando_id` NANDO ID
  * default: 1200010
  * examples: 1200016,1200462
  
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `nando2mondo2mgend`
```sparql

PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX mo: <http://med2rdf/ontology/medgen#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#> 
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
PREFIX mgendo: <http://med2rdf.org/mgend/ontology#> 
PREFIX m2r: <http://med2rdf.org/ontology/med2rdf#>

SELECT DISTINCT ?dbxref ?omimps ?mondo ?mondolabel ?significance ?type ?variantID ?hgvs ?vtype ?position ?ch ?mgendogeneID ?genelabel ?geneXref
FROM <https://nanbyodata.jp/rdf/mgend>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
      nando:{{nando_id}} skos:exactMatch | skos:closeMatch ?mondo .
    }
  }
  GRAPH <https://nanbyodata.jp/rdf/ontology/mondo> {
    ?mondo rdfs:label ?mondolabel; 
    oboInOwl:hasDbXref ?dbxref.
    FILTER contains(?dbxref,'OMIMPS')
    BIND(REPLACE(?dbxref,'OMIMPS:','https://omim.org/phenotypicSeries/PS') AS ?omimps)
    BIND(IRI(?omimps)AS ?omimuri)
  }
   GRAPH <https://nanbyodata.jp/rdf/mgend> {
    ?mgendcase rdfs:seeAlso ?omimuri.
    ?mgendcase mgendo:case_significance ?significance;
               mgendo:variant_type ?type;
               mgendo:variant ?variantID.
    ?variantID rdf:type ?vtype;
               skos:note ?hgvs;
               faldo:location ?blank1.
    FILTER CONTAINS(?hgvs,":c.")
    ?blank1 faldo:position ?position;
               faldo:reference ?ch.
    ?variantID m2r:gene ?mgendogeneID.
    ?mgendogeneID rdfs:label ?genelabel;
                  rdfs:seeAlso ?geneXref.              
  }
}
```
## Output

```javascript
({nando2mondo2mgend}) => {
  let tree = [];
  nando2mondo2mgend.results.bindings.forEach(d => {
    let urlPartsCh = d.ch.value.split('/'); // chのURLをスラッシュで分割
    let chromosomeNumber = urlPartsCh[urlPartsCh.length - 2]; // 最後から2番目の要素が染色体番号

    let urlPartsVtype = d.vtype.value.split('/'); // vtypeのURLをスラッシュで分割
    let variantType = urlPartsVtype[urlPartsVtype.length - 1]; // 最後の要素が変異タイプ

    tree.push({
      omim_id: d.dbxref.value,
      omim_url: d.omimps.value,
      mondo_id: d.mondo.value,
      mondo_label: d.mondolabel.value,
      mondo_url: d.mondo.value.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
      significance: d.significance.value,
      type: d.type.value,
      hgvs: d.hgvs.value,
      vtype: variantType, // 修正した変異タイプ
      position: d.position.value,
      ch: chromosomeNumber, // 修正した染色体番号
      genelabel: d.genelabel.value,
      hgncurl: d.geneXref.value,
      hgncID: d.geneXref.value.replace("http://identifiers.org/hgnc:","HGNC:")
    });
  });
  return tree;
};

```
## Description
- MGenDのデータを取るためのSPARQList