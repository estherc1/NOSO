rm(list=ls())
setwd("/Users/hee-wonchang/Desktop/cancershiny")
cancer <- read.csv("CancerByAge.csv")

#EDA
table(cancer$age) #<1, 1-4, 4-9, ... 75-79, 80-84, 85+
cancer$age <- factor(cancer$age, levels(cancer$age)[c(1,2,11,3:10,12:19)])

table(cancer$event_type) #incidence OR mortality

table(cancer$race) #all race + 5 separate races
cancer$race <- as.character(cancer$race)

table(cancer$sex) #male, female, combined
cancer$sex <- as.character(cancer$sex)

table(cancer$site) 
cancer$site <- as.character(cancer$site)
cancer$site[cancer$site=="Female Breast, <i>in situ</i>"] <- "Female Breast, in situ"
cancer$site[cancer$site=="Male and Female Breast, <i>in situ</i>"] <- "Male and Female Breast, in situ"

cancer$year <- as.character(cancer$year)
table(cancer$year) #1999-2012 + "2008-2012"

cancer$count <- as.numeric(cancer$count)
summary(cancer$count) #skewed right, 128K NA's
hist(log(cancer$count))

cancer$population <- as.numeric(cancer$population)
summary(cancer$population) #skewed left, 3420 age group with 0
hist(log(cancer$population))

#removing weird category
rowstorm <- union(which(cancer$race=="All Races"), which(cancer$sex=="Male and Female"))
rowstorm <- union(rowstorm, which(cancer$site=="All Cancer Sites Combined"))
rowstorm <- union(rowstorm, which(cancer$year=="2008-2012"))

#cleaned dataset
cancdata <- cancer[-rowstorm,-c(2,3,8)] #121,030 rows, 9 columns

table(cancdata$age) #<1, 1-4, 5-9, ... 75-79, 80-84, 85+
table(cancdata$event_type) #incidence OR mortality
table(cancdata$race) #5 different races
table(cancdata$sex) #female or male
table(cancdata$site) #27 different site
table(cancdata$year) #1999-2012

cancdata$incrate <- cancdata$count/cancdata$population*100000

#write.csv(cancdata, "cancdata.csv")

#plot demo
eda1 <- cancdata %>% 
  group_by(site) %>% 
  summarise(Cancer_Occurence=sum(count,na.rm = TRUE),
            Total_Population = sum(population,na.rm = TRUE),
            Incidence_Rate = round(Cancer_Occurence/Total_Population*100000,2)) %>%
  arrange(desc(Incidence_Rate)) %>% head(10)

ggplot(subset(eda1, !is.na(Incidence_Rate)), aes(x=reorder(site,Incidence_Rate), y=Incidence_Rate))+
  geom_bar(stat='identity', fill="turquoise") +
  ylab("Incidence per 100,000") + xlab("") + ggtitle("Top 10 Cancers by Rates of New Cancer Cases")+
  scale_fill_brewer(palette="Dark2")+
  coord_flip()

eda2 <- cancdata %>% group_by(site,event_type) %>%
  summarise(Cancer_Occurence=sum(count,na.rm = TRUE),
            Total_Population = sum(population,na.rm = TRUE),
            Incidence_Rate = round(Cancer_Occurence/Total_Population*100000,2)) %>%
  filter(event_type=="Mortality")%>% 
  arrange(desc(Incidence_Rate)) %>% head(10)

ggplot(subset(eda2, !is.na(Incidence_Rate)), aes(x=reorder(site,Incidence_Rate), y=Incidence_Rate))+
  geom_bar(stat='identity', fill="coral") +
  ylab("Incidence per 100,000") + xlab("") + ggtitle("Top 10 Cancers by Rates of Cancer Deaths")+
  scale_fill_brewer(palette="Dark2")+
  coord_flip()

eda3 <- cancdata %>% 
  group_by(year, sex) %>% 
  summarise(Cancer_Occurence=sum(count,na.rm = TRUE),
            Total_Population = sum(population,na.rm = TRUE),
            Incidence_Rate = round(Cancer_Occurence/Total_Population*100000,2)) %>% arrange(year)

ggplot(eda3, aes(x=year, y=Incidence_Rate, group=sex)) + 
  geom_line(aes(color=sex)) + 
  geom_point(aes(color=sex)) +
  xlab("") + ylab("Incidence per 100,000") + 
  ggtitle("Timeline of Cancer Incidence Rate") 


eda4 <- cancdata %>% 
  group_by(age, sex) %>% 
  summarise(Cancer_Occurence=sum(count,na.rm = TRUE),
            Total_Population = sum(population,na.rm = TRUE),
            Incidence_Rate = round(Cancer_Occurence/Total_Population*100000,2)) 

ggplot(eda4, aes(x=age, y=Incidence_Rate, group=sex)) + 
  geom_line(aes(color=sex)) + 
  geom_point(aes(color=sex)) +
  xlab("") + ylab("Incidence per 100,000") + 
  ggtitle("Cancer Incidence Rate by Age") 

pie(table(cancdata %>% select(event_type)),col= c(5,2),
    main="Incidence vs. Mortality")

ggplot(cancdata %>% filter(year%in%c(1999,2012),site%in%c("Female Breast")) %>%
         select(event_type), 
       aes(x="", y=event_type, fill=event_type)) + geom_bar(width = 1, stat = "identity")+
  coord_polar("y", start=0) + ylab("")  + xlab("")



