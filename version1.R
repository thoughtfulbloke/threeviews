# version 1 a mild reworking of adding blank days
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

# rather than looking at it as a join, we can visualise the problem as we want to
# add entries for dates in the range that are not present 
library(zoo)
library(ggplot2)
bind_rows(data.frame(end_date = seq.Date(min(polls_2016$end_date),
                 max(polls_2016$end_date), by="days")) %>%
            filter(!end_date %in% polls_2016$end_date) %>%
  mutate(Clinton.Margin = NA), polls_2016) %>% arrange(end_date) %>% 
  mutate(Clinton.Avg = rollapply(Clinton.Margin,width=14,
                                 FUN=function(x){mean(x, na.rm=TRUE)},
                                 by=1, partial=TRUE, fill=NA, align="right")) %>% 
  ggplot()+
  geom_line(aes(x=end_date,y=Clinton.Avg),col="blue") +
  geom_point(aes(x=end_date,y=Clinton.Margin))