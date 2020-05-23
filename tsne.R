packages <- c('tsne', 'caret', 'plotly')
for(p in packages){
  if(p %in% c(installed.packages())){
    next
  } else {
    install.packages(p)
  }
}
library('tsne')
library('caret')
library('ggplot2')
library('plotly')

set.seed(1)

raw_df = readr::read_csv('./data/espn-sport-rankings.csv')
model_df <- raw_df[,setdiff(names(raw_df),c('rank', 'total', 'sport'))]

tsne_model <-  tsne(as.matrix(scale(model_df)),
                  k = 2, 
                  max_iter = 1500, 
                  perplexity = 3, 
                  initial_dims = 10)
                  

graph_df <- data.frame('sport' = raw_df$sport, 
                          'x' = tsne_model[,1], 
                          'y' = tsne_model[,2]) %>% 
            dplyr::inner_join(cluster_df, by='sport')



p = ggplot(graph_df, aes(x,y, label = sport, color = factor(clusters))) +
  geom_point() +
  scale_color_manual(values = c('red', 'green', 'blue', 'orange', 'purple', 'yellow'))


ggplotly(p)



