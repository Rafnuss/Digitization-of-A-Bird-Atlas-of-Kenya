# Atlas taxonomy and record review

[`atlas_taxonomy.csv`](../data/curated/atlas_taxonomy.csv) maps each of the 1,067 atlas entries to an Avibase concept and retains the book's names, source and review notes. SEQs 1–1065 are the book's numbers; `0a` and `0b` distinguish the unnumbered Shoebill and Taita Thrush. A name match alone does not prove that the atlas and Avibase concepts have identical boundaries. Some IDs represent the Kenyan taxon rather than the complete historical species; bracketed Avibase groups can themselves be valid historical concepts.

## Broader or unresolved Avibase concepts

| SEQ | Atlas taxon | Avibase ID | Difference or remaining question |
|---|---|---|---|
| 108 | African Goshawk | [35A1472C](https://avibase.ca/35A1472C) | The atlas-era boundary with *toussenelii* is unverified; the selected concept may instead be narrower. |
| 198 | Purple Gallinule | [AC1E791E](https://avibase.ca/AC1E791E) | The global limits of the atlas's swamphen concept have not been checked. |
| 299 | Herring Gull | [0B1D7616](https://avibase.ca/0B1D7616) | The historical group is broad and its atlas-era limits are uncertain. Its occurrences are reidentified as Lesser Black-backed Gull in the GBIF export. |
| 382 | Scops Owl | [80603CB9](https://avibase.ca/80603CB9) | The broad group includes the atlas's African residents and Palearctic migrants; its complete global limits are unverified. |
| 459 | Green Wood Hoopoe | [A86DA27F](https://avibase.ca/A86DA27F) | The atlas includes *somaliensis* but lists Grant's Wood Hoopoe separately as 460; the selected group may also include Grant's. |
| 505 | Pallid Honeyguide | [5B74A911](https://avibase.ca/5B74A911) | The selected modern species includes *narokensis*, which the atlas lists separately as 506. |
| 678 | Northern Olive Thrush | [CE73F073](https://avibase.ca/CE73F073) | The group includes the atlas's *abyssinicus* and *helleri*, but also Cape and Karoo forms; equivalence to the atlas's global concept is unresolved. |
| 849 | Tropical Boubou | [446E7AE7](https://avibase.ca/446E7AE7) | The selected group is broad; the atlas-era boundary and whether the narrower [9B750B64](https://avibase.ca/9B750B64) is appropriate remain unverified. |
| 938 | Montane White-eye | [70FD20BB](https://avibase.ca/70FD20BB) | The selected group can overlap the separately listed Yellow White-eye (937); membership of the narrower [4CC0651C](https://avibase.ca/4CC0651C) requires checking. |

The 17-entry review also found historical Avibase groups supported by later checklist treatments for 10, 143, 144, 386, 514, 567 and 753, and a historical-name match for 1052. Their full 1980 boundaries have not been independently established; details and sources remain in the curated table. The 51 `kenyan_match` entries also need care when comparing the original global concepts: a Kenyan species assignment can be narrower than the atlas species.

## Occurrence export decisions

[`atlas_record_review.csv`](../data/curated/atlas_record_review.csv) records decisions on the atlas entries, not on all Kenyan records of those species. The original workbook and comparison export preserve the atlas entries. The local GBIF export excludes rejected entries 14, 63, 253, 286, 293, 294, 338, 476, 664, 894, 935, 1006 and 1026, and uncertain entries 13 and 537. These decisions follow the existing GBIF dataset description; their original sources and applicability to each atlas square still need checking, especially 664, for which no citation was recorded.

The GBIF export reidentifies 7 Broad-billed Prion as Slender-billed Prion (*Pachyptila belcheri*) and 299 Herring Gull as Lesser Black-backed Gull (*Larus fuscus*). It preserves the original atlas names and records the reidentification. Taxonomic lumps are retained as separate atlas entries; modern species-level comparison data can include more than one historical taxon.

`scripts/06_prepare_occurrence.m` writes the GBIF file using `verbatimIdentification` and `vernacularName` for the atlas names, `taxonID` for the selected Avibase concept, and `identificationRemarks` for the SEQ and qualifications. `taxonConceptID` may contain a Catalogue of Life ID; a genus-level COL fallback is broader than the atlas taxon and can affect GBIF interpretation. For group concepts without one unambiguous scientific name in the crosswalk, `scientificName` retains the atlas name. The comparison uses `export/comparison/atlas_records.csv` and its own mappings; the local exports are not automatically published to GBIF or the website.
