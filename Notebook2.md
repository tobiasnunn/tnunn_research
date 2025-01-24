---
title: "ENS-2002 Scientific Notebook MK2 number 2"
author: "Tobias Nunn"
date: "2025-01-13"
output: 
  html_document: 
    toc: true
    toc_depth: 1
    keep_md: true
---

```{=html}
<style>
    body .main-container {
        max-width: 1200px;
    }
</style>
```



# EggNog-Mapper initial test analysis(2025-01-10 to 2025-01-19)

## Introduction

Aaron emailed me back with advice on a way to make eggNog-mapper/2.1.12 on hawk work. As i am revising for an exam i cant spend too long on this. p.s. i think i did pretty good on the exam

## Methods

From the 10th to the 12th i tried running a **test file** i made earlier in december 2024, i may not have written about it as i didnt get anywhere at that time. This process was also hindered by hawk being very encumbered in the new year meaning it takes a good half day for any results to appear. On the 11th i managed to get a successful result with the .xlsx file i need for the heatmaps for accession 3Dt1c. Today(the 12th) i set off 3 jobs each containing 3 accessions to hopefully get the results of the remaining 9. If there are no complications i will then be in a place where i can obtain the .fastas for the online comparison accessions and then run them through eggNog-mapper. It should be noted that i used the same list of parameters i found on the web version of hawk for this, **screenshot attached.** I had some marginal success, the second set of three finished in over 3 hours, the other 2 sets are still going strong after 8, so ill let them time out over night and see what i have, maybe they will complete, i did give them 12 hours.I then discovered the command `dbmem` which could help to speed up the process. I tested with **this file** set to run over night from roughly 9 30 pm on the 12th to 3 30 am on the 13th, totalling 6 hours for 5 files, not great. I then experimented with taking out some of the arguments `--evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20`, that produced **this script**. Tomorrow(14th) i will have a look at recreating run 1 with `dbmem` switched on. Today(19th), i changed some criteria around so now there are 25 cpus per task, however, i believe i had already been doing this by accident in the previous runs i did. Speed has not picked up considerably, so i may have reached the limits of how fast i can make this and thus, it might be time to email Aaron to see what he thinks.

## Results
Run one had mixed results, 3 sets of 3 ran in parallel, set 1 completed in 3 and a half hours, good. set 2 took 8 and a half hours, bad, set 3 timed out, very bad. so dont have the outputs needed for 1Dt100h or 1Dt1h. Run 2 was more successful, with 5 solid looking outputs in 6 hours. Run 3 did not improve on that time despite the extra parameters being cut.

## Conclusion
It could have been overcrowding on hawk, however it appears that running multiple sets in parallel adversely affects the result, however, i have not tested this with `dbmem` on. The large problem is the volume of samples required, the desired output is 3 heatmaps comparing KO pathways:
- Comparing genera inside sphingomonadaceae
- Comparing genera inside Microbacteriaceae
- Comparing the genera containing just our samples


# Additional pre-eggnog analysis (2025-01-17 to 2025-01-19)

## Introduction
Hawk is still running slow, so while those jobs from the previous section are running, i figured i would like to do something extra to fill time. I wanted to see just how many samples we are going to need to pull down and process for this and get a rough time estimate for that, as well as the API stuff to pull the files down as that is by far the easy bit

## Methods
I started this by making tables based along the sets of samples i am going to need off of the ncbi website. I identified 3 groups of samples:
1. all the genera in the family sphingomonadaceae /
2. all the genera in the family Microbacteriaceae /
3. all the genera containing our flye_asm samples
This fits with the specification of work i was given. Being 2 analyses, 1 for comparing just our genera and another comparing genera in families we have multiple samples in. As of now i am yet to do the API call. (still the 17th) I decided to run some more tests to try cut the time down by adding some more commands to my anothergo.sh script, specifically____ I was having trouble with creating the slurm scripts on hawk, it was a lot of typing complex strings, so i made another script maker to automate that, which will be much more convenient when working at scale, here

## Results




### All tables {.tabset .tabset-pills}

#### Family Sphingomonadaceae


