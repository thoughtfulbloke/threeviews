# version 2 a find and summarise, not join
#note I saved the file "http://elections.huffingtonpost.com/pollster/api/v2/questions/16-US-Pres-GE%20TrumpvClinton/poll-responses-clean.tsv"
# as a local csv "polls.csv" to avoid network issues in timing- proxy caching the 1st time it is got etc
# principle 1: Keep the flow going to avoid unneeded save steps
# principle 2: Get rid of what you don't need to make handling the data lighter
library(readr)
library(dplyr)
polls_2016 <- read_csv("polls.csv") %>%
  filter(sample_subpopulation %in% c("Adults","Likely Voters","Registered Voters")) %>%
  group_by(end_date) %>% 
  summarise(Clinton = mean(Clinton), Trump = mean(Trump)) %>% 
  mutate(Clinton.Margin = Clinton-Trump) %>% select(end_date, Clinton.Margin) %>% arrange(end_date)

# rather than looking at it as a join, we can visualise the problem as we want to
# find and summarise entries in a dataset on the basis of information in a second dataset
Avs <- data.frame(end_date = seq.Date(min(polls_2016$end_date),
                               max(polls_2016$end_date), by="days"))
#I could load purrr and map it, but I date back to the age of base
Avs$Clinton.Avg <- sapply(Avs$end_date, function(x){
  mean(polls_2016$Clinton.Margin[polls_2016$end_date <= x & polls_2016$end_date > x - 14])
})

# make the graph from the two different data sets
  ggplot()+
  geom_point(data=polls_2016, aes(x=end_date,y=Clinton.Margin)) +
  geom_line(data=Avs,aes(x=end_date,y=Clinton.Avg),col="blue")
  