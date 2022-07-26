# Digitalization of A Bird Atlas of Kenya

Raphaël Nussbaumer<sup>1,[![](https://figshare.com/ndownloader/files/8439032/preview/8439032/preview.jpg)](http://orcid.org/0000-0002-8185-1020)</sup>, Sidney Shema<sup>2</sup>, Sikenykeny Kennedy<sup>2</sup>, Colin Jackson <sup>1,[![](https://figshare.com/ndownloader/files/8439032/preview/8439032/preview.jpg)](http://orcid.org/0000-0003-2280-1397)</sup>

<sup>1</sup>A Rocha Kenya, Watamu, Kenya
<sup>2</sup>National Museums of Kenya, Nairobi, Kenya

**Corresponding author**: Raphaël Nussbaumer ([raphael.nussbaumer@arocha.org](mailto:raphael.nussbaumer@arocha.org))

---

[![DOI:10.15468/vqb2zs](https://zenodo.org/badge/DOI/10.15468/vqb2zs.svg)](https://doi.org/10.15468/vqb2zs)
<div data-badge-popover="right" data-badge-type="1" data-doi="10.15468/vqb2zs" data-condensed="true" data-hide-no-mentions="true" class="altmetric-embed"></div>


[![licensebuttons by-nc](https://licensebuttons.net/l/by-nc/3.0/88x31.png)](https://creativecommons.org/licenses/by-nc/4.0)

**Keywords:** africa, kenya, bird, atlas, breeding, 

## Description

From 1 May 2020 to 15 September 2021, entomologist Mike Clifton (MK), assisted by James Apolloh (JA), conducted a standardized butterfly survey at the A Rocha Kenya Conservation Centre.  They followed a 1km transect three times a day, counting all individual butterflies encountered. The resulting dataset consists of 12 631 entries over 905 surveys, counted over a total of 492 hours. A total of 45 908 individual butterflies were counted consisting of 129 taxons (114 species, 14 genus, 2 families). 

**Geographical coverage:** The same unique transect covering the different habitats found on the A Rocha Kenya property [39.986, 39.990, -3.379, -3.376].

**Taxonomic coverage:** All butterflies defined as the superfamily *Papilionoidea*. Most records were identified at the species level (11 549), while some were left at the genus (1 051) or family (31) level. A total 129 taxons were recorded, including 114 species, 14 genus and 2 families.

**Temporal coverage:** 2020-05-01 to 2021-09-15

## Sampling Methods

### Study Extent

Surveys were performed on 328 days between 2020-05-01 and 2021-09-15 (65% day coverage). On each day, one (5 instances), two (69) or three (254) surveys were conducted starting at 10am, 1pm and 3pm (EDT). Each survey generally lasted 25 to 40 minutes (mean:34; min:18; max:68).

The transect covers all habitats of A Rocha Kenya Conservation Centre, starting from the main building (3°22'41.5"S 39°59'19.8"E), then going through the nature trail (3°22'33.8"S 39°59'15.7"E) and along the beach path (3°22'44.0"S 39°59'21.3"E). The exact transect can be found [on the github repository](https://github.com/A-Rocha-Kenya/Butterfly-Survey-at-A-Rocha-Kenya-Conservation-Centre/blob/main/data/transect.geojson).

### Sampling Description

![image](https://user-images.githubusercontent.com/7571260/161981966-ce19656c-b712-493c-a053-a767e3fe49ef.png)


Each survey was conducted by MC with the assistance of AJ on some occasions. The transect was followed on foot and all butterflies encountered from the path were identified, counted and recorded on a paper datasheet. The use of nets was occasionally employed to facilitate identification. In addition to the start and end times, MK also recorded weather and any special comments. The data was then entered on a computer by MK following guidelines by CJ and technical assistance from RN. 

### Quality Control

While entering the data on the computer, MK was able to check for typos on species and count. 

A standardized verification of the entire dataset was performed by RN. This includes:
- Ensuring a realistic date, start time and end time as well as duration.
- Eliminating surveys which were abandoned (generally caused by extreme weather).
- Validating species name with the function `name_backbone()`of the `rgbif` package. 
The R script employed to perform these steps is [`export_gbif.Rmd`](https://github.com/A-Rocha-Kenya/Butterfly-Survey-at-A-Rocha-Kenya-Conservation-Centre/blob/main/analysis/export_gbif.Rmd). The raw data before validation can be found in the spreadsheet [`Butterfly_mwamba_survey.xlsx`](https://github.com/A-Rocha-Kenya/Butterfly-Survey-at-A-Rocha-Kenya-Conservation-Centre/blob/main/data/Butterfly_mwamba_survey.xlsx).

### Step Description



## How to cite?

> Clifton M, Apolloh J, Nussbaumer R, Jackson C (2022): Butterfly Survey At A Rocha Kenya Conservation Centre. v1. A Rocha Kenya. Dataset/Samplingevent. http://ipt.museums.or.ke/ipt/resource?r=butterfly_survey_at_mwamba&amp;v=1.0

## External links



## Log
- 26/01/2021: RN downloaded the data from Google drive and transformed the old data format into the new format. He deleted the data with the old format on google drive. The new consolidated data is in the spreadsheet `Butterfly_mwamba_survey.xlsx`. A backup is present in the Archive folder

## 
https://docs.gbif.org/georeferencing-best-practices/1.0/en/#grids

https://www.gbif.org/tools/data-validator