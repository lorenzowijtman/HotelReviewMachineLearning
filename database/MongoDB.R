mcon <- mongo(collection="Hotel_Reviews_Collection", db="Rstudio", url="mongodb://localhost:27017")

# aggregation to get the adresses of the hotels from the dataset, already unique values
dfAddress <- mcon$aggregate('[{"$group":{"_id":null, "addresses": {"$addToSet":"$Hotel_Address"}}}]')

# select the addresses list
addresses <- dfAddress$addresses[[1]]

# Find_specific_date <-mcone$find('{"Review_Date":{"$eq":"4/5/2017"}}')
'%!in%' <- function(x,y)!('%in%'(x,y))

comboDf <- data.frame(matrix(ncol = 2, nrow = 0))
colnames(comboDf) <- c("country", "city")

comboDf <- rbind(comboDf, data.frame(country="All", city="All"))

# get the different countries in data from the hotel adress string
# *1* Special case for United Kingdom, no other countries of two words existent in data set
for(string in (addresses)) {
  country <- word(string,-1)
  city <- word(string, -2)
  #*1*
  if(country == "Kingdom") {
    country <- paste(word(string,-2), word(string,-1), sep = " ")
    city <- word(string, -5)
    if(city %!in% comboDf$city) {
      comboDf <- rbind(comboDf, data.frame(country=country, city=city))
    }
  }

  if(city %!in% comboDf$city) {
    comboDf <- rbind(comboDf, data.frame(country=country, city=city))
  }
}


# retireves the hotels that belong to the country AND city, both are checked in case of city names in address of other country 
getHotels <- function(Country,City) {
  q <- '{"Hotel_Address": { "$regex": "^(?=.*Netherlands)(?=.*Amsterdam).*", "$options" : "i"}}'
  return (mcon$find(q))
}
