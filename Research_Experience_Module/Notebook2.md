---
title: "ENS-2002 Scientific Notebook MK2 number 2"
author: "Tobias Nunn"
date: "2025-01-13"
output: 
  html_document: 
    toc: true
    toc_depth: 1
    keep_md: true
editor_options: 
  markdown: 
    wrap: 72
---

```{=html}
<style>
    body .main-container {
        max-width: 1200px;
    }
</style>
```



# EggNog-Mapper initial test analyses (2025-01-10 to 2025-01-19)

## Introduction

Aaron emailed me back with advice on a way to make eggNog-mapper/2.1.12
on hawk work. As i am revising for an exam i can't spend too long on
this. p.s. i think i did pretty good on the exam. This section is
somewhat of a proof of concept just so i can understand and play with
the base commands for eggnogmapepr and try to get it running quickly,
and all the trials that entails. Hawk is still running slow, so while
those jobs from the previous section are running, i figured i would like
to do something extra to fill time. I wanted to see just how many
samples we are going to need to pull down and process for this and get a
rough time estimate for that, as well as the API stuff to pull the files
down as that is by far the easy bit

## Methods

From the 10th to the 12th i tried running a preliminary [test
script](https://github.com/tobiasnunn/tnunn_research/blob/a962833b3ec1b2c7420fef155b526f2b330d644c/00_scripts/newnogtest.sh)
that I made earlier in december 2024, i may not have written about it as
i didnt get anywhere at that time. This process was also hindered by
hawk being very encumbered in the new year meaning it takes a good half
day for any results to appear. On the 11th i managed to get a successful
result with the .xlsx file i need for the heatmaps for accession 3Dt1c,
found here in a zip file to save on space:

02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs

Today(the 12th) i set off 3 jobs each containing 3 accessions to
hopefully get the results of the remaining 9. If there are no
complications i will then be in a place where i can obtain the .fastas
for the online comparison accessions and then run them through
eggNog-mapper. It should be noted that i used the same list of
parameters i found on the web version of hawk for this.

![Figure 1 - Screenshot of parameters used in early eggnog runs on
hawk](04_images/eggnogparameters.png)

I had some marginal success, the second set of three finished in over 3
hours, the other 2 sets are still going strong after 8, so ill let them
time out over night and see what i have, maybe they will complete, i did
give them 12 hours. One of the remaining two finished just before the
time limit, the other timed out on sample 1Dt100h, proving to be a
difficult sample, this means i have 8 of 10, with the other missing
being 1Dt1h(alphabetically next).

I then discovered the command `dbmem` which could help to speed up the
process. I tested with [this file called
"anothergo.sh"](https://github.com/tobiasnunn/tnunn_research/blob/a962833b3ec1b2c7420fef155b526f2b330d644c/00_scripts/anothergo.sh).
The version linked to is not the file at that point, as i am doing the
linking here retroactively. This was set to run over night from roughly
9 30 pm on the 12th to 3 30 am on the 13th, totalling 6 hours for 5
files, not great. I then experimented with taking out some of the
arguments
`--evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20`.
This did not significantly increase time and likely hindered the quality
of the sample, so that was a dead end. Tomorrow(14th) i will have a look
at recreating run 1 with `dbmem` switched on. Around this time i also
tried to run two scripts in parallel, same content but different source
fastas, being another old version of "anothergo.sh" and
"anothergoparallel.sh". This was not successful as slurm scheduled them
sequentially. Today(19th), i changed some criteria around so now there
are 25 cpus per task, however, i believe i had already been doing this
by accident in the previous runs i did. There are two files, one being
the up-to-date version of "anothergo.sh" and one called
[Brachyscript.sh](https://github.com/tobiasnunn/tnunn_research/blob/a962833b3ec1b2c7420fef155b526f2b330d644c/00_scripts/brachy_script.sh)
which did multiple files in sequence but from the same script. I believe
these were not testing any parameters and were just attempts at
preliminary downloads to guage how long it might take. Speed has not
picked up considerably, so i may have reached the limits of how fast i
can make this and thus, it might be time to email Aaron to see what he
thinks. He emailed me back with some ideas about how i could use python
scripts to loop and that could make slurm do them in parallel.

I started this by making tables based along the sets of samples i am
going to need off of the ncbi website. I identified 3 groups of
samples: 1. all the genera in the family sphingomonadaceae / 2. all the
genera in the family Microbacteriaceae / 3. all the genera containing
our flye_asm samples This fits with the specification of work i was
given. Being 2 analyses, 1 for comparing just our genera and another
comparing genera in families we have multiple samples in. As of now i am
yet to do the API call. (still the 17th) I decided to run some more
tests to try cut the time down by adding some more commands to my
anothergo.sh script. I was having trouble with creating the slurm
scripts on hawk, it was a lot of typing complex strings, so i made
another script maker to automate that, which will be much more
convenient when working at scale, here

## Results

Run one had mixed results, 3 sets of 3 ran in parallel, set 1 completed
in 3 and a half hours, good. set 2 took 8 and a half hours, bad, set 3
timed out, very bad. so dont have the outputs needed for 1Dt100h or
1Dt1h. Run 2 was more successful, with 5 solid looking outputs in 6
hours. Run 3 did not improve on that time despite the extra parameters
being cut. As mentioned above, i managed to use `dbmem` and more
optimised cpu and memory usage using the `seff` command. This helped get
the average time to do a file down to roughly 27 minutes. After emailing
Aaron he agreed that the list of accessions should be cut down to remove
groups with low sample counts, i decided to cut at the number 30, so
groups with 29 or below are cut, as seen in these tables:



### All tables {.tabset .tabset-pills}

#### Family Sphingomonadaceae


```{=html}
<div id="dtrmdoyuis" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dtrmdoyuis table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#dtrmdoyuis thead, #dtrmdoyuis tbody, #dtrmdoyuis tfoot, #dtrmdoyuis tr, #dtrmdoyuis td, #dtrmdoyuis th {
  border-style: none;
}

#dtrmdoyuis p {
  margin: 0;
  padding: 0;
}

#dtrmdoyuis .gt_table {
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

#dtrmdoyuis .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#dtrmdoyuis .gt_title {
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

#dtrmdoyuis .gt_subtitle {
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

#dtrmdoyuis .gt_heading {
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

#dtrmdoyuis .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#dtrmdoyuis .gt_col_headings {
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

#dtrmdoyuis .gt_col_heading {
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

#dtrmdoyuis .gt_column_spanner_outer {
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

#dtrmdoyuis .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dtrmdoyuis .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dtrmdoyuis .gt_column_spanner {
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

#dtrmdoyuis .gt_spanner_row {
  border-bottom-style: hidden;
}

#dtrmdoyuis .gt_group_heading {
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

#dtrmdoyuis .gt_empty_group_heading {
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

#dtrmdoyuis .gt_from_md > :first-child {
  margin-top: 0;
}

#dtrmdoyuis .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dtrmdoyuis .gt_row {
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

#dtrmdoyuis .gt_stub {
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

#dtrmdoyuis .gt_stub_row_group {
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

#dtrmdoyuis .gt_row_group_first td {
  border-top-width: 2px;
}

#dtrmdoyuis .gt_row_group_first th {
  border-top-width: 2px;
}

#dtrmdoyuis .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dtrmdoyuis .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}

#dtrmdoyuis .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#dtrmdoyuis .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#dtrmdoyuis .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dtrmdoyuis .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}

#dtrmdoyuis .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}

#dtrmdoyuis .gt_striped {
  background-color: #F4F4F4;
}

#dtrmdoyuis .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#dtrmdoyuis .gt_footnotes {
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

#dtrmdoyuis .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dtrmdoyuis .gt_sourcenotes {
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

#dtrmdoyuis .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dtrmdoyuis .gt_left {
  text-align: left;
}

#dtrmdoyuis .gt_center {
  text-align: center;
}

#dtrmdoyuis .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dtrmdoyuis .gt_font_normal {
  font-weight: normal;
}

#dtrmdoyuis .gt_font_bold {
  font-weight: bold;
}

#dtrmdoyuis .gt_font_italic {
  font-style: italic;
}

#dtrmdoyuis .gt_super {
  font-size: 65%;
}

#dtrmdoyuis .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#dtrmdoyuis .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#dtrmdoyuis .gt_indent_1 {
  text-indent: 5px;
}

#dtrmdoyuis .gt_indent_2 {
  text-indent: 10px;
}

#dtrmdoyuis .gt_indent_3 {
  text-indent: 15px;
}

#dtrmdoyuis .gt_indent_4 {
  text-indent: 20px;
}

#dtrmdoyuis .gt_indent_5 {
  text-indent: 25px;
}

#dtrmdoyuis .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#dtrmdoyuis div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_title gt_font_normal" style>Table 1 - count of genera in the family Sphingomonadaceae</td>
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
<td headers="f__Sphingomonadaceae stub_1_1 genus" class="gt_row gt_left">g__Erythrobacter</td>
<td headers="f__Sphingomonadaceae stub_1_1 n" class="gt_row gt_right">66</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_2 genus" class="gt_row gt_left gt_striped">g__Novosphingobium</td>
<td headers="f__Sphingomonadaceae stub_1_2 n" class="gt_row gt_right gt_striped">115</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_3 genus" class="gt_row gt_left">g__Sphingobium</td>
<td headers="f__Sphingomonadaceae stub_1_3 n" class="gt_row gt_right">77</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_4 genus" class="gt_row gt_left gt_striped">g__Sphingomicrobium</td>
<td headers="f__Sphingomonadaceae stub_1_4 n" class="gt_row gt_right gt_striped">38</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_5 genus" class="gt_row gt_left">g__Sphingomonas</td>
<td headers="f__Sphingomonadaceae stub_1_5 n" class="gt_row gt_right">205</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Sphingomonadaceae stub_1_6 genus" class="gt_row gt_left gt_striped">g__Sphingopyxis</td>
<td headers="f__Sphingomonadaceae stub_1_6 n" class="gt_row gt_right gt_striped">62</td></tr>
    <tr><th id="summary_stub_f__Sphingomonadaceae_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick gt_last_summary_row">Total</th>
<td headers="f__Sphingomonadaceae summary_stub_f__Sphingomonadaceae_1 genus" class="gt_row gt_left gt_summary_row gt_first_summary_row thick gt_last_summary_row">—</td>
<td headers="f__Sphingomonadaceae summary_stub_f__Sphingomonadaceae_1 n" class="gt_row gt_right gt_summary_row gt_first_summary_row thick gt_last_summary_row">563</td></tr>
  </tbody>
  
  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="3"> This is a subset of the full list, filtered to those genera with more than 29 accessions.</td>
    </tr>
  </tfoot>
</table>
</div>
```

#### Family Microbacteriaceae


```{=html}
<div id="udpxfuiszx" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#udpxfuiszx table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#udpxfuiszx thead, #udpxfuiszx tbody, #udpxfuiszx tfoot, #udpxfuiszx tr, #udpxfuiszx td, #udpxfuiszx th {
  border-style: none;
}

#udpxfuiszx p {
  margin: 0;
  padding: 0;
}

#udpxfuiszx .gt_table {
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

#udpxfuiszx .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#udpxfuiszx .gt_title {
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

#udpxfuiszx .gt_subtitle {
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

#udpxfuiszx .gt_heading {
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

#udpxfuiszx .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#udpxfuiszx .gt_col_headings {
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

#udpxfuiszx .gt_col_heading {
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

#udpxfuiszx .gt_column_spanner_outer {
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

#udpxfuiszx .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#udpxfuiszx .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#udpxfuiszx .gt_column_spanner {
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

#udpxfuiszx .gt_spanner_row {
  border-bottom-style: hidden;
}

#udpxfuiszx .gt_group_heading {
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

#udpxfuiszx .gt_empty_group_heading {
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

#udpxfuiszx .gt_from_md > :first-child {
  margin-top: 0;
}

#udpxfuiszx .gt_from_md > :last-child {
  margin-bottom: 0;
}

#udpxfuiszx .gt_row {
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

#udpxfuiszx .gt_stub {
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

#udpxfuiszx .gt_stub_row_group {
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

#udpxfuiszx .gt_row_group_first td {
  border-top-width: 2px;
}

#udpxfuiszx .gt_row_group_first th {
  border-top-width: 2px;
}

#udpxfuiszx .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#udpxfuiszx .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}

#udpxfuiszx .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#udpxfuiszx .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#udpxfuiszx .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#udpxfuiszx .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}

#udpxfuiszx .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}

#udpxfuiszx .gt_striped {
  background-color: #F4F4F4;
}

#udpxfuiszx .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#udpxfuiszx .gt_footnotes {
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

#udpxfuiszx .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#udpxfuiszx .gt_sourcenotes {
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

#udpxfuiszx .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#udpxfuiszx .gt_left {
  text-align: left;
}

#udpxfuiszx .gt_center {
  text-align: center;
}

#udpxfuiszx .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#udpxfuiszx .gt_font_normal {
  font-weight: normal;
}

#udpxfuiszx .gt_font_bold {
  font-weight: bold;
}

#udpxfuiszx .gt_font_italic {
  font-style: italic;
}

#udpxfuiszx .gt_super {
  font-size: 65%;
}

#udpxfuiszx .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#udpxfuiszx .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#udpxfuiszx .gt_indent_1 {
  text-indent: 5px;
}

#udpxfuiszx .gt_indent_2 {
  text-indent: 10px;
}

#udpxfuiszx .gt_indent_3 {
  text-indent: 15px;
}

#udpxfuiszx .gt_indent_4 {
  text-indent: 20px;
}

#udpxfuiszx .gt_indent_5 {
  text-indent: 25px;
}

#udpxfuiszx .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#udpxfuiszx div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_title gt_font_normal" style>Table 2 - count of genera in the family Microbacteriaceae</td>
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
<td headers="f__Microbacteriaceae stub_1_1 genus" class="gt_row gt_left">g__Agromyces</td>
<td headers="f__Microbacteriaceae stub_1_1 n" class="gt_row gt_right">41</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_2 genus" class="gt_row gt_left gt_striped">g__Cryobacterium</td>
<td headers="f__Microbacteriaceae stub_1_2 n" class="gt_row gt_right gt_striped">43</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_3 genus" class="gt_row gt_left">g__Curtobacterium</td>
<td headers="f__Microbacteriaceae stub_1_3 n" class="gt_row gt_right">51</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_4 genus" class="gt_row gt_left gt_striped">g__Leucobacter</td>
<td headers="f__Microbacteriaceae stub_1_4 n" class="gt_row gt_right gt_striped">43</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_5 genus" class="gt_row gt_left">g__Microbacterium</td>
<td headers="f__Microbacteriaceae stub_1_5 n" class="gt_row gt_right">254</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_left gt_stub"></th>
<td headers="f__Microbacteriaceae stub_1_6 genus" class="gt_row gt_left gt_striped">g__Rhodoluna</td>
<td headers="f__Microbacteriaceae stub_1_6 n" class="gt_row gt_right gt_striped">35</td></tr>
    <tr><th id="summary_stub_f__Microbacteriaceae_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick gt_last_summary_row">Total</th>
<td headers="f__Microbacteriaceae summary_stub_f__Microbacteriaceae_1 genus" class="gt_row gt_left gt_summary_row gt_first_summary_row thick gt_last_summary_row">—</td>
<td headers="f__Microbacteriaceae summary_stub_f__Microbacteriaceae_1 n" class="gt_row gt_right gt_summary_row gt_first_summary_row thick gt_last_summary_row">467</td></tr>
  </tbody>
  
  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="3"> This is a subset of the full list, filtered to those genera with more than 29 accessions.</td>
    </tr>
  </tfoot>
</table>
</div>
```

#### Our Genera


```{=html}
<div id="swlbbwvkun" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#swlbbwvkun table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#swlbbwvkun thead, #swlbbwvkun tbody, #swlbbwvkun tfoot, #swlbbwvkun tr, #swlbbwvkun td, #swlbbwvkun th {
  border-style: none;
}

#swlbbwvkun p {
  margin: 0;
  padding: 0;
}

#swlbbwvkun .gt_table {
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

#swlbbwvkun .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#swlbbwvkun .gt_title {
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

#swlbbwvkun .gt_subtitle {
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

#swlbbwvkun .gt_heading {
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

#swlbbwvkun .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#swlbbwvkun .gt_col_headings {
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

#swlbbwvkun .gt_col_heading {
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

#swlbbwvkun .gt_column_spanner_outer {
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

#swlbbwvkun .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#swlbbwvkun .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#swlbbwvkun .gt_column_spanner {
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

#swlbbwvkun .gt_spanner_row {
  border-bottom-style: hidden;
}

#swlbbwvkun .gt_group_heading {
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

#swlbbwvkun .gt_empty_group_heading {
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

#swlbbwvkun .gt_from_md > :first-child {
  margin-top: 0;
}

#swlbbwvkun .gt_from_md > :last-child {
  margin-bottom: 0;
}

#swlbbwvkun .gt_row {
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

#swlbbwvkun .gt_stub {
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

#swlbbwvkun .gt_stub_row_group {
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

#swlbbwvkun .gt_row_group_first td {
  border-top-width: 2px;
}

#swlbbwvkun .gt_row_group_first th {
  border-top-width: 2px;
}

#swlbbwvkun .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#swlbbwvkun .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}

#swlbbwvkun .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#swlbbwvkun .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#swlbbwvkun .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#swlbbwvkun .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}

#swlbbwvkun .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}

#swlbbwvkun .gt_striped {
  background-color: #F4F4F4;
}

#swlbbwvkun .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#swlbbwvkun .gt_footnotes {
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

#swlbbwvkun .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#swlbbwvkun .gt_sourcenotes {
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

#swlbbwvkun .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#swlbbwvkun .gt_left {
  text-align: left;
}

#swlbbwvkun .gt_center {
  text-align: center;
}

#swlbbwvkun .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#swlbbwvkun .gt_font_normal {
  font-weight: normal;
}

#swlbbwvkun .gt_font_bold {
  font-weight: bold;
}

#swlbbwvkun .gt_font_italic {
  font-style: italic;
}

#swlbbwvkun .gt_super {
  font-size: 65%;
}

#swlbbwvkun .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#swlbbwvkun .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#swlbbwvkun .gt_indent_1 {
  text-indent: 5px;
}

#swlbbwvkun .gt_indent_2 {
  text-indent: 10px;
}

#swlbbwvkun .gt_indent_3 {
  text-indent: 15px;
}

#swlbbwvkun .gt_indent_4 {
  text-indent: 20px;
}

#swlbbwvkun .gt_indent_5 {
  text-indent: 25px;
}

#swlbbwvkun .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#swlbbwvkun div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_title gt_font_normal" style>Table 3 - count of genera from accessions produced at Bangor</td>
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

There are 887 accession in sphingomonadaceae, 806 in microbacteriaceae
and 587 in just our genera, however, there is overlap inside the genera
Sphingomonas and Microbacterium, assuming those values are held inside
the respective numbers before, that comes out to 128 "unique" samples
from that group. This however contains the sample that could not even be
given a family, 1Dt100h, so discounting this odd sample i cannot even
logically analyse 127 accessions. This brings me to the total of 1,820
accessions that need to be processed. The fastest i have been able to
process samples on eggnog is roughly 1 hour and 10 minutes per sample.
Multiplying 1,820 by 1.1667 = 2,123.4 hours. This means that if i could
do them constantly, it would take over 88 days, so 2 months to just run
the samples through eggnog. Through testing i have already made a brief
start, with maybe 20 done.

Right, as of 11:12 today (17th) i have managed to do a successful run
using this file that gave me the output in a nice 25 minutes. I added
some extra fields that i saw both on the online eggnogmapper and from a
stack-overflow from someone doing a similar thing and something worked.
using this new number, 1,820 x 0.4167 = 758.4 hours = 31.6 days so even
now i'm down to just over a month, good stuff. This one used 10 cpus,
the online one used 20, but i didnt want to overdo it with hawk, now im
thinking can i get that number to half again by doubling the cpus?

As of the 24th Aaron agrees with my assessment to cut down on the number
of samples, this leaves me with 1158 samples to run, at an average of 27
minutes, this would take 21.7 days, however, this would speed up
dramatically if i can get his loops working so parallel stuff can
happen.

## Conclusion

It could have been overcrowding on hawk, however it appears that running
multiple sets in parallel adversely affects the result, however, i have
not tested this with `dbmem` on. The large problem is the volume of
samples required, the desired output is 3 heatmaps comparing KO
pathways: - Comparing genera inside sphingomonadaceae - Comparing genera
inside Microbacteriaceae - Comparing the genera containing just our
samples. This number of hours is not one i can logistically work with,
maybe Aaron would be fine with me taking that time, but i feel i can do
it faster. I am still working on improving the script to cut down on
time taken, but hawk is being a pain in that regard, i have also
starting thinking of alternatives or ways to cut down the list. My
front-running idea is to take samples from only genera with more than
10, or 30 or some other arbitrary high number of samples. This would cut
out all groups with only 1-4 accessions in them which i dont think are
useful to this analysis anyway as an average cannot be calculated, it
would also make the heatmaps much more legible, so i might run the
numbers on what cutting down the sample size would look like. It may
however, be better to group all those small genera into an "other"
column to make the dataset as big as possible, but that doesnt solve my
predicament. The total time continues to shrink, with the filter in
place and hopefully with the loops working it could take less than 10
days

::: {style="background-color:yellow;"}
📌 ?: TODO: [eggnog-mapper on hawk is slow, possibly too slow to scale
to where we need it to be. alternatives: \> what scale are we looking
at - 1693 samples for the family comparison \> could limit to genera
with more than 30 samples \> screenscrape-method \> enlist more manpower
to do online(if we have to do on web)]
:::

::: {style="background-color:yellow;"}
📌 ?: TODO: trees and formatting (never did gtdb repeat because need
download all the metadata to make it nice and sparkly)
:::

# A cautionary tale (2025-01-24 11:48)

So for the past 2 weeks while i was doing exams i decided i didnt want
to fully stop this project, but i didnt have enough time to do stuff and
properly fill the notebook, so i decided to leave myself placeholders in
multiple square brackets to make it obvious when i came back later, i
can't replicate this here. For some unknown reason doing too many square
brackets breaks the visual editor and busts the ability to knit. Anyway,
because of that i haveant been able to knit all this time and have just
lost the whole morning to trying to fix this, all over some square
brackets... the shame i feel from this is immeasurable. This really does
prove that there is **always** time for proper note taking.

::: {style="background-color:yellow;"}
📌 ?: TODO: API call for JSONS, fastas
:::

# Prototype Heatmap Creation Run, end-to-end: step 1 2025-01-24 to 2025-01-26

## introduction

Ok, i am done with the eggnog testing, i am in a place now where i am
happy to begin actually doing stuff with this. I figured that i should
start with the less intensive analysis, being the genera comparison of
just the ones our samples are in, seen in Table 3: [Our Genera]. This is
so that i don't have to think about automation to the same degree yet,
thus, i can create the pipeline in a more crude way and add "fancy code
stuff" to make it better later so i'm not wondering whats causing
problems. Even then, i am still going to start smaller, taking only 10
from each genus so that i can create a prototype of sorts, hopefully to
show Aaron when i am back in Bangor. Here is my plan for this section:

1.  Download the metadata for the chosen genera, this is going to use
    the
    [dataset_report](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/api/rest-api/#get-/genome/accession/-accessions-/dataset_report)
    API for the NCBI website. These will serve multiple purposes, for
    example they will tell me which samples have a high quality metric,
    they will also help with the generation of trees from gtdb-tk
    de_novo_wf done in Notebook 1, but not output because of this exact
    reason.

2.  Choose 10 accessions per genus to use in my prototype pipeline. All
    groups will total 10 samples, our own Bangor-made accession will be
    included in this number, excluding 1Dt100h, as gtdb-tk could not
    classify it into a family.

3.  Download the genomic .fasta files for all of these. This will use
    the [Download
    API](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/api/rest-api/#get-/genome/accession/-accessions-/download)
    to pull them from the NCBI website.

4.  Annotate all those fastas using eggNog-mapper on hawk.

5.  create the file(s) that turn the annotation file into a heatmap

## Methods

Using the httr2 package in R, i created . A useful command of not is
"req_dry_run" which allows one to view what the API request looks like.
From the first downloaded JSON(though im sure its in all others this is
the place i first found it) i found the concept of an "ANI" or Average
Nucleotide Identity analysis that the NCBI had performed, this is
interesting, can i do it on mine? One thing i forgot to do was remove
the local samples from the list i passed to NCBI, so those ones
obviously failed but it didn't affect the rest, so if this need be done
again, remember to take the local accessions out of the list. I created
two files for this section of the project:
[NCBImetadatacollector.R](https://github.com/tobiasnunn/tnunn_research/blob/be8100b850eea50a9e3132806623b4f1d1d08956/00_scripts/NCBImetadatacollector.R)
and
[jsondataexplorationprep.R](https://github.com/tobiasnunn/tnunn_research/blob/be8100b850eea50a9e3132806623b4f1d1d08956/00_scripts/jsondataexplorationprep.R).
The former file creates two tables, one containing the genera of
interest to the Bangor genera-genera comparison, and the other results
from using this to call the REST API to the NCBI website and save the
metadata for all the accessions in the aforementioned table. The latter
file manipulates this second table to pull out interesting fields from
the lower levels, combines it with the first to create a sort of
combined table of species and genus information from gtdb-tk combined
with quality metrics from the ncbi.

## Results

The API call itself took around 2 minutes to get 587 samples, very fast,
but also just slow enough to avoid the limit NCBI imposes on download
volume. The ANI stuff in the JSON files was very intriguing for me, i
decided i wanted to output a summary of the JSON files by their ANI
statuses:

### All tables {.tabset .tabset-pills}

#### JSON ANI analysis


```{=html}
<div id="dpoxojwghg" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dpoxojwghg table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#dpoxojwghg thead, #dpoxojwghg tbody, #dpoxojwghg tfoot, #dpoxojwghg tr, #dpoxojwghg td, #dpoxojwghg th {
  border-style: none;
}

#dpoxojwghg p {
  margin: 0;
  padding: 0;
}

#dpoxojwghg .gt_table {
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

#dpoxojwghg .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#dpoxojwghg .gt_title {
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

#dpoxojwghg .gt_subtitle {
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

#dpoxojwghg .gt_heading {
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

#dpoxojwghg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#dpoxojwghg .gt_col_headings {
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

#dpoxojwghg .gt_col_heading {
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

#dpoxojwghg .gt_column_spanner_outer {
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

#dpoxojwghg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dpoxojwghg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dpoxojwghg .gt_column_spanner {
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

#dpoxojwghg .gt_spanner_row {
  border-bottom-style: hidden;
}

