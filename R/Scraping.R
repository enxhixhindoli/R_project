library(xml2)
library(rvest)
library(stringr)
library(tidyverse)

#Specifying the url for desired website to be scrapped
url <- read_html("https://www.infoplease.com/business-finance/poverty-and-income/capita-personal-income-state")

#scrape table
income <- url %>%
  html_node(css = "#A0104653")%>%
#You are giving to the css argument a sting, that is whi is in "" and it needs the css selector (the#))
  html_table()

income <- as_tibble(income)
income <- select(income, State,`2015`)

#To change the format in which this variable is shown:
income <- income %>%
  mutate(`2015`=str_extract_all(`2015`,"[0-9]+"))%>%
  mutate(`2015`=map_chr(`2015`,paste,collapse=""))

typeof(income)
as.data.frame(income)
names(income)[names(income) == "2015"] <- "Avg_Income_2015"

#Specifying the url for another website to be scrapped
url2 <- read_html("https://www.50states.com/abbreviations.htm")

#scrape table
states <- url2 %>%
  html_node("[class='spaced stripedRows']")%>%
  #You are giving to the css argument a string, that is why is in "" and it needs the css selector (the#)
  html_table()

typeof(states)
as.data.frame(states)

#Dropped some useless information from the table
states <- states[-(51:67),]

#Rename column to merge by the column name
names(states)[names(states) == "US State:"] <- "State"
names(states)[names(states) == "Abbreviation:"] <- "State_Abbreviation"

write.csv(states, file="States_abreviations.csv", row.names = F)

#merging the two tables of scraping
Income_per_state <- merge(income,states,by="State")
write.csv(Income_per_state, file="Avg_Inc_State.csv", row.names = F)