```{=html}
<div id="uihkgyirha" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#uihkgyirha table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#uihkgyirha thead, #uihkgyirha tbody, #uihkgyirha tfoot, #uihkgyirha tr, #uihkgyirha td, #uihkgyirha th {
  border-style: none;
}

#uihkgyirha p {
  margin: 0;
  padding: 0;
}

#uihkgyirha .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 3px;
  border-top-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 3px;
  border-right-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 3px;
  border-bottom-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 3px;
  border-left-color: #D5D5D5;
}

#uihkgyirha .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#uihkgyirha .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#uihkgyirha .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#uihkgyirha .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uihkgyirha .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#uihkgyirha .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uihkgyirha .gt_col_heading {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#uihkgyirha .gt_column_spanner_outer {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#uihkgyirha .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#uihkgyirha .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#uihkgyirha .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#uihkgyirha .gt_spanner_row {
  border-bottom-style: hidden;
}

#uihkgyirha .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#uihkgyirha .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: middle;
}

#uihkgyirha .gt_from_md > :first-child {
  margin-top: 0;
}

#uihkgyirha .gt_from_md > :last-child {
  margin-bottom: 0;
}

#uihkgyirha .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D5D5D5;
  vertical-align: middle;
  overflow-x: hidden;
}

#uihkgyirha .gt_stub {
  color: #FFFFFF;
  background-color: #929292;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D5D5D5;
  padding-left: 5px;
  padding-right: 5px;
}

#uihkgyirha .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#uihkgyirha .gt_row_group_first td {
  border-top-width: 2px;
}

#uihkgyirha .gt_row_group_first th {
  border-top-width: 2px;
}

#uihkgyirha .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uihkgyirha .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}

#uihkgyirha .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#uihkgyirha .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#uihkgyirha .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uihkgyirha .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}

#uihkgyirha .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}

#uihkgyirha .gt_striped {
  background-color: #F4F4F4;
}

#uihkgyirha .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#uihkgyirha .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uihkgyirha .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uihkgyirha .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uihkgyirha .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uihkgyirha .gt_left {
  text-align: left;
}

#uihkgyirha .gt_center {
  text-align: center;
}

#uihkgyirha .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#uihkgyirha .gt_font_normal {
  font-weight: normal;
}

#uihkgyirha .gt_font_bold {
  font-weight: bold;
}

#uihkgyirha .gt_font_italic {
  font-style: italic;
}

#uihkgyirha .gt_super {
  font-size: 65%;
}

#uihkgyirha .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#uihkgyirha .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#uihkgyirha .gt_indent_1 {
  text-indent: 5px;
}

#uihkgyirha .gt_indent_2 {
  text-indent: 10px;
}

#uihkgyirha .gt_indent_3 {
  text-indent: 15px;
}

#uihkgyirha .gt_indent_4 {
  text-indent: 20px;
}

#uihkgyirha .gt_indent_5 {
  text-indent: 25px;
}

#uihkgyirha .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#uihkgyirha div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_title gt_font_normal" style>Table 10 - count of genera in the family Sphingomonadaceae</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style><span class='gt_from_md'>accessions as found in the .tree file outputted by gtdbtk analysis done on 2024-12-24</span></td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="a::stub"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="genus">Family and Genus</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="n">Number of Accessions</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="3" class="gt_group_heading" scope="colgroup" id="f__Sphingomonadaceae">f__Sphingomonadaceae</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_1 genus" class="gt_row gt_left">g__34-65-8</td>
<td headers="f__Sphingomonadaceae stub_1_1 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_2 genus" class="gt_row gt_left gt_striped">g__Actirhodobacter</td>
<td headers="f__Sphingomonadaceae stub_1_2 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_3 genus" class="gt_row gt_left">g__Alg239-R122</td>
<td headers="f__Sphingomonadaceae stub_1_3 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_4 genus" class="gt_row gt_left gt_striped">g__Allosphingosinicella</td>
<td headers="f__Sphingomonadaceae stub_1_4 n" class="gt_row gt_right gt_striped">20</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_5 genus" class="gt_row gt_left">g__Alteraurantiacibacter</td>
<td headers="f__Sphingomonadaceae stub_1_5 n" class="gt_row gt_right">20</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_6 genus" class="gt_row gt_left gt_striped">g__Altererythrobacter_D</td>
<td headers="f__Sphingomonadaceae stub_1_6 n" class="gt_row gt_right gt_striped">2</td></tr>
    <tr><th id="stub_1_7" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_7 genus" class="gt_row gt_left">g__Altererythrobacter_F</td>
<td headers="f__Sphingomonadaceae stub_1_7 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_8 genus" class="gt_row gt_left gt_striped">g__Altericroceibacterium</td>
<td headers="f__Sphingomonadaceae stub_1_8 n" class="gt_row gt_right gt_striped">3</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_9 genus" class="gt_row gt_left">g__Altericroceibacterium_A</td>
<td headers="f__Sphingomonadaceae stub_1_9 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_10" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_10 genus" class="gt_row gt_left gt_striped">g__Alteripontixanthobacter</td>
<td headers="f__Sphingomonadaceae stub_1_10 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_11" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_11 genus" class="gt_row gt_left">g__Alteriqipengyuania</td>
<td headers="f__Sphingomonadaceae stub_1_11 n" class="gt_row gt_right">9</td></tr>
    <tr><th id="stub_1_12" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_12 genus" class="gt_row gt_left gt_striped">g__Alteriqipengyuania_A</td>
<td headers="f__Sphingomonadaceae stub_1_12 n" class="gt_row gt_right gt_striped">2</td></tr>
    <tr><th id="stub_1_13" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_13 genus" class="gt_row gt_left">g__Blastomonas</td>
<td headers="f__Sphingomonadaceae stub_1_13 n" class="gt_row gt_right">8</td></tr>
    <tr><th id="stub_1_14" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_14 genus" class="gt_row gt_left gt_striped">g__CADCVW01</td>
<td headers="f__Sphingomonadaceae stub_1_14 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_15" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_15 genus" class="gt_row gt_left">g__CAHJWT01</td>
<td headers="f__Sphingomonadaceae stub_1_15 n" class="gt_row gt_right">4</td></tr>
    <tr><th id="stub_1_16" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_16 genus" class="gt_row gt_left gt_striped">g__CFH-75059</td>
<td headers="f__Sphingomonadaceae stub_1_16 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_17" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_17 genus" class="gt_row gt_left">g__Caenibius</td>
<td headers="f__Sphingomonadaceae stub_1_17 n" class="gt_row gt_right">5</td></tr>
    <tr><th id="stub_1_18" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_18 genus" class="gt_row gt_left gt_striped">g__Chakrabartia</td>
<td headers="f__Sphingomonadaceae stub_1_18 n" class="gt_row gt_right gt_striped">9</td></tr>
    <tr><th id="stub_1_19" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_19 genus" class="gt_row gt_left">g__Croceibacterium</td>
<td headers="f__Sphingomonadaceae stub_1_19 n" class="gt_row gt_right">15</td></tr>
    <tr><th id="stub_1_20" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_20 genus" class="gt_row gt_left gt_striped">g__Croceicoccus</td>
<td headers="f__Sphingomonadaceae stub_1_20 n" class="gt_row gt_right gt_striped">10</td></tr>
    <tr><th id="stub_1_21" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_21 genus" class="gt_row gt_left">g__Erythrobacter</td>
<td headers="f__Sphingomonadaceae stub_1_21 n" class="gt_row gt_right">66</td></tr>
    <tr><th id="stub_1_22" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_22 genus" class="gt_row gt_left gt_striped">g__GCA-014117445</td>
<td headers="f__Sphingomonadaceae stub_1_22 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_23" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_23 genus" class="gt_row gt_left">g__Glacieibacterium</td>
<td headers="f__Sphingomonadaceae stub_1_23 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_24" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_24 genus" class="gt_row gt_left gt_striped">g__Hankyongella</td>
<td headers="f__Sphingomonadaceae stub_1_24 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_25" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_25 genus" class="gt_row gt_left">g__JACXVD01</td>
<td headers="f__Sphingomonadaceae stub_1_25 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_26" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_26 genus" class="gt_row gt_left gt_striped">g__Novosphingobium</td>
<td headers="f__Sphingomonadaceae stub_1_26 n" class="gt_row gt_right gt_striped">115</td></tr>
    <tr><th id="stub_1_27" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_27 genus" class="gt_row gt_left">g__Novosphingopyxis</td>
<td headers="f__Sphingomonadaceae stub_1_27 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_28" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_28 genus" class="gt_row gt_left gt_striped">g__Pacificimonas</td>
<td headers="f__Sphingomonadaceae stub_1_28 n" class="gt_row gt_right gt_striped">4</td></tr>
    <tr><th id="stub_1_29" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_29 genus" class="gt_row gt_left">g__Parapontixanthobacter</td>
<td headers="f__Sphingomonadaceae stub_1_29 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_30" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_30 genus" class="gt_row gt_left gt_striped">g__Parasphingopyxis</td>
<td headers="f__Sphingomonadaceae stub_1_30 n" class="gt_row gt_right gt_striped">7</td></tr>
    <tr><th id="stub_1_31" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_31 genus" class="gt_row gt_left">g__Parasphingorhabdus</td>
<td headers="f__Sphingomonadaceae stub_1_31 n" class="gt_row gt_right">18</td></tr>
    <tr><th id="stub_1_32" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_32 genus" class="gt_row gt_left gt_striped">g__Paraurantiacibacter</td>
<td headers="f__Sphingomonadaceae stub_1_32 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_33" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_33 genus" class="gt_row gt_left">g__Parerythrobacter</td>
<td headers="f__Sphingomonadaceae stub_1_33 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_34" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_34 genus" class="gt_row gt_left gt_striped">g__Pelagerythrobacter</td>
<td headers="f__Sphingomonadaceae stub_1_34 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_35" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_35 genus" class="gt_row gt_left">g__Polymorphobacter</td>
<td headers="f__Sphingomonadaceae stub_1_35 n" class="gt_row gt_right">9</td></tr>
    <tr><th id="stub_1_36" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_36 genus" class="gt_row gt_left gt_striped">g__Polymorphobacter_A</td>
<td headers="f__Sphingomonadaceae stub_1_36 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_37" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_37 genus" class="gt_row gt_left">g__Pontixanthobacter</td>
<td headers="f__Sphingomonadaceae stub_1_37 n" class="gt_row gt_right">6</td></tr>
    <tr><th id="stub_1_38" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_38 genus" class="gt_row gt_left gt_striped">g__Pseudopontixanthobacter</td>
<td headers="f__Sphingomonadaceae stub_1_38 n" class="gt_row gt_right gt_striped">2</td></tr>
    <tr><th id="stub_1_39" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_39 genus" class="gt_row gt_left">g__Pseudopontixanthobacter_A</td>
<td headers="f__Sphingomonadaceae stub_1_39 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_40" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_40 genus" class="gt_row gt_left gt_striped">g__QFOP01</td>
<td headers="f__Sphingomonadaceae stub_1_40 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_41" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_41 genus" class="gt_row gt_left">g__Qipengyuania</td>
<td headers="f__Sphingomonadaceae stub_1_41 n" class="gt_row gt_right">29</td></tr>
    <tr><th id="stub_1_42" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_42 genus" class="gt_row gt_left gt_striped">g__Rhizorhabdus</td>
<td headers="f__Sphingomonadaceae stub_1_42 n" class="gt_row gt_right gt_striped">14</td></tr>
    <tr><th id="stub_1_43" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_43 genus" class="gt_row gt_left">g__Rhizorhapis</td>
<td headers="f__Sphingomonadaceae stub_1_43 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_44" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_44 genus" class="gt_row gt_left gt_striped">g__SCN-67-18</td>
<td headers="f__Sphingomonadaceae stub_1_44 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_45" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_45 genus" class="gt_row gt_left">g__Sandaracinobacter</td>
<td headers="f__Sphingomonadaceae stub_1_45 n" class="gt_row gt_right">4</td></tr>
    <tr><th id="stub_1_46" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_46 genus" class="gt_row gt_left gt_striped">g__Sandarakinorhabdus</td>
<td headers="f__Sphingomonadaceae stub_1_46 n" class="gt_row gt_right gt_striped">7</td></tr>
    <tr><th id="stub_1_47" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_47 genus" class="gt_row gt_left">g__Sphingobium</td>
<td headers="f__Sphingomonadaceae stub_1_47 n" class="gt_row gt_right">77</td></tr>
    <tr><th id="stub_1_48" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_48 genus" class="gt_row gt_left gt_striped">g__Sphingobium_A</td>
<td headers="f__Sphingomonadaceae stub_1_48 n" class="gt_row gt_right gt_striped">2</td></tr>
    <tr><th id="stub_1_49" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_49 genus" class="gt_row gt_left">g__Sphingomicrobium</td>
<td headers="f__Sphingomonadaceae stub_1_49 n" class="gt_row gt_right">38</td></tr>
    <tr><th id="stub_1_50" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_50 genus" class="gt_row gt_left gt_striped">g__Sphingomonas</td>
<td headers="f__Sphingomonadaceae stub_1_50 n" class="gt_row gt_right gt_striped">205</td></tr>
    <tr><th id="stub_1_51" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_51 genus" class="gt_row gt_left">g__Sphingomonas_B</td>
<td headers="f__Sphingomonadaceae stub_1_51 n" class="gt_row gt_right">6</td></tr>
    <tr><th id="stub_1_52" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_52 genus" class="gt_row gt_left gt_striped">g__Sphingomonas_D</td>
<td headers="f__Sphingomonadaceae stub_1_52 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_53" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_53 genus" class="gt_row gt_left">g__Sphingomonas_E</td>
<td headers="f__Sphingomonadaceae stub_1_53 n" class="gt_row gt_right">3</td></tr>
    <tr><th id="stub_1_54" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_54 genus" class="gt_row gt_left gt_striped">g__Sphingomonas_G</td>
<td headers="f__Sphingomonadaceae stub_1_54 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_55" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_55 genus" class="gt_row gt_left">g__Sphingomonas_H</td>
<td headers="f__Sphingomonadaceae stub_1_55 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_56" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_56 genus" class="gt_row gt_left gt_striped">g__Sphingomonas_I</td>
<td headers="f__Sphingomonadaceae stub_1_56 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_57" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_57 genus" class="gt_row gt_left">g__Sphingomonas_K</td>
<td headers="f__Sphingomonadaceae stub_1_57 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_58" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_58 genus" class="gt_row gt_left gt_striped">g__Sphingomonas_L</td>
<td headers="f__Sphingomonadaceae stub_1_58 n" class="gt_row gt_right gt_striped">2</td></tr>
    <tr><th id="stub_1_59" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_59 genus" class="gt_row gt_left">g__Sphingomonas_M</td>
<td headers="f__Sphingomonadaceae stub_1_59 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_60" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_60 genus" class="gt_row gt_left gt_striped">g__Sphingomonas_N</td>
<td headers="f__Sphingomonadaceae stub_1_60 n" class="gt_row gt_right gt_striped">6</td></tr>
    <tr><th id="stub_1_61" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_61 genus" class="gt_row gt_left">g__Sphingopyxis</td>
<td headers="f__Sphingomonadaceae stub_1_61 n" class="gt_row gt_right">62</td></tr>
    <tr><th id="stub_1_62" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_62 genus" class="gt_row gt_left gt_striped">g__Sphingorhabdus_B</td>
<td headers="f__Sphingomonadaceae stub_1_62 n" class="gt_row gt_right gt_striped">25</td></tr>
    <tr><th id="stub_1_63" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_63 genus" class="gt_row gt_left">g__Sphingorhabdus_C</td>
<td headers="f__Sphingomonadaceae stub_1_63 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_64" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_64 genus" class="gt_row gt_left gt_striped">g__Sphingosinicella</td>
<td headers="f__Sphingomonadaceae stub_1_64 n" class="gt_row gt_right gt_striped">4</td></tr>
    <tr><th id="stub_1_65" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_65 genus" class="gt_row gt_left">g__Tardibacter</td>
<td headers="f__Sphingomonadaceae stub_1_65 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_66" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_66 genus" class="gt_row gt_left gt_striped">g__Thermaurantiacus</td>
<td headers="f__Sphingomonadaceae stub_1_66 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_67" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_67 genus" class="gt_row gt_left">g__Tsuneonella</td>
<td headers="f__Sphingomonadaceae stub_1_67 n" class="gt_row gt_right">10</td></tr>
    <tr><th id="stub_1_68" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_68 genus" class="gt_row gt_left gt_striped">g__UBA1936</td>
<td headers="f__Sphingomonadaceae stub_1_68 n" class="gt_row gt_right gt_striped">3</td></tr>
    <tr><th id="stub_1_69" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_69 genus" class="gt_row gt_left">g__UBA6174</td>
<td headers="f__Sphingomonadaceae stub_1_69 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_70" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_70 genus" class="gt_row gt_left gt_striped">g__XMGL2</td>
<td headers="f__Sphingomonadaceae stub_1_70 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_71" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_71 genus" class="gt_row gt_left">g__ZODW24</td>
<td headers="f__Sphingomonadaceae stub_1_71 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_72" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_72 genus" class="gt_row gt_left gt_striped">g__Zymomonas</td>
<td headers="f__Sphingomonadaceae stub_1_72 n" class="gt_row gt_right gt_striped">3</td></tr>
    <tr><th id="summary_stub_f__Sphingomonadaceae_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick gt_last_summary_row">Total</th>
<td headers="f__Sphingomonadaceae summary_stub_f__Sphingomonadaceae_1 genus" class="gt_row gt_left gt_summary_row gt_first_summary_row thick gt_last_summary_row">—</td>
<td headers="f__Sphingomonadaceae summary_stub_f__Sphingomonadaceae_1 n" class="gt_row gt_right gt_summary_row gt_first_summary_row thick gt_last_summary_row">887</td></tr>
  </tbody>
  
  
</table>
</div>
```

