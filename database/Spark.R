
Sys.setenv(JAVA_HOME = "C:/Program Files/Java/jdk1.8.0_191")
library(sparklyr)
library(dplyr)
library(ggplot2)
library(DBI)

sc <- spark_connect(master = "local", version="2.0.0")

pos <- mcon$find('{"sentiment": 1, "Reviewer_Score": {"$gt" : 9}}', fields = '{"Positive_Review": true, "Reviewer_Score": true, "sentiment": true}', limit = 10000) 
pos$`_id` <- NULL
colnames(pos) <- c('review', 'score', 'sentiment')

neg <- mcon$find('{"sentiment": 0, "Reviewer_Score": {"$lt" : 4}}', fields = '{"Negative_Review": true, "Reviewer_Score": true, "sentiment": true}', limit = 10000)
neg$`_id` <- NULL
colnames(neg) <- c('review', 'score', 'sentiment')

df <- rbind(pos, neg)

# bring R datafrma to Spark
reviews_tbl <- copy_to(sc, df, name = "reviews_tbl", overwrite = T)

rm(pos)
rm(neg)
rm(df)

# db_drop_table(sc, "iris")


src_tbls(sc)


pipeline <- ml_pipeline(
  # Tokenize the input
  ft_tokenizer(sc, input_col = "review", output_col = "raw_tokens"),
  
  # Remove stopwords - https://en.wikipedia.org/wiki/Stop_words
  ft_stop_words_remover(sc, input_col = "raw_tokens", output_col = "tokens"),
  
  # Apply TF-IDF - https://en.wikipedia.org/wiki/Tf-idf
  ft_hashing_tf(sc, input_col = "tokens", output_col = "tfs"),
  ft_idf(sc, input_col = "tfs", output_col = "features"),
  ml_kmeans(sc, features_col = "features", init_mode = "random")
)

model <- ml_fit(pipeline, partitions$training)

# transform our data set, and then partition into 'training', 'test'
partitions <- reviews_tbl %>%
  sdf_random_split(training = 0.7, test = 0.3, seed = 1011)

model <- partitions$training %>%
  ml_linear_regression(response = "sentiment", features = c("review", "score"))

summary(model)

pred <- ml_predict(model, partitions$test) %>%
  collect


# partitions <- mtcars_tbl %>%
#   filter(hp >= 100) %>%
#   mutate(cyl8 = cyl == 8) %>%
#   sdf_partition(training = 0.5, test = 0.5, seed = 1099)

# fit a linear model to the training dataset
model <- partitions$training %>%
  ml_linear_regression(response = "mpg", features = c("wt", "cyl"))

model
summary(model)

options(java.parameters = "-Xmx8000m")

# Score the data
pred <- ml_predict(model, partitions$test) %>%
  collect

# Plot the predicted versus actual mpg
ggplot(pred, aes(x = mpg, y = prediction)) +
  geom_abline(lty = "dashed", col = "red") +
  geom_point() +
  theme(plot.title = element_text(hjust = 0.5)) +
  coord_fixed(ratio = 1) +
  labs(
    x = "Actual Fuel Consumption",
    y = "Predicted Fuel Consumption",
    title = "Predicted vs. Actual Fuel Consumption"
  )

spark_disconnect(sc)
