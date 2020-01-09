library(ff)
library(ffbase)
library(dplyr)
library(mongolite)

mcon <- mongo(collection="Hotel_Reviews_Collection", db="Rstudio", url="mongodb://localhost:27017")

dir_common <- paste0(getwd(),"/common")
options(fftempdir = dir_common)

# stringsAsFactors doesn't seem to work
hotel_data <- as.data.frame(mcon$find('{}'), stringsAsFactors=T)

format(object.size(hotel_data),"Mb")

# all character columns to factor, ff doesn't like char values
hotel_data <- mutate_if(hotel_data, is.character, as.factor)
str(hotel_data)

hotels.ff <- as.ffdf(hotel_data)

format(object.size(hotel_data),"Mb")
format(object.size(hotels.ff),"Mb")

pos_sub.ff <- hotels.ff$Positive_Review
neg_sub.ff <- hotels.ff$Negative_Review

format(object.size(hotel_data$Negative_Review),"Mb")
format(object.size(hotels.ff$Negative_Review),"Mb")


write.csv.ffdf(pos_sub.ff, "Review_pos.csv")
write.csv.ffdf(neg_sub.ff, "Review_neg.csv")

# remove all data
rm(hotels.ff)
rm(pos_sub.ff)
rm(neg_sub.ff)
rm(hotel_data)
rm(dir_common)