#### Family Microbacteriaceae


```{=html}
<div id="hrbtvmnocm" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hrbtvmnocm table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#hrbtvmnocm thead, #hrbtvmnocm tbody, #hrbtvmnocm tfoot, #hrbtvmnocm tr, #hrbtvmnocm td, #hrbtvmnocm th {
  border-style: none;
}

#hrbtvmnocm p {
  margin: 0;
  padding: 0;
}

#hrbtvmnocm .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 3px;
  border-top-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 3px;
  border-right-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 3px;
  border-bottom-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 3px;
  border-left-color: #D5D5D5;
}

#hrbtvmnocm .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#hrbtvmnocm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hrbtvmnocm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hrbtvmnocm .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hrbtvmnocm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#hrbtvmnocm .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hrbtvmnocm .gt_col_heading {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hrbtvmnocm .gt_column_spanner_outer {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hrbtvmnocm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hrbtvmnocm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hrbtvmnocm .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hrbtvmnocm .gt_spanner_row {
  border-bottom-style: hidden;
}

#hrbtvmnocm .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#hrbtvmnocm .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: middle;
}

#hrbtvmnocm .gt_from_md > :first-child {
  margin-top: 0;
}

#hrbtvmnocm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hrbtvmnocm .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D5D5D5;
  vertical-align: middle;
  overflow-x: hidden;
}

#hrbtvmnocm .gt_stub {
  color: #FFFFFF;
  background-color: #929292;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D5D5D5;
  padding-left: 5px;
  padding-right: 5px;
}

#hrbtvmnocm .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#hrbtvmnocm .gt_row_group_first td {
  border-top-width: 2px;
}

#hrbtvmnocm .gt_row_group_first th {
  border-top-width: 2px;
}

#hrbtvmnocm .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hrbtvmnocm .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}

#hrbtvmnocm .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#hrbtvmnocm .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#hrbtvmnocm .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hrbtvmnocm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}

#hrbtvmnocm .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}

#hrbtvmnocm .gt_striped {
  background-color: #F4F4F4;
}

#hrbtvmnocm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#hrbtvmnocm .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hrbtvmnocm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hrbtvmnocm .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hrbtvmnocm .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hrbtvmnocm .gt_left {
  text-align: left;
}

#hrbtvmnocm .gt_center {
  text-align: center;
}

#hrbtvmnocm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hrbtvmnocm .gt_font_normal {
  font-weight: normal;
}

#hrbtvmnocm .gt_font_bold {
  font-weight: bold;
}

#hrbtvmnocm .gt_font_italic {
  font-style: italic;
}

#hrbtvmnocm .gt_super {
  font-size: 65%;
}

#hrbtvmnocm .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#hrbtvmnocm .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#hrbtvmnocm .gt_indent_1 {
  text-indent: 5px;
}

#hrbtvmnocm .gt_indent_2 {
  text-indent: 10px;
}

#hrbtvmnocm .gt_indent_3 {
  text-indent: 15px;
}

#hrbtvmnocm .gt_indent_4 {
  text-indent: 20px;
}

#hrbtvmnocm .gt_indent_5 {
  text-indent: 25px;
}

#hrbtvmnocm .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#hrbtvmnocm div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_title gt_font_normal" style>Table 11 - count of genera in the family Microbacteriaceae</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style><span class='gt_from_md'>accessions as found in the .tree file outputted by gtdbtk analysis done on 2024-12-24</span></td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="a::stub"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="genus">Family and Genus</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="n">Number of Accessions</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="3" class="gt_group_heading" scope="colgroup" id="f__Microbacteriaceae">f__Microbacteriaceae</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_1 genus" class="gt_row gt_left">g__73-13</td>
<td headers="f__Microbacteriaceae stub_1_1 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_2 genus" class="gt_row gt_left gt_striped">g__Agreia</td>
<td headers="f__Microbacteriaceae stub_1_2 n" class="gt_row gt_right gt_striped">6</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_3 genus" class="gt_row gt_left">g__Agrococcus</td>
<td headers="f__Microbacteriaceae stub_1_3 n" class="gt_row gt_right">16</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_4 genus" class="gt_row gt_left gt_striped">g__Agromyces</td>
<td headers="f__Microbacteriaceae stub_1_4 n" class="gt_row gt_right gt_striped">41</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_5 genus" class="gt_row gt_left">g__Agromyces_B</td>
<td headers="f__Microbacteriaceae stub_1_5 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_6 genus" class="gt_row gt_left gt_striped">g__Alpinimonas</td>
<td headers="f__Microbacteriaceae stub_1_6 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_7" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_7 genus" class="gt_row gt_left">g__Amnibacterium</td>
<td headers="f__Microbacteriaceae stub_1_7 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_8 genus" class="gt_row gt_left gt_striped">g__Aquiluna</td>
<td headers="f__Microbacteriaceae stub_1_8 n" class="gt_row gt_right gt_striped">15</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_9 genus" class="gt_row gt_left">g__Aurantimicrobium</td>
<td headers="f__Microbacteriaceae stub_1_9 n" class="gt_row gt_right">3</td></tr>
    <tr><th id="stub_1_10" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_10 genus" class="gt_row gt_left gt_striped">g__CAIOLM01</td>
<td headers="f__Microbacteriaceae stub_1_10 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_11" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_11 genus" class="gt_row gt_left">g__Canibacter</td>
<td headers="f__Microbacteriaceae stub_1_11 n" class="gt_row gt_right">4</td></tr>
    <tr><th id="stub_1_12" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_12 genus" class="gt_row gt_left gt_striped">g__Chryseoglobus</td>
<td headers="f__Microbacteriaceae stub_1_12 n" class="gt_row gt_right gt_striped">8</td></tr>
    <tr><th id="stub_1_13" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_13 genus" class="gt_row gt_left">g__Clavibacter</td>
<td headers="f__Microbacteriaceae stub_1_13 n" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_14" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_14 genus" class="gt_row gt_left gt_striped">g__Cnuibacter</td>
<td headers="f__Microbacteriaceae stub_1_14 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_15" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_15 genus" class="gt_row gt_left">g__Compostimonas</td>
<td headers="f__Microbacteriaceae stub_1_15 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_16" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_16 genus" class="gt_row gt_left gt_striped">g__Conyzicola</td>
<td headers="f__Microbacteriaceae stub_1_16 n" class="gt_row gt_right gt_striped">3</td></tr>
    <tr><th id="stub_1_17" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_17 genus" class="gt_row gt_left">g__Cryobacterium</td>
<td headers="f__Microbacteriaceae stub_1_17 n" class="gt_row gt_right">43</td></tr>
    <tr><th id="stub_1_18" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_18 genus" class="gt_row gt_left gt_striped">g__Cryobacterium_C</td>
<td headers="f__Microbacteriaceae stub_1_18 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_19" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_19 genus" class="gt_row gt_left">g__Curtobacterium</td>
<td headers="f__Microbacteriaceae stub_1_19 n" class="gt_row gt_right">51</td></tr>
    <tr><th id="stub_1_20" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_20 genus" class="gt_row gt_left gt_striped">g__Cx-87</td>
<td headers="f__Microbacteriaceae stub_1_20 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_21" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_21 genus" class="gt_row gt_left">g__Diaminobutyricibacter</td>
<td headers="f__Microbacteriaceae stub_1_21 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_22" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_22 genus" class="gt_row gt_left gt_striped">g__Diaminobutyricimonas</td>
<td headers="f__Microbacteriaceae stub_1_22 n" class="gt_row gt_right gt_striped">2</td></tr>
    <tr><th id="stub_1_23" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_23 genus" class="gt_row gt_left">g__Frigoribacterium</td>
<td headers="f__Microbacteriaceae stub_1_23 n" class="gt_row gt_right">15</td></tr>
    <tr><th id="stub_1_24" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_24 genus" class="gt_row gt_left gt_striped">g__Frondihabitans</td>
<td headers="f__Microbacteriaceae stub_1_24 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_25" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_25 genus" class="gt_row gt_left">g__Galbitalea</td>
<td headers="f__Microbacteriaceae stub_1_25 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_26" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_26 genus" class="gt_row gt_left gt_striped">g__Glaciibacter</td>
<td headers="f__Microbacteriaceae stub_1_26 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_27" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_27 genus" class="gt_row gt_left">g__Glaciihabitans</td>
<td headers="f__Microbacteriaceae stub_1_27 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_28" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_28 genus" class="gt_row gt_left gt_striped">g__Gryllotalpicola</td>
<td headers="f__Microbacteriaceae stub_1_28 n" class="gt_row gt_right gt_striped">3</td></tr>
    <tr><th id="stub_1_29" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_29 genus" class="gt_row gt_left">g__Gulosibacter</td>
<td headers="f__Microbacteriaceae stub_1_29 n" class="gt_row gt_right">9</td></tr>
    <tr><th id="stub_1_30" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_30 genus" class="gt_row gt_left gt_striped">g__Herbiconiux</td>
<td headers="f__Microbacteriaceae stub_1_30 n" class="gt_row gt_right gt_striped">7</td></tr>
    <tr><th id="stub_1_31" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_31 genus" class="gt_row gt_left">g__Homoserinimonas</td>
<td headers="f__Microbacteriaceae stub_1_31 n" class="gt_row gt_right">4</td></tr>
    <tr><th id="stub_1_32" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_32 genus" class="gt_row gt_left gt_striped">g__Humibacter</td>
<td headers="f__Microbacteriaceae stub_1_32 n" class="gt_row gt_right gt_striped">4</td></tr>
    <tr><th id="stub_1_33" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_33 genus" class="gt_row gt_left">g__JAAFHU01</td>
<td headers="f__Microbacteriaceae stub_1_33 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_34" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_34 genus" class="gt_row gt_left gt_striped">g__JAFIQW01</td>
<td headers="f__Microbacteriaceae stub_1_34 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_35" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_35 genus" class="gt_row gt_left">g__Klugiella</td>
<td headers="f__Microbacteriaceae stub_1_35 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_36" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_36 genus" class="gt_row gt_left gt_striped">g__Labedella</td>
<td headers="f__Microbacteriaceae stub_1_36 n" class="gt_row gt_right gt_striped">4</td></tr>
    <tr><th id="stub_1_37" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_37 genus" class="gt_row gt_left">g__Lacisediminihabitans</td>
<td headers="f__Microbacteriaceae stub_1_37 n" class="gt_row gt_right">5</td></tr>
    <tr><th id="stub_1_38" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_38 genus" class="gt_row gt_left gt_striped">g__Leifsonia</td>
<td headers="f__Microbacteriaceae stub_1_38 n" class="gt_row gt_right gt_striped">19</td></tr>
    <tr><th id="stub_1_39" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_39 genus" class="gt_row gt_left">g__Leifsonia_A</td>
<td headers="f__Microbacteriaceae stub_1_39 n" class="gt_row gt_right">4</td></tr>
    <tr><th id="stub_1_40" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_40 genus" class="gt_row gt_left gt_striped">g__Leifsonia_B</td>
<td headers="f__Microbacteriaceae stub_1_40 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_41" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_41 genus" class="gt_row gt_left">g__Leucobacter</td>
<td headers="f__Microbacteriaceae stub_1_41 n" class="gt_row gt_right">43</td></tr>
    <tr><th id="stub_1_42" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_42 genus" class="gt_row gt_left gt_striped">g__Lumbricidophila</td>
<td headers="f__Microbacteriaceae stub_1_42 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_43" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_43 genus" class="gt_row gt_left">g__Lysinibacter</td>
<td headers="f__Microbacteriaceae stub_1_43 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_44" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_44 genus" class="gt_row gt_left gt_striped">g__MWH-TA3</td>
<td headers="f__Microbacteriaceae stub_1_44 n" class="gt_row gt_right gt_striped">7</td></tr>
    <tr><th id="stub_1_45" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_45 genus" class="gt_row gt_left">g__Marinisubtilis</td>
<td headers="f__Microbacteriaceae stub_1_45 n" class="gt_row gt_right">3</td></tr>
    <tr><th id="stub_1_46" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_46 genus" class="gt_row gt_left gt_striped">g__Marisediminicola</td>
<td headers="f__Microbacteriaceae stub_1_46 n" class="gt_row gt_right gt_striped">4</td></tr>
    <tr><th id="stub_1_47" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_47 genus" class="gt_row gt_left">g__Microbacterium</td>
<td headers="f__Microbacteriaceae stub_1_47 n" class="gt_row gt_right">254</td></tr>
    <tr><th id="stub_1_48" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_48 genus" class="gt_row gt_left gt_striped">g__Microbacterium_A</td>
<td headers="f__Microbacteriaceae stub_1_48 n" class="gt_row gt_right gt_striped">4</td></tr>
    <tr><th id="stub_1_49" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_49 genus" class="gt_row gt_left">g__Microcella</td>
<td headers="f__Microbacteriaceae stub_1_49 n" class="gt_row gt_right">3</td></tr>
    <tr><th id="stub_1_50" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_50 genus" class="gt_row gt_left gt_striped">g__Microterricola</td>
<td headers="f__Microbacteriaceae stub_1_50 n" class="gt_row gt_right gt_striped">7</td></tr>
    <tr><th id="stub_1_51" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_51 genus" class="gt_row gt_left">g__Mycetocola</td>
<td headers="f__Microbacteriaceae stub_1_51 n" class="gt_row gt_right">3</td></tr>
    <tr><th id="stub_1_52" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_52 genus" class="gt_row gt_left gt_striped">g__Mycetocola_A</td>
<td headers="f__Microbacteriaceae stub_1_52 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_53" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_53 genus" class="gt_row gt_left">g__Mycetocola_B</td>
<td headers="f__Microbacteriaceae stub_1_53 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_54" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_54 genus" class="gt_row gt_left gt_striped">g__NC76-1</td>
<td headers="f__Microbacteriaceae stub_1_54 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_55" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_55 genus" class="gt_row gt_left">g__Naasia</td>
<td headers="f__Microbacteriaceae stub_1_55 n" class="gt_row gt_right">4</td></tr>
    <tr><th id="stub_1_56" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_56 genus" class="gt_row gt_left gt_striped">g__OACT-916</td>
<td headers="f__Microbacteriaceae stub_1_56 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_57" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_57 genus" class="gt_row gt_left">g__Okibacterium</td>
<td headers="f__Microbacteriaceae stub_1_57 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_58" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_58 genus" class="gt_row gt_left gt_striped">g__Planctomonas</td>
<td headers="f__Microbacteriaceae stub_1_58 n" class="gt_row gt_right gt_striped">2</td></tr>
    <tr><th id="stub_1_59" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_59 genus" class="gt_row gt_left">g__Plantibacter</td>
<td headers="f__Microbacteriaceae stub_1_59 n" class="gt_row gt_right">6</td></tr>
    <tr><th id="stub_1_60" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_60 genus" class="gt_row gt_left gt_striped">g__Pontimonas</td>
<td headers="f__Microbacteriaceae stub_1_60 n" class="gt_row gt_right gt_striped">10</td></tr>
    <tr><th id="stub_1_61" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_61 genus" class="gt_row gt_left">g__Protaetiibacter</td>
<td headers="f__Microbacteriaceae stub_1_61 n" class="gt_row gt_right">9</td></tr>
    <tr><th id="stub_1_62" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_62 genus" class="gt_row gt_left gt_striped">g__Pseudoclavibacter</td>
<td headers="f__Microbacteriaceae stub_1_62 n" class="gt_row gt_right gt_striped">9</td></tr>
    <tr><th id="stub_1_63" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_63 genus" class="gt_row gt_left">g__Pseudoclavibacter_A</td>
<td headers="f__Microbacteriaceae stub_1_63 n" class="gt_row gt_right">3</td></tr>
    <tr><th id="stub_1_64" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_64 genus" class="gt_row gt_left gt_striped">g__Pseudolysinimonas</td>
<td headers="f__Microbacteriaceae stub_1_64 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_65" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_65 genus" class="gt_row gt_left">g__RFQD01</td>
<td headers="f__Microbacteriaceae stub_1_65 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_66" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_66 genus" class="gt_row gt_left gt_striped">g__Rathayibacter</td>
<td headers="f__Microbacteriaceae stub_1_66 n" class="gt_row gt_right gt_striped">22</td></tr>
    <tr><th id="stub_1_67" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_67 genus" class="gt_row gt_left">g__Rhodoglobus</td>
<td headers="f__Microbacteriaceae stub_1_67 n" class="gt_row gt_right">15</td></tr>
    <tr><th id="stub_1_68" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_68 genus" class="gt_row gt_left gt_striped">g__Rhodoluna</td>
<td headers="f__Microbacteriaceae stub_1_68 n" class="gt_row gt_right gt_striped">35</td></tr>
    <tr><th id="stub_1_69" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_69 genus" class="gt_row gt_left">g__Root112D2</td>
<td headers="f__Microbacteriaceae stub_1_69 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_70" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_70 genus" class="gt_row gt_left gt_striped">g__SCRE01</td>
<td headers="f__Microbacteriaceae stub_1_70 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_71" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_71 genus" class="gt_row gt_left">g__Schumannella</td>
<td headers="f__Microbacteriaceae stub_1_71 n" class="gt_row gt_right">4</td></tr>
    <tr><th id="stub_1_72" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_72 genus" class="gt_row gt_left gt_striped">g__Subtercola</td>
<td headers="f__Microbacteriaceae stub_1_72 n" class="gt_row gt_right gt_striped">9</td></tr>
    <tr><th id="stub_1_73" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_73 genus" class="gt_row gt_left">g__Terrimesophilobacter</td>
<td headers="f__Microbacteriaceae stub_1_73 n" class="gt_row gt_right">3</td></tr>
    <tr><th id="stub_1_74" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_74 genus" class="gt_row gt_left gt_striped">g__Tropheryma</td>
<td headers="f__Microbacteriaceae stub_1_74 n" class="gt_row gt_right gt_striped">1</td></tr>
    <tr><th id="stub_1_75" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_75 genus" class="gt_row gt_left">g__UBA3913</td>
<td headers="f__Microbacteriaceae stub_1_75 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_76" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_76 genus" class="gt_row gt_left gt_striped">g__UBA963</td>
<td headers="f__Microbacteriaceae stub_1_76 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_77" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_77 genus" class="gt_row gt_left">g__WSTA01</td>
<td headers="f__Microbacteriaceae stub_1_77 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="stub_1_78" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_78 genus" class="gt_row gt_left gt_striped">g__Yonghaparkia</td>
<td headers="f__Microbacteriaceae stub_1_78 n" class="gt_row gt_right gt_striped">5</td></tr>
    <tr><th id="stub_1_79" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_79 genus" class="gt_row gt_left">g__ZJ450</td>
<td headers="f__Microbacteriaceae stub_1_79 n" class="gt_row gt_right">2</td></tr>
    <tr><th id="summary_stub_f__Microbacteriaceae_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick gt_last_summary_row">Total</th>
<td headers="f__Microbacteriaceae summary_stub_f__Microbacteriaceae_1 genus" class="gt_row gt_left gt_summary_row gt_first_summary_row thick gt_last_summary_row">—</td>
<td headers="f__Microbacteriaceae summary_stub_f__Microbacteriaceae_1 n" class="gt_row gt_right gt_summary_row gt_first_summary_row thick gt_last_summary_row">806</td></tr>
  </tbody>
  
  
</table>
</div>
```

