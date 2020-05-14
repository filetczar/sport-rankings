library(stats)
library(tidyverse)

set.seed(123)


raw_df = readr::read_csv('./data/espn-sport-rankings.csv')

# prepare for K_means 

model_df <- raw_df[,setdiff(names(raw_df),c('rank', 'total'))]
row.names(model_df) <- model_df$sport
model_df <- model_df[,setdiff(names(model_df), 'sport')]
model_df <- scale(model_df)

# k means

km_model = kmeans(model_df, 5, nstart=25)

cluster_df <- data.frame('sport' = raw_df$sport, 
                         'clusters' = km_model$cluster)
