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

all_df = raw_df %>% inner_join(cluster_df, by=c('sport'))

# see where each cluster over or under indexes 
cluster_means = all_df %>% 
  group_by(clusters) %>% 
  summarize('endurance' = mean(endurance), 
            'strength' = mean(strength), 
            'power'= mean(power), 
            'speed' = mean(speed), 
            'agility' = mean(agility), 
            'flex' = mean(flexibility), 
            'nerve' = mean(nerve), 
            'durability' = mean(durability), 
            'hand_eye' = mean(hand_eye), 
            'analytic' = mean(analytic)) %>% 
  ungroup() %>% 
  gather(., key= "category", value = "cluster_mean", -1)

overall_means = raw_df %>% 
  summarize('endurance' = mean(endurance), 
            'strength' = mean(strength), 
            'power'= mean(power), 
            'speed' = mean(speed), 
            'agility' = mean(agility), 
            'flex' = mean(flexibility), 
            'nerve' = mean(nerve), 
            'durability' = mean(durability), 
            'hand_eye' = mean(hand_eye), 
            'analytic' = mean(analytic)) %>% 
  gather(., key= "category", value = "overall_mean")
indexes = cluster_means %>%  inner_join(., overall_means, by ='category') %>% 
          mutate('index' = round(cluster_mean/overall_mean,2)) %>% 
          select(clusters, category, index) %>% 
          mutate('index_desc' = ifelse(index >= 1.2, 'Over',
                                       ifelse(index <= .8, 'Under', 'None')))

