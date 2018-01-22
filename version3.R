# version 3 a radical rethink on the problem and our data
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
  mutate(Clinton.Margin = Clinton-Trump) %>% select(end_date, Clinton.Margin)

# rather than looking at it as a join, we can visualise the problem as we entries
# and we want to keep track of entries valid for particular days
# an entry is valid for the next 13 days
# so we make valid entries then just group them
library(ggplot2)
Avs <- bind_rows(polls_2016,
          polls_2016 %>% mutate(end_date=end_date+1),
          polls_2016 %>% mutate(end_date=end_date+2),
          polls_2016 %>% mutate(end_date=end_date+3),
          polls_2016 %>% mutate(end_date=end_date+4),
          polls_2016 %>% mutate(end_date=end_date+5),
          polls_2016 %>% mutate(end_date=end_date+6),
          polls_2016 %>% mutate(end_date=end_date+7),
          polls_2016 %>% mutate(end_date=end_date+8),
          polls_2016 %>% mutate(end_date=end_date+9),
          polls_2016 %>% mutate(end_date=end_date+10),
          polls_2016 %>% mutate(end_date=end_date+11),
          polls_2016 %>% mutate(end_date=end_date+12),
          polls_2016 %>% mutate(end_date=end_date+13)) %>%
  group_by(end_date) %>% 
  summarise(Clinton.Avg = mean(Clinton.Margin, na.rm = TRUE))
  ggplot()+
  geom_point(data=polls_2016, aes(x=end_date,y=Clinton.Margin)) +
  geom_line(data=Avs, aes(x=end_date,y=Clinton.Avg),col="blue")
  
  