#### Our Genera


```{=html}
<div id="hdtetspnay" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hdtetspnay table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#hdtetspnay thead, #hdtetspnay tbody, #hdtetspnay tfoot, #hdtetspnay tr, #hdtetspnay td, #hdtetspnay th {
  border-style: none;
}

#hdtetspnay p {
  margin: 0;
  padding: 0;
}

#hdtetspnay .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 3px;
  border-top-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 3px;
  border-right-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 3px;
  border-bottom-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 3px;
  border-left-color: #D5D5D5;
}

#hdtetspnay .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#hdtetspnay .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hdtetspnay .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hdtetspnay .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hdtetspnay .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#hdtetspnay .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hdtetspnay .gt_col_heading {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hdtetspnay .gt_column_spanner_outer {
  color: #FFFFFF;
  background-color: #004D80;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hdtetspnay .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hdtetspnay .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hdtetspnay .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hdtetspnay .gt_spanner_row {
  border-bottom-style: hidden;
}

#hdtetspnay .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#hdtetspnay .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
  vertical-align: middle;
}

#hdtetspnay .gt_from_md > :first-child {
  margin-top: 0;
}

#hdtetspnay .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hdtetspnay .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D5D5D5;
  border-left-style: solid;
  border-left-width: 1px;
  border-left-color: #D5D5D5;
  border-right-style: solid;
  border-right-width: 1px;
  border-right-color: #D5D5D5;
  vertical-align: middle;
  overflow-x: hidden;
}

#hdtetspnay .gt_stub {
  color: #FFFFFF;
  background-color: #929292;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D5D5D5;
  padding-left: 5px;
  padding-right: 5px;
}

#hdtetspnay .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#hdtetspnay .gt_row_group_first td {
  border-top-width: 2px;
}

#hdtetspnay .gt_row_group_first th {
  border-top-width: 2px;
}

#hdtetspnay .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hdtetspnay .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}

#hdtetspnay .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#hdtetspnay .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#hdtetspnay .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hdtetspnay .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}

#hdtetspnay .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}

#hdtetspnay .gt_striped {
  background-color: #F4F4F4;
}

#hdtetspnay .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#hdtetspnay .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hdtetspnay .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hdtetspnay .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hdtetspnay .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hdtetspnay .gt_left {
  text-align: left;
}

#hdtetspnay .gt_center {
  text-align: center;
}

#hdtetspnay .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hdtetspnay .gt_font_normal {
  font-weight: normal;
}

#hdtetspnay .gt_font_bold {
  font-weight: bold;
}

#hdtetspnay .gt_font_italic {
  font-style: italic;
}

#hdtetspnay .gt_super {
  font-size: 65%;
}

#hdtetspnay .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#hdtetspnay .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#hdtetspnay .gt_indent_1 {
  text-indent: 5px;
}

#hdtetspnay .gt_indent_2 {
  text-indent: 10px;
}

#hdtetspnay .gt_indent_3 {
  text-indent: 15px;
}

#hdtetspnay .gt_indent_4 {
  text-indent: 20px;
}

#hdtetspnay .gt_indent_5 {
  text-indent: 25px;
}

#hdtetspnay .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#hdtetspnay div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_title gt_font_normal" style>Table 12 - count of genera from accessions produced at Bangor</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style><span class='gt_from_md'>accessions as found in the .tree file outputted by gtdbtk analysis done on 2024-12-24</span></td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="a::stub"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="genus">Genus</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="n">Number of Accessions</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><th id="stub_1_1" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="stub_1_1 genus" class="gt_row gt_left">g__</td>
<td headers="stub_1_1 n" class="gt_row gt_right">1</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="stub_1_2 genus" class="gt_row gt_left gt_striped">g__Brachybacterium</td>
<td headers="stub_1_2 n" class="gt_row gt_right gt_striped">32</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="stub_1_3 genus" class="gt_row gt_left">g__Brevibacterium</td>
<td headers="stub_1_3 n" class="gt_row gt_right">43</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="stub_1_4 genus" class="gt_row gt_left gt_striped">g__Microbacterium</td>
<td headers="stub_1_4 n" class="gt_row gt_right gt_striped">254</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="stub_1_5 genus" class="gt_row gt_left">g__Pantoea</td>
<td headers="stub_1_5 n" class="gt_row gt_right">52</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="stub_1_6 genus" class="gt_row gt_left gt_striped">g__Sphingomonas</td>
<td headers="stub_1_6 n" class="gt_row gt_right gt_striped">205</td></tr>
    <tr><th id="grand_summary_stub_1" scope="row" class="gt_row gt_left gt_stub gt_grand_summary_row gt_first_grand_summary_row gt_last_summary_row">Total</th>
<td headers="grand_summary_stub_1 genus" class="gt_row gt_left gt_grand_summary_row gt_first_grand_summary_row gt_last_summary_row">—</td>
<td headers="grand_summary_stub_1 n" class="gt_row gt_right gt_grand_summary_row gt_first_grand_summary_row gt_last_summary_row">587</td></tr>
  </tbody>
  
  
</table>
</div>
```

