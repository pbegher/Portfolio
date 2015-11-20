Analyze <- function(flightNum, directory, filename) {
#USAGE:  Analyze(23967,'/Users/philbegher/CustomPrograms/SpongeKeyGrabber','23967_Data.csv')
  
#The function will need:
#1. flight id - to extract spongekey data for target flight only.
  #USAGE:
#2. directory - location of original spongekey data containing all flights that users may have seen impressions from
  #USAGE:  Submit directory into function within single quotes. EX:  '/Users/philbegher/CustomPrograms'
#3. filename - to read appropriate file into R
  #USAGE:  Submit filename into function within single quotes. EX:  '23967_Data.csv'

#update.packages("sqldf")
library("sqldf")

setwd(directory)
data <- read.csv(filename, header=TRUE, sep=",")

#Flight Performance - To compare with Reporting results
FlightResults <- fn$sqldf("select sum(case when metric = 'impression' then 1 else 0 end) as Impression,sum(case when metric = 'click_through' then 1 else 0 end) as Click,case when sum(case when metric='impression' then 1 else 0 end)=0 then 0 else 1.0*sum(case when metric = 'click_through' then 1 else 0 end)/sum(case when metric = 'impression' then 1 else 0 end) end as CTR,sum(case when metric = 'mouseover' then 1 else 0 end) as Mouseover,case when sum(case when metric='impression' then 1 else 0 end)=0 then 0 else 1.0*sum(case when metric = 'mouseover' then 1 else 0 end)/sum(case when metric = 'impression' then 1 else 0 end) end as MouseoverRate,sum(case when metric = 'engagement' then 1 else 0 end) as Engagement,case when sum(case when metric = 'impression' then 1 else 0 end)=0 then 0 else 1.0*sum(case when metric = 'engagement' then 1 else 0 end)/sum(case when metric = 'impression' then 1 else 0 end) end as EGR from data where flight_id = $flightNum")
print(FlightResults)


##Table of Counts
countsTable <- fn$sqldf("select ID,sum(case when metric = 'impression' then 1 else 0 end) as Impression,sum(case when metric = 'mouseover' then 1 else 0 end) as Mouseover,sum(case when metric = 'engagement' then 1 else 0 end) as Engagement,sum(case when metric = 'interaction' then 1 else 0 end) as Interaction,sum(case when metric = 'click_through' then 1 else 0 end) as click from data where flight_id = $flightNum group by ID")

##Tables of users who "converted" (ie. gave a click_through)
#Query limits counts to users WITH CLICK_THROUGH
#countsTable <- fn$sqldf("select ID,sum(case when metric = 'impression' then 1 else 0 end) as Impression,sum(case when metric = 'mouseover' then 1 else 0 end) as Mouseover,sum(case when metric = 'engagement' then 1 else 0 end) as Engagement,sum(case when metric = 'interaction' then 1 else 0 end) as Interaction,sum(case when metric = 'click_through' then 1 else 0 end) as click from data where flight_id = $flightNum and ID IN (select ID from data where flight_id = $flightNum and metric='click_through' group by ID) group by ID")

eventCountAverages <- sqldf("select click,count(ID),1.0*sum(Impression)/count(ID) as AvgImpCnt,1.0*sum(Mouseover)/sum(Impression) as AvgMouseCnt,1.0*sum(Engagement)/sum(Impression) as AvgEngCnt,1.0*sum(Interaction)/sum(Impression) as AvgIntCnt from countsTable group by click")

eventRates <- sqldf("select click,count(ID),1.0*sum(Impression)/count(ID) as AvgImpCnt,1.0*sum(Mouseover)/sum(Impression) as AvgMouseCnt,1.0*sum(Engagement)/sum(Impression) as AvgEngCnt,1.0*sum(Interaction)/sum(Impression) as AvgIntCnt from countsTable group by click")
print(eventRates)
print(cor(eventRates))

#cor(ratesTable[, 2:5])
#summary(ratesTable[, 2:5])
#print(pca)
#summary(pca)
#plot(pca, type="l")
#pca

hist(countsTable$Impression,breaks=200,xlim=range(0,500))
hist(countsTable$click,breaks=15,xlim=range(0,15))

#EOF
