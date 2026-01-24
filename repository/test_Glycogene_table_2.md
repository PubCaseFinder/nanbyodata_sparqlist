# test_Glyco gene table2


## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `total_nando2mondo2gene` get mondo_id corresponding to nando_id
```sparql
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT DISTINCT
  ?ncbi_id
  ?nando
  ?nando_id
  ?nando_label
  ?mondo
  ?mondo_id
  ?nando2mondo_match
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
  # NANDO disease (subclass of root)
  ?nando rdfs:subClassOf+ nando:0000001 .
  
  #日本語ラベルを取得
  ?nando rdfs:label ?nando_label .
  FILTER(lang(?nando_label) = "ja")

  # NANDO -> MONDO
  #?nando (skos:exactMatch | skos:closeMatch) ?mondo .
   # ★exact,closeどっちのマッチかを変数で取る
  ?nando ?nando2mondo_match ?mondo .
  FILTER(?nando2mondo_match IN (skos:exactMatch, skos:closeMatch))

  # MONDO -> OMIM/Orphanet
  ?mondo (skos:exactMatch | skos:closeMatch) ?exactMatch_disease .
  FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))

  # normalize disease IRI to identifiers.org/mim
  BIND(IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease)

  # PCF association: disease - gene
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
  ?gene_id dcterms:identifier ?ncbi_id .

  # string IDs for output
  BIND(STRAFTER(STR(?nando), "ontology/") AS ?nando_id)
  BIND(STRAFTER(STR(?mondo), "obo/") AS ?mondo_id)
}



```
## Endpoint
https://ts.glycosmos.org/sparql

## `result3_total` get glycodata geneid
```sparql
PREFIX glycan: <http://purl.jp/bio/12/glyco/glycan#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX taxonomy: <http://identifiers.org/taxonomy/>

SELECT DISTINCT
  ?ncbi_id
  ?glycogene
  ?genesymbol

FROM<http://rdf.glycosmos.org/glycogenes> #FROM1
FROM <http://purl.obolibrary.org/obo/go.owl> #FROM2
FROM <http://purl.obolibrary.org/obo/eco.owl> #FROM3
WHERE {
#  VALUES ?ncbi_id { {{#each total_ncbigene_id_list}} "{{this}}" {{/each}} }

#  BIND( IRI(CONCAT("http://glycosmos.org/glycogene/", ?ncbi_id)) AS ?glycogene )

  # GlyCosmos に本当に存在する Glycogene だけ残す
  ?glycogene rdfs:seeAlso ?ggdbgene ;
           a glycan:Glycogene ;
           dcterms:description ?description ;
           rdfs:label ?genesymbol ; #genesymbol
           glycan:has_taxon taxonomy:9606 .
           #BIND(IF(isIRI(?glycogene),STRAFTER(STR(?glycogene),"glycogene/"),STR(?glycogene)) AS ?gene_idStr)
  BIND(STRAFTER(STR(?glycogene), "glycogene/") AS ?ncbi_id)
  
}

           
```



## Output
```javascript
({
  json({ total_nando2mondo2gene, result3_total }) {

    // 1) GlyCosmos: ncbi_id -> { glycogene, gene_symbol }
    const gRows = result3_total.results.bindings;
    const ncbi2gly = new Map();

    for (const r of gRows) {
      const ncbi = r.ncbi_id?.value;
      if (!ncbi) continue;

      ncbi2gly.set(ncbi, {
        glycogene: r.glycogene?.value ?? "NA",
        genesymbol: r.genesymbol?.value ?? "NA"
      });
    }

    // 2) NANDO 側と結合
    const nRows = total_nando2mondo2gene.results.bindings;
    const out = [];

    for (const r of nRows) {
      const ncbi = r.ncbi_id?.value;
      if (!ncbi) continue;

      const glyInfo = ncbi2gly.get(ncbi);
      if (!glyInfo) continue; // GlyCosmos に無い gene は除外

      const nandoUri = r.nando?.value ?? "NA";

      // ★追加：NANDOカテゴリ判定（NANDO_1xxxx => 指定難病, NANDO_2xxxx => 小児慢性特定疾病）
      let nando_category = "その他";
      const m = /NANDO_(\d)/.exec(nandoUri);
      if (m) {
        if (m[1] === "1") nando_category = "指定難病";
        else if (m[1] === "2") nando_category = "小児慢性特定疾病";
      }
	  // MondoとNANDOの類似性
      const matchIRI = r.nando2mondo_match?.value ?? "";
      const match_type =
        matchIRI.endsWith("exactMatch") ? "exactMatch" :
        matchIRI.endsWith("closeMatch") ? "closeMatch" :
        "other";    
      

      out.push({
        glycogene: glyInfo.glycogene,
        genesymbol: glyInfo.genesymbol,
        ncbi_id: ncbi,
        nando: nandoUri,
        nando_id: r.nando_id?.value ?? "NA",
        nando_category, // ★追加列
        nando_label: r.nando_label?.value ?? "NA",
        mondo_id: r.mondo_id?.value ?? "NA",
        nando2mondo_match: match_type
      });
    }

    // 3) 重複排除
    const uniq = [];
    const seen = new Set();
    for (const row of out) {
      const key = JSON.stringify(row);
      if (!seen.has(key)) {
        seen.add(key);
        uniq.push(row);
      }
    }

    return uniq;

  }
})

```
## Description
- 2026/1/15作成
- javascriptで集合サイズを出力する
({
  json({ total_nando2mondo2gene, result3_total }) {

    const nRows = total_nando2mondo2gene.results.bindings;
    const gRows = result3_total.results.bindings;

    const nSet = new Set(nRows.map(r => r.ncbi_id?.value).filter(Boolean));
    const gSet = new Set(gRows.map(r => r.ncbi_id?.value).filter(Boolean));

    let inter = 0;
    for (const x of nSet) if (gSet.has(x)) inter++;

    return {
      nando_unique_ncbi: nSet.size,
      glycosmos_unique_ncbi: gSet.size,
      intersection_ncbi: inter
    };
  }
})

- glycogene idのカウント
// 3) 重複排除から上書きするとできる

    // 3) 重複排除
    const uniq = [];
    const seen = new Set();
    for (const row of out) {
      const key = JSON.stringify(row);
      if (!seen.has(key)) {
        seen.add(key);
        uniq.push(row);
      }
    }

    //return uniq;
    // ★追加：最終出力に含まれるユニーク遺伝子数
	const uniqueGenes = new Set(uniq.map(r => r.ncbi_id));
	return {
	  gene_count: uniqueGenes.size,
	  row_count: uniq.length,
	  rows: uniq
};
  }
})