#dpoxojwghg .gt_group_heading {
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

#dpoxojwghg .gt_empty_group_heading {
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

#dpoxojwghg .gt_from_md > :first-child {
  margin-top: 0;
}

#dpoxojwghg .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dpoxojwghg .gt_row {
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

#dpoxojwghg .gt_stub {
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

#dpoxojwghg .gt_stub_row_group {
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

#dpoxojwghg .gt_row_group_first td {
  border-top-width: 2px;
}

#dpoxojwghg .gt_row_group_first th {
  border-top-width: 2px;
}

#dpoxojwghg .gt_summary_row {
  color: #FFFFFF;
  background-color: #5F5F5F;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpoxojwghg .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D5D5D5;
}

#dpoxojwghg .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#dpoxojwghg .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#dpoxojwghg .gt_grand_summary_row {
  color: #FFFFFF;
  background-color: #929292;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpoxojwghg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D5D5D5;
}

#dpoxojwghg .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D5D5D5;
}

#dpoxojwghg .gt_striped {
  background-color: #F4F4F4;
}

#dpoxojwghg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D5D5D5;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D5D5D5;
}

#dpoxojwghg .gt_footnotes {
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

#dpoxojwghg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpoxojwghg .gt_sourcenotes {
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

#dpoxojwghg .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpoxojwghg .gt_left {
  text-align: left;
}

#dpoxojwghg .gt_center {
  text-align: center;
}

#dpoxojwghg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dpoxojwghg .gt_font_normal {
  font-weight: normal;
}

#dpoxojwghg .gt_font_bold {
  font-weight: bold;
}

#dpoxojwghg .gt_font_italic {
  font-style: italic;
}

#dpoxojwghg .gt_super {
  font-size: 65%;
}

#dpoxojwghg .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#dpoxojwghg .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#dpoxojwghg .gt_indent_1 {
  text-indent: 5px;
}

#dpoxojwghg .gt_indent_2 {
  text-indent: 10px;
}

#dpoxojwghg .gt_indent_3 {
  text-indent: 15px;
}

#dpoxojwghg .gt_indent_4 {
  text-indent: 20px;
}

#dpoxojwghg .gt_indent_5 {
  text-indent: 25px;
}

#dpoxojwghg .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}

#dpoxojwghg div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_title gt_font_normal" style><span class='gt_from_md'>Table 4 - Analysis of <br> Taxonomy Check Status</span></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style><span class='gt_from_md'>as a part of analysis for <br> Average Nuleotide Identity(ANI)</span></td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="taxonomy_check_status">Taxonomy Check Status</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="countofsamples">Count</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="DUPE_COLUMN_PLT">Visual</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="taxonomy_check_status" class="gt_row gt_left">OK</td>
<td headers="countofsamples" class="gt_row gt_right">445</td>
<td headers="DUPE_COLUMN_PLT" class="gt_row gt_left"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='113.39pt' height='14.17pt' viewBox='0 0 113.39 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='113.39' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw==)'><rect x='5.02' y='0.89' width='98.37' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #2565AB;' /><line x1='5.02' y1='14.17' x2='5.02' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td></tr>
    <tr><td headers="taxonomy_check_status" class="gt_row gt_left gt_striped">Inconclusive</td>
<td headers="countofsamples" class="gt_row gt_right gt_striped">100</td>
<td headers="DUPE_COLUMN_PLT" class="gt_row gt_left gt_striped"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='113.39pt' height='14.17pt' viewBox='0 0 113.39 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='113.39' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw==)'><rect x='5.02' y='0.89' width='22.11' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #2565AB;' /><line x1='5.02' y1='14.17' x2='5.02' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td></tr>
    <tr><td headers="taxonomy_check_status" class="gt_row gt_left">Absent</td>
<td headers="countofsamples" class="gt_row gt_right">33</td>
<td headers="DUPE_COLUMN_PLT" class="gt_row gt_left"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='113.39pt' height='14.17pt' viewBox='0 0 113.39 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='113.39' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw==)'><rect x='5.02' y='0.89' width='7.30' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #2565AB;' /><line x1='5.02' y1='14.17' x2='5.02' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td></tr>
    <tr><td headers="taxonomy_check_status" class="gt_row gt_left gt_striped">Failed</td>
<td headers="countofsamples" class="gt_row gt_right gt_striped">9</td>
<td headers="DUPE_COLUMN_PLT" class="gt_row gt_left gt_striped"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='113.39pt' height='14.17pt' viewBox='0 0 113.39 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='113.39' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxMTMuMzl8MC4wMHwxNC4xNw==)'><rect x='5.02' y='0.89' width='1.99' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #2565AB;' /><line x1='5.02' y1='14.17' x2='5.02' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3"><span class='gt_from_md'>Source: API call to the NCBI website <br> done on 2025-01-24</span></td>
    </tr>
  </tfoot>
  
