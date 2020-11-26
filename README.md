# HotelReviewMachineLearning

This project uses hotel reviews from an open source location. The positive and negative reviews are seperated in two CSV files and saved to a MongoDB instance.

## Goal
The goal is to load reviews from hotels of different cities and countries and show their ratings in an interactive map. Along with this is a implementation of the NaiveBayes machine learning alghorithm that decides if a written review (of your own input) is a positive or negative review. 

## MongoDB
For this project I'm using different queries in Mongo to determine the sentiment of reviews before using it in the application. This is done because the dataset consists of 515K reviews, retrieving all of it and processing it would be too much and would not help the algorithm either.

## Results 
Below is a overview of the different tests ran on different sizes of the data set.

```
# @Params 
# *pos = positive review must have higher user score than param
# *neg = negative review must have lower user score than param
# *limit = amount of reviews to get for both positive and negative reviews
# sparkNbTesting(pos, neg, limit)
# original
sparkNbTesting(9, 4, 10000) # "accuracy: 93.66%"

# increase the number for negative reviews because otherwise there are no 150000 negative reviews
sparkNbTesting(9, 5, 15000) # "accuracy: 93.9%" unexpected

# test for user score -- accuracy seems to increase for reviews with a high user score on negative reviews? that's weird
sparkNbTesting(9, 5, 10000) # "accuracy: 94.61%"
sparkNbTesting(9, 6, 10000) # "accuracy: 95.05%" very weird and unexpected
sparkNbTesting(9, 7, 10000) # "accuracy: 94.24%" thank god it goes down again
sparkNbTesting(9, 8, 10000) # "accuracy: 94.68%" I don't get it
sparkNbTesting(9, 9, 10000) # "accuracy: 94.68%" - again, it is possible the same dataset it retrieved for these parameters

# moving on to testing with higher amount of reviews - 30k
sparkNbTesting(9, 6, 15000) # "accuracy: 94.56%"
sparkNbTesting(9, 7, 15000) # "accuracy: 94.87%"
sparkNbTesting(9, 8, 15000) # "accuracy: 94.88%"
sparkNbTesting(9, 9, 15000) # "accuracy: 94.88%"

# lets go to 40k
sparkNbTesting(9, 5, 20000) # "accuracy: 94.25%"
sparkNbTesting(9, 6, 20000) # "accuracy: 94.87%"
sparkNbTesting(9, 7, 20000) # "accuracy: 94.91%"
sparkNbTesting(9, 8, 20000) # "accuracy: 95.09%"
sparkNbTesting(9, 9, 20000) # "accuracy: 95.09%"

# let's see what happens when i decrease the psotive number and leave negative at 8 as it had the highest accuracy across prev tests
sparkNbTesting(8, 8, 10000) # "accuracy: 94.51%"
sparkNbTesting(7, 8, 10000) # "accuracy: 94.43%"
sparkNbTesting(6, 8, 10000) # "accuracy: 94.43%"
sparkNbTesting(5, 8, 10000) # same, i will have to change the function as right now it's getting the same data

# try again but with new query for positive reviews, change is documented in NBTests.R
sparkNbTesting2(8, 8, 10000) # "accuracy: 92.41%"  ==============!!!!!Lowest achieved!!!!!============
sparkNbTesting2(7, 8, 10000) # no positive reviews below 7 due to sentiment in query, sentiment is based on the user score >= 8 i think..
                             # This is also why I get the same outcome for having a negative under 8 and 9, didn't think about that. 

# lets only test 8 / 9 /10 for pos reviews but increase number of reviews
# putting it on 9.9 will only retireve pos reviews with user score of 10
sparkNbTesting(9.9, 8, 10000) # "accuracy: 95.05%"
sparkNbTesting(9, 8, 10000) # "accuracy: 94.68%"
sparkNbTesting(8, 8, 10000) # "accuracy: 94.51%"

# lets go to 30k
sparkNbTesting(9.9, 8, 15000) # "accuracy: 95.38%"  ========!!!!!Highest yet achieved!!!!!=========
sparkNbTesting(9, 8, 15000) # "accuracy: 94.88%"
sparkNbTesting(8, 8, 15000) # "accuracy: 94.73%" it seems to decrease the accuracy when i lower the positive score

# lets go to 40k
sparkNbTesting(9.9, 8, 20000) # "accuracy: 95.02%"
sparkNbTesting(9, 8, 20000) # "accuracy: 95.09%"
sparkNbTesting(8, 8, 20000) # "accuracy: 94.76%"

# range: 92.41 - 95.38
```
