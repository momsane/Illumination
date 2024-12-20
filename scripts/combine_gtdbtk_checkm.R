# Load required libraries

if(!require(tidyverse)){
  install.packages(pkgs = 'tidyverse', repos = 'https://stat.ethz.ch/CRAN/')
  library(tidyverse)
}

##### Read inputs #####

checkm <- read.table(snakemake@input[['checkm']], sep = "\t", header = T, comment.char = "")
tax <- read.table(snakemake@input[['gtdbtk']], sep = "\t", header = T, comment.char = "")

### Reformat tables ###

# Create column for lineage taxonomic level, and replace letters with
# full name for each rank

ranks <- c("root (UID1)" = "root",
           "k" = "kingdom",
           "c" = "class",
           "o" = "order",
           "f" = "family",
           "g" = "genus")

colnames(checkm) <- gsub("\\.\\.", "_", colnames(checkm))
colnames(checkm) <- gsub("X_", "n_", colnames(checkm))

checkm <- checkm %>%
  separate(Marker.lineage, into = c("rank", NA), sep = "_", remove = F,
           fill = "right", extra = "drop") %>%
  mutate(rank = case_when(
    rank %in% names(ranks) ~ ranks[rank],
    TRUE ~ rank
  )) %>%
  rename(user_genome = Bin.Id)

# Collect only relevant info from classify output

tax <- tax %>%
  separate(classification,
           into = c("domain", "phylum", "class", "order", "family", "genus", "species"),
           sep = ";",
           remove = F) %>%
  select(all_of(c("user_genome", "classification", "domain", "phylum",
                  "class", "order", "family", "genus", "species",
                  "classification_method", "closest_placement_reference",
                  "closest_genome_ani", "red_value", "warnings")))

### Combine tables ###

comb <- tax %>%
  left_join(checkm, by = "user_genome") %>%
  arrange(user_genome)

### Write output ###

write.table(comb, snakemake@output[['file']], sep = "\t", quote = F, col.names = T, row.names = F)