</table>
</div>
```

#### ANI match status analysis


```
## `summarise()` has grouped output by 'taxonomy_check_status'. You can override
## using the `.groups` argument.
```

![](Notebook2_files/figure-html/Match_Status-1.png)<!-- -->

#### Completeness histogram

![](Notebook2_files/figure-html/completeness hist-1.png)<!-- -->

#### Contamination histogram

![](Notebook2_files/figure-html/contamination hist-1.png)<!-- -->

###  {.unnumbered}

The first file, "NCBImetadatacollector.R" creates a directory with all
of the JSON files in it
[here](https://github.com/tobiasnunn/tnunn_research/tree/be8100b850eea50a9e3132806623b4f1d1d08956/02_middle-analysis_outputs/ncbi_stuff/json)
and a file containing the table derived from gtdb-tk,
[here](https://github.com/tobiasnunn/tnunn_research/blob/be8100b850eea50a9e3132806623b4f1d1d08956/02_middle-analysis_outputs/analysis_tables/genera_analysis.tsv).
The second file, "jsondataexplorationprep.R" combines these into
[genera_analysis_combined.R](https://github.com/tobiasnunn/tnunn_research/blob/be8100b850eea50a9e3132806623b4f1d1d08956/02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv).
I used the package "jsonlite" to do this. This does not exist as a code
file, as i did all the coding inside this document. The function
`hoist()` from the package tidyr was also very helpful in drawing out
the lower levels of the JSON files.

I had many attempts at visualising all of the interesting columns but
possibly from messy data, possibly from a lack of understanding the
fields i did not make much progress on that. When trying to display the
information from the "match_status" column i ran into issues relating to
obscure scientific terms. One point of confusion was the reference
genomes, put in the "OK" taxonomy_check_status having a
"below_threshold_mismatch" in the former column. This is the lowest, or
"worst" on the hierarchy listed
[here.](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/policies-annotation/quality/ani/)
This field was especially cryptic, with the hierarchy not working as
this page said it should.

## Conclusion

I do not believe the graphs from this section show anything too
spectacular, however it was good practice at graphing and the main
purpose, being downloading the JSON files so i can make an informed
choice on which accessions will go in my prototype heatmap was a
success. I will be honest, i spent a little too much effort on these
graphs, there were many challanges with doing these things, but i learnt
a lot from that struggle. The next section should however be more
interesting.

::: {style="background-color:yellow;"}
📌 ?: TODO: have a look back at checkm and ANI(if it exists) analysis
for the local samples to add to the combi table in
"jsonataexplorationprep.R" next graphs up are going to be more simple
ones like the one for ANI, and then i also had the idea of doing a sort
of "megagraph" for completeness against contamination, where the colour
is the "refseq category" as for some reason, the accession with the
highest contamination is a reference genome, I can also modify the
column to include "bangor" as the category for ours so I know where they
place.
:::

# Prototype Heatmap Creation Run, end-to-end: steps 2 + 3 2025-01-26 to 2025-01-27

## Introduction

In part 1, i generated the metadata table that will help me choose "high
quality" samples(and maybe go on to make the phylogenetic trees from
gtdb-tk a bit more flashy later). This section will focus on specifying
a set of samples so that each "group" (a subset of samples for each
relevent genus) will total 10 samples, for 50 total (4 samples are
*Sphingomonas,* 2 are *Microbacterium,* there are 1 each for
*Brachybacterium, Brevibacterium* and *Pantoea*). This only totals 9
samples, this is because I am excluding 1Dt100h due to it not being
given a genus by gtdb-tk de_novo_wf. This means i need to select 41 more
samples to download the .fasta file for and copy to hawk.

## Methods

This process will use another command in the NCBI REST API library
called
[-accessions-/download](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/api/rest-api/#get-/genome/accession/-accessions-/download).
This will utilise the combined table made in step 1 to filter to 41
online reference samples of good quality to make the list i will pass to
the API call. My list will not include reference samples because I do
not find that as "organic". On the morning, of the 27th at 8:40 i ran
the NCBI REST API to download the subset of the fastas, using the same
document i started yesterday,
[NCBIfastacollectorprototype.R](https://github.com/tobiasnunn/tnunn_research/blob/c23c334f1fc9acfc10b05f66a0474d6ce3600d3a/00_scripts/NCBIfastacollectorprototype.R).
The code therein place the .fastas in a directory in
02_middle-analysis_outputs/ncbi_stuff. However, this will not show on
github because there are many and fasta files are very large and i have
a limited space allowance in the repo. I then modified this file to
include another for loop to unzip the files and give me the .fastas,
[here.](https://github.com/tobiasnunn/tnunn_research/blob/2827ddaa51c73370b0d1b4a7ca847dfc634acff6/00_scripts/NCBIfastacollectorprototype.R)

## Results

As mentioned above: the directory containing the .fastas is part of the
.gitignore, so there are no visible results, but trust me, they are
there.

## Conclusion

Non Applicable, this is just a quick intermediary

# Prototype Heatmap Creation Run, end-to-end: step 4 2025-01-27 to 2025-01-28

## Introduction

I have the 41 fastas, the job of uploading them to hawk was easy enough.
Now i need to think automation, i could manually input all these files
into a slurm script, but that is not very fun, and more practically,
very error prone. This means i need to think how i might automate a
script to sort of iterate over a directory of files.

## Methods

From my testing earlier this month, i have [this bash
script](https://github.com/tobiasnunn/tnunn_research/blob/2827ddaa51c73370b0d1b4a7ca847dfc634acff6/00_scripts/anothergo_morecpu.sh).
It is the best i have so far, but it is still manual. Noteable
improvements i made were the mailing parameters so i can see when a job
is done from my phone, and some general messing about with `seff` to
optimise things like cpus and memory. I decided to use this as a
template to make [this
script](https://github.com/tobiasnunn/tnunn_research/blob/2827ddaa51c73370b0d1b4a7ca847dfc634acff6/00_scripts/prototypebatch1.sh).
This will run 3 accessions, alphabetically descending so i can keep
track. I originally was going to run three of these, but trying to
manually copy + paste in all those complex alphanumeric strings was
difficult. Thus, proving the need for automation. This file will run
hopefully while i'm in lectures this afternoon, and i can then work on
making the script better (hopefully without breaking it), after that.
There was no real reason to do it this way, i just wanted something to
be happening while i was in lectures as i had the .fastas anyway. In the
evening, i attempted to begin using parameters to automate some of the
naming to speed up (and make less error prone) the process. Using help
from an email from Aaron.

I decided to add another section on the bottom of my
"NCBIfastacollectorprototye.R" script called "create the control files".
These are the files that will run other files in slurm. The first step
uses regular expressions (regex), which i discovered while using stack
overflow to solve the `separate()` statement. It is very weird and kind
of bananas, but it feels like the type of thing a professional with
standards would use, so i feel the need to at least use them correctly,
if not fully understand them, because, as i say "bananas". I found
[regex101.com](https://regex101.com/) and using several stack overflow
articles. Once this was done, 3 files were outputted, 1 with a group
size of 13, 2 with 12. These will be the files the hawk script will use
to set parameters so the .fastas, which i manually brought up to hawk
will be run upon. On hawk i created a script called
[slurmsquared.sh](https://github.com/tobiasnunn/tnunn_research/blob/88f05f800e18df832c875992534faf4778c9bfbd/00_scripts/slurmsquared.sh)(because
it is a script that works on scripts and .tsv files). I also created a
modified version of my testing file called
[eggnogslurmrunner.sh](https://github.com/tobiasnunn/tnunn_research/blob/88f05f800e18df832c875992534faf4778c9bfbd/00_scripts/eggnogslurmrunner.sh),
this is the file that sets what i want slurm to do. Using these scripts,
i managed to get 13 jobs (1 accession per job) to occur automatically.
One of the proposed benefits of doing it this way was that jobs could be
run in parallel, however, thusfar, slurm is denying me this, i have not
gotten it to run any of these eggnog jobs in parallel before, so i shall
see if it does it here, i think that the individual jobs are too large
for it to warrant paralleling. Once that set is done, i will then run
the next, then the next.

Ok, while those are doing, i need to think about how i am going to get
the .xlsx files off of hawk once they are done. This lead me to generate
[eggnog_annotation_getter.sh](https://github.com/tobiasnunn/tnunn_research/blob/d3597774d45daa4bf2a76fcb46b114aac9ac5e6d/00_scripts/eggnog_annotation_getter.sh).
An easy-peasy little file that pulls out all the .xlsx files and slaps
them into a directory. Once more are done, i will manually pull them off
of hawk, maybe i should zip them first? we'll see. Anyway, i might as
well get to work on the pipeline to turn these into a heatmap so it is
ready for when all 41 have downloaded.

## Results

As mentioned above: the directory containing the .fastas is part of the
.gitignore, so there are no visible results, but trust me, they are
there. I am guessing the same will go for the directory containing the
xlsx files, but they are a fair ways smaller so maybe for the prototype
stage they will be alright.

## Conclusion

Non Applicable, this is just a quick intermediary

# Prototype Heatmap Creation Run, end-to-end: step 5 2025-01-27 to 2025-01-29 💎🦍🗿

## Introduction

So, the 41 accessions are going through eggnog, good. This is however
going to take time, under or around 20 hours total if they do not do in
parallel, which i do not think is likely. So, i might as well get to
work creating the file(s) that go into turning the .xlsx files from hawk
into a metadata file into a heatmap. I want to get this in one file for
simplicity, but two might be necessary / more optimal in ways i don't
quite understand yet.

## Methods

After pulling down the annotations that had been run by 20:37 on the
28th, 20 total with the local samples, i started by making the metadata
file needed to begin the pipeline to the heatmap. This involved two
columns, mag_id and bac_taxon. I used the file
[metadata_maker.R](https://github.com/tobiasnunn/tnunn_research/blob/89bf0cdd5086df2c75bef487b98ff9c530e4ef12/00_scripts/metadata_maker.R)
to do this, very simple, brings in files i already had, combines them
and cuts out excess so what is output is just the file as per
specifications of the example Aaron gave me months ago when i did the
fly stuff(not relevant to this project). This output i then feed into my
[KEGG_pipeline_pt1.R](https://github.com/tobiasnunn/tnunn_research/blob/89bf0cdd5086df2c75bef487b98ff9c530e4ef12/00_scripts/KEGG_pipeline_pt1.R)
file to turn into the intermediary. I am using two files for this part,
because i realised the reason Aaron did two files was that it would be
heavily inconvenient having to do all the stuff in pt1 every time you
wanted to run pt2, so it is much simpler to save the outputs to a file
that can easily be read in as much as you want. Progress is kind of now
halted until all 50 are completed. Right, overnight between the 28th and
the 29th (about 2pm to 6:30am) all 41 ran on hawk, some of them even
went in parallel, i suppose that in the night there is less burden on
hawk so it is more availiable to do two at once, all but one of these
were successful, so now, i have to figure out which accession i don't
have so i can run that one again. i have downloaded the 40 other files
to my landing pad so they can both go through the pipeline. However, i
need the extra one to generate output without changing the list. This
leads to the importance of inputting error handling, i still do not know
why it messed up the first time ((occasionally it just happens) but
after that it kept crashing because files already existed, so i added
the `--override` command to override any existing files, so hopefully
this run should be the last and i will have my prototype dataset by the
end of today.

I should mention how useful the R packages tidyverse and dplyr have been
in all of these processes. One step of note is that oddly i found that
sometimes, eggnogmapper would output multiple KO pathways in the same
cell (i.e. "ko:KO1234" vs "ko:KO1234,ko:KO4321,ko:KO3241"). I am unsure
why it does this, maybe it can't determine which of the three is
present. Anyway, i decided to cut the list to seperate and keep all
three as separate arguments, because why not, it may be that these
should have been left in the same cell, but onward i go. Another issue i
then ran into was `enrichko()` when i first tried to run a KO value
through it, it crashed reporting

"--\> No gene can be mapped....

--\> Expected input gene ID: K13952,K00128,K08074,K01837,K00175,K02777

--\> return NULL..."

I tried another one and it gave a result, so is it possible enrichko
just does not know about some pathways? Doing a check on the KEGG
website i found that the ones returning NULL do not have a map id, not
sure what this means, but i think it is alright that they are being
excluded, because i am looking for map ids. With that, my file
[KEGG_pipeline_pt1.R](https://github.com/tobiasnunn/tnunn_research/blob/004feb0c0e62718a3783ef77a4934af373fdfd39/00_scripts/KEGG_pipeline_pt1.R)
is done, i have the pivot table with the genera and map ids. Now i just
have to turn those into heatmaps. Not too long later, i had part 2 done,
[KEGG_pipeline_pt2.R](https://github.com/tobiasnunn/tnunn_research/blob/3c07ec738628981557eb98173b99e99ad7412c39/00_scripts/KEGG_pipeline_pt2.R).
This is a simple little file that reads in the output from 1, turns all
the columns into proportions, pivots and other clever stuff until i have
the thing to heatmap, then gives multiple possible aesthetic choices,
very good.

## Results

I don't think i can infer anything from the prototype heatmap, there are
many map values, but i should wait until the whole dataset is done
before just saying "these are the map values of interest". Still, as a
prototype it serves as perfect proof that I can scale up. I am going for
dinner now, but i'll try remember to put the sample heatmaps here after,
tomorrow morning at the latest.

![Figure 4 - Prototype Heatmap aesthetic style
1](03_final_outputs/prototype_heatmaps/sample1.png)

![Figure 5 - Prototype Heatmap aesthetic style
2](03_final_outputs/prototype_heatmaps/sample2.png)

![Figure 6 - Prototype Heatmap aesthetic style
3](03_final_outputs/prototype_heatmaps/sample3.png)

## Conclusion

This section of the project has been a resounding success, the pipeline
is largely where it needs to be, i have the prototype heatmap to
hopefully impress Aaron with. Aaron said his preference was style 3
(figure 6)

There is still some more work to go before i can begin in proper, vis a
vis:

1.  how to monitor that many slurm jobs and resubmit failed ones

2.  how to perform koenrich() only once per excel file and store the
    results for later use

3.  how to make the proportions proportionate when there are a different
    number of samples per genera

4.  dashboard of progress (super-special secret potential proj)

I am still missing that one that still hasn't been eggnog'ed on hawk,
must be a busy day.

I also need to remember i still haven't gotten around to doing the
remodels of the gtdb-tk phylogenetic trees, keep putting them off
because i want to use the .JSON files to do flashy stuff

::: {style="background-color:yellow;"}
📌 ?: TODO: the notebooks are having trouble knitting. something to look
at tomorrow morning, get on with crab stuff while fresh(not relevent to
this work), finish that paper and do the special KOenrich thing.
:::

::: {style="background-color:yellow;"}
📌 ?: LONGTERM HEATMAP TODO: Sphingomonas and Pantoea dominate the
heatmap, i wonder what a little secondary heatmap might look like if i
take those genera out and just compare the 3 lesser ones. Remember, i
still have to do the heatmaps for family stuff and do the proper for
genera-genera
:::

# Pipeline optimisation ahead of running the full thing ☠️ 🍽️ (2025-01-31)

## Introduction

The main focus of this bit is making sure that once the files have been
brought down from eggnog, they get turned into heatmaps as fast as
possible. This mainly focuses on the enrichment process, which is very
time consuming when doing files in bulk. The ideal would be for each
eggnogmapper output file to be enriched only once.

## Methods

I have done this by separating my pt1 script in the pipeline into 2, so
now there are 3 parts total. The new
[part1_enrich](https://github.com/tobiasnunn/tnunn_research/blob/c93c32fbe35286862eeda7db9ca09371296f24a4/00_scripts/KEGG_pipeline_pt1_enrich.R)
focuses purely on enriching the output files and sending those outputs
into .tsv files that
[part2_aggregate](https://github.com/tobiasnunn/tnunn_research/blob/c93c32fbe35286862eeda7db9ca09371296f24a4/00_scripts/KEGG_pipeline_pt2_aggregate.R)
can now read in and aggregate, producing the output table needed in the
unmodified (but renamed)
[part3_heatmap](https://github.com/tobiasnunn/tnunn_research/blob/c93c32fbe35286862eeda7db9ca09371296f24a4/00_scripts/KEGG_pipeline_pt3_heatmap.R).

## Conclusion

This is better because in the old way, i had to run the whole file, and
wait 10-15 minutes for it to enrich, just so i could output the
aggregate file, so now i only need do it once and then read in the
files. So now the enriched files are much more available for analysis.

# Analysis 1: full genera-to-genera comparison (2025-01-31 to 2025-02-\_\_)

## Introduction

Now that the pipeline is where i want it, all that is left to do is
download somewhere north of 500 more accessions, put them on hawk,
eggnog them and bring them down to be heatmapped.

## Methods

I started by creating a non-prototype version of
"NCBIfastacollectorprototype", called
[NCBIfastacollector.R](https://github.com/tobiasnunn/tnunn_research/blob/7dc52b5c9490c2174cb5271cea988ef9beafabf8/00_scripts/Rscripts/NCBIfastacollector.R).
This is largely only different in so far as it includes filters based
around not repeating the fasta files i have already done. This is when i
ran into my first roadblock concerning how i create the control files
that feed my "slurmsquared.sh" file on hawk. Mainly, how to exclude the
fastas that have already been processed in a way that doesn't rely on a
file further down the pipeline. A possible solution i am going to try
later is downloading all of the fastas now, create all of the control
files now and then apart from the files done in the prototype i don't
have to do any exclusions. I separated "NCBIfastacollector" into it's
major components, this created the script "fasta_control_files.R". I
then modified this file so it would take outputs from the former (and a
few other earlier scripts) and cluster the accessions into output
directories i can then pass up to hawk, the aim is to create the control
script at the same time, but it is late and i could not get there today.

## Results

PUT HEATMAP HERE

(and then also the table that explains all of the map ids, can i use the
KEGG API to help me there?)

(also: compare with prototype, are the map ids the same, are there
differences?)

## Conclusion

The screen i am using is burning my eyes now i'm putting in more
consecutive hours, so i am changing the mode to "Gob", the "tools" tab
under global and appearance. I have chosen this dark mode purely for the
name Gob, i find it humorous.

![](images/clipboard-3109512063.png)
