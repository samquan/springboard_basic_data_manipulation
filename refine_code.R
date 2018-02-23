# packages using
library(dplyr)
library(tidyr)
library(dummies)

# load the data
df <- read.csv("refine_original.csv")

# clean up brand names (philips, akzo, van houten, unilever)
df <- df %>% 
  mutate(company = gsub(pattern = "p.*|P.*|f.*", replacement = "philips", x = company)) %>%
  mutate(company = gsub(pattern = "ak.*|Ak.*|AK.*", replacement = "akzo", x = company)) %>%
  mutate(company = gsub(pattern = "Va.*|va.*", replacement = "van houten", x = company)) %>%
  mutate(company = gsub(pattern = "un.*|Un.*", replacement = "unilever", x = company))

# separate product and code number 
df <- separate(df, Product.code...number, c("product_code", "product_number"))

# add "product_category" based off product_code (p = Smartphone, v = TV, x = Laptop, q = Tablet)
df$product_category[df$product_code=="p"] <- "Smartphone"
df$product_category[df$product_code=="v"] <- "TV"
df$product_category[df$product_code=="x"] <- "Laptop"
df$product_category[df$product_code=="q"] <- "Tablet"

# create "full_address" that links (address, city, country)
df <- unite(df, "full_address", address, city, country, sep = ", ", remove = FALSE)

#Create dummy binary variables for each of them with the prefix company_ and product_ 
df <- cbind(df, dummy(df$company, sep = "_")) 
df <- cbind(df, dummy(df$product_category, sep = "_"))
df <- df %>%
        rename(company_philips = df_philips, 
               company_akzo = df_akzo, 
               company_van_houten = 'df_van houten', 
               company_unilever = df_unilever,
               product_smartphone = df_Smartphone,
               product_laptop = df_Laptop,
               product_tablet = df_Tablet,
               product_tv = df_TV)

# export file
write.csv(df, file = "refine_clean.csv")