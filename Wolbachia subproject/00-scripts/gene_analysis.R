# libraries 
library(tidyverse)
library(readxl)
# input xlsx for 09b
table <- read_xlsx("hawk_outputs/ztsac_STPz09b_annotation/ztsac_STPz09b.emapper.annotations.xlsx", skip = 2)
cut <- table %>% select(Preferred_name, Description, seed_ortholog)

cut <- cut %>% filter(Preferred_name != "-")


# input xlsx for 01
table2 <- read_xlsx("hawk_outputs/ztaro_STPz01_annotation/ztaro_STPz01.emapper.annotations.xlsx", skip = 2)
cut2 <- table2 %>% select(Preferred_name, Description, seed_ortholog)

cut2 <- cut2 %>% filter(Preferred_name != "-")

# https://pmc.ncbi.nlm.nih.gov/articles/PMC5793819/
# this one talks about possible loci 
# CifA is apparantly locus WD0631 and B is locus WD0632
# gonna put the seed_orthologs column in, it has a similar code in it
# now filter by that? first i need to get the bit i dont want out
int <- cut %>% separate_wider_delim(cols = seed_ortholog, delim = ".", names = c("bad", "code"))
int$bad <- NULL

# ok, now i filter
spec <- int %>% filter(code == "WD_0632" | code == "WD_0631")
# hmm, nothing, lets try by "CifA"
spec_other <- int %>% filter(Preferred_name == "cifB" | Preferred_name == "cifA")



# nothing in 09b, now lets try 01

int2 <- cut2 %>% separate_wider_delim(cols = seed_ortholog, delim = ".", names = c("bad", "code"))
int2$bad <- NULL

# ok, now i filter
spec2 <- int2 %>% filter(code == "WD_0632" | code == "WD_0631")
# hmm, nothing, lets try by "CifA"
spec_other2 <- int2 %>% filter(Preferred_name == "cifB" | Preferred_name == "cifA")

# now for the WO Phage stuff..
WOP <- int %>% filter(Preferred_name == "gp15" | Preferred_name == "orf2" | Preferred_name == "gwv_1139")
WOP2 <- int2 %>% filter(Preferred_name == "gp15" | Preferred_name == "orf2" | Preferred_name == "gwv_1139")

# Aaron emailed me about looking for "Cytoplasmic incompatibility factor" in im guessing description
desc <- int %>% filter(grepl("Cytoplasmic*", Description))
desc2 <- int2 %>% filter(grepl("Cytoplasmic*", Description))
#-----------------------------------------possible sources of inspiration------------------------------------------
# https://github.com/eggnogdb/eggnog-mapper/issues/52
# this might have the answer
#https://github.com/eggnogdb/eggnog-mapper/issues/180
# GO terms?
#https://journals.asm.org/doi/full/10.1128/aem.01172-09
# i dont think there is much hope here
#https://www.uniprot.org/uniprotkb?query=WO+Phage