food <- read.csv("food_clean.csv")

df <- food

dim(df)
str(df)
summary(df)


#OLS
 


# categorical variables
df$traffic_level <- factor(df$traffic_level)
df$weather <- factor(df$weather)
df$courier_vehicle <- factor(df$courier_vehicle)
df$city <- factor(df$city)


#model 1
#Dependent var(Y) = deleivery_time_min
#Indeprndent var(X) = traffic_level 
#Other = control var 

model_delivery <- lm(
  delivery_time_min ~ traffic_level + distance_km + prep_time_min + 
    weather + courier_vehicle + city + hour,data = df)

summary(model_delivery)


#model 2 
#Dependent var(Y) = customer_rating
#Indeprndent var(X) = delivery_time_min
#Other = control var 
model_rating <- lm(
  customer_rating ~ delivery_time_min + distance_km + prep_time_min +
    traffic_level + weather + city + restaurant_category,data = df)

summary(model_rating)