###  {.unnumbered}

There are 887 accession in sphingomonadaceae, 806 in microbacteriaceae and 587 in just our genera, however, there is overlap inside the genera Sphingomonas and Microbacterium, assuming those values are held inside the respective numbers before, that comes out to 128 "unique" samples from that group. This however contains the sample that could not even be given a family, 1Dt100h, so discounting this odd sample i cannot even logically analyse 127 accessions. This brings me to the total of 1,820 accessions that need to be processed. The fastest i have been able to process samples on eggnog is roughly 1 hour and 10 minutes per sample. Multiplying 1,820 by 1.1667 = 2,123.4 hours. This means that if i could do them constantly, it would take over 88 days, so 2 months to just run the samples through eggnog. Through testing i have already made a brief start, with maybe 20 done.

Right, as of 11:12 today (17th) i have managed to do a successful run using this file that gave me the output in a nice 25 minutes. I added some extra fields that i saw both on the online eggnogmapper and from a stack-overflow from someone doing a similar thing and something worked. using this new number, 1,820 x 0.4167 = 758.4 hours = 31.6 days so even now i'm down to just over a month, good stuff. This one used 10 cpus, the online one used 20, but i didnt want to overdo it with hawk, now im thinking can i get that number to half again by doubling the cpus?

## Conclusion
This number of hours is not one i can logistically work with, maybe Aaron would be fine with me taking that time, but i feel i can do it faster. I am still working on improving the script to cut down on time taken, but hawk is being a pain in that regard, i have also starting thinking of alternatives or ways to cut down the list. My front-running idea is to take samples from only genera with more than 10, or 30 or some other arbitrary high number of samples. This would cut out all groups with only 1-4 accessions in them which i dont think are useful to this analysis anyway as an average cannot be calculated, it would also make the heatmaps much more legible, so i might run the numbers on what cutting down the sample size would look like. It may however, be better to group all those small genera into an "other" column to make the dataset as big as possible, but that doesnt solve my predicament.

::: {style="background-color:yellow;"}
📌 ?: TODO: 
[eggnog-mapper on hawk is slow, possibly too slow to scale to where we need it to be. alternatives: 
> what scale are we looking at - 1693 samples for the family comparison
> could limit to genera with more than 30 samples
> screenscrape-method
> enlist more manpower to do online(if we have to do on web)]
:::
::: {style="background-color:yellow;"}
📌 ?: TODO: trees and formatting
:::

# A cautionary tale (2025-01-24 11:48)
So for the past 2 weeks while i was doing exams i decided i didnt want to fully stop this project, but i didnt have enough time to do stuff and properly fill the notebook, so i decided to leave myself placeholders in multiple square brackets to make it obvious when i came back later, i can't replicate this here. For some unknown reason doing too many square brackets breaks the visual editor and busts the ability to knit. Anyway, because of that i haveant been able to knit all this time and have just lost the whole morning to trying to fix this, all over some square brackets... the shame i feel from this is immeasurable. This really does prove that there is **always** time for proper note taking.
