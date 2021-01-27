install.packages(c("ggplot2","dplyr","readxl","doSNOW","caret","ranger","quanteda"))
library(ggplot2)
library(dplyr)
library(readxl)
library(doSNOW)
library(caret)
library(ranger)
library(quanteda)

combo = read_xlsx("path of train-test combo.xlsx", sheet = "Sheet1")
#change line of code here to import downloaded copy of "train-test combo.xlsx"

combo$Pclass = as.factor(combo$Pclass)
combo$Sex = as.factor(combo$Sex)
combo[which(is.na(combo$Embarked)),"Embarked"] = "S"
#2 missing values in embarked, assingned most popular location

combo$Embarked = as.factor(combo$Embarked)
combo$Family = combo$SibSp + combo$Parch
combo$HusbandAboard = as.factor(combo$HusbandAboard)
combo$WifeAboard = as.factor(combo$WifeAboard)
combo = as.data.frame(combo)

combo.tokens = tokens(combo$Name, what = "word",
                      remove_numbers = TRUE, remove_punct = TRUE,
                      remove_symbols = TRUE, split_hyphens = TRUE)
#tokenizing all "words" from combo$Name, removing numbers, punctuation, symbols, and separating hyphenated "words"

combo.tokens = tokens_tolower(combo.tokens)
#lower case all tokens

combo.tokens = dfm(combo.tokens, tolower = FALSE)
#create bag of words

combo.tokens= as.matrix(combo.tokens)
#create bag of words as matrix

combo.tokens[which(combo.tokens[,"mme"]==1),"mrs"] = 1
#Adding 1 in "mrs" column when French abbreviation meaning "Mrs" in combo$Name

combo.tokens[which(combo.tokens[,"mlle"]==1 ),"miss"] = 1
#Adding 1 in "miss" column when French abbreviation meaning "Miss" in combo$Name

combo.tokens[which(combo.tokens[,"ms"]==1 ),"miss"] = 1
#Adding 1 in "miss" column when "ms" in combo$Name

combo = cbind(combo,combo.tokens[,c("miss","mrs","master")])
combo$mrs[which(combo$mrs > 1)] = 1
combo$miss[which(combo$miss > 1)] = 1
combo$master[which(combo$master > 1)] = 1

combo[200,"miss"] = 0 
combo[428,"miss"] = 0 
combo[760,"miss"] = 1
combo[797,"miss"] = 1 
combo[1306,"miss"] = 1 
#mannually changing these entries that were female with no titles

combo$mrs = as.factor(combo$mrs)
combo$miss = as.factor(combo$miss)
combo$master = as.factor(combo$master)

mastertix = unique((combo %>% filter(master == 1))$Ticket)
combo$mstrgrp = ifelse(combo$Ticket %in% mastertix, 1, 0)
combo$mstrgrp = as.factor(combo$mstrgrp)

combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 0 & combo$Pclass == 1),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 0 & Pclass == 1 ))$Age,na.rm = TRUE)
combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 0 & combo$Pclass == 2),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 0 & Pclass == 2))$Age,na.rm = TRUE)
combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 0 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 0 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for males with 0 family 

combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 1 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 1 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for males with 1 family 

combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 2 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 2 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for males with 2 family 

combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 3 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 3 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for males with 3 family 

combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 4 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 4 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for males with 4 family 

combo[which(is.na(combo$Age) & combo$Sex == "male" 
            & combo$Family == 10 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "male"& Family == 10 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for males with 10 family 

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 0 & combo$Pclass == 1),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 0 & Pclass == 1))$Age,na.rm = TRUE)
combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 0 & combo$Pclass == 2),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 0 & Pclass == 2))$Age,na.rm = TRUE)
combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 0 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 0 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for single females with 0 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 1 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 1 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for single females with 1 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 2 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 2 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for single females with 2 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 3 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 3 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for single females with 3 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 4 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 4 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for single females with 4 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$miss == 1
            & combo$Family == 10 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & miss == 1 & Family == 10 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for single females with 10 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 0 & combo$Pclass == 1),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 0 & Pclass == 1))$Age,na.rm = TRUE)
combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 0 & combo$Pclass == 2),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 0 & Pclass == 2))$Age,na.rm = TRUE)
combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 0 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 0 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for married females with 0 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 1 & combo$Pclass == 1),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 1 & Pclass == 1))$Age,na.rm = TRUE)
combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 1 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 1 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for married females with 1 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 2 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 2 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for married females with 2 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 3 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 3 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for married females with 3 family

combo[which(is.na(combo$Age) & combo$Sex == "female" & combo$mrs == 1
            & combo$Family == 4 & combo$Pclass == 3),6] = 
  mean((combo %>% filter(Sex == "female" & mrs == 1 & Family == 4 & Pclass == 3))$Age,na.rm = TRUE)
#imputing missing age for married females with 4 family

combo[which(is.na(combo$Age) &  combo$Family == 10),6] = mean((combo %>% filter(Family == 10))$Age,na.rm = TRUE)
#imputing missing age for married females with 10 family

combo[which(is.na(combo$Fare)),10] = 
  mean((combo %>% filter(Pclass == 3 & GrpSz == 1 & mstrgrp == 0))$Fare, na.rm = TRUE)
#imputing 1 missing fare

combo$AgeBin = ifelse(combo$Age <= 15,1,ifelse(combo$Age <= 30,2,ifelse(combo$Age <= 45,3,ifelse(combo$Age <= 60,4,5))))
combo$AgeBin = as.factor(combo$AgeBin)

combo$FareScl = scale(combo$Fare)

titanic = combo %>% filter(Survived %in% c(0,1))
holdout = combo %>% filter(is.na(Survived))

titanic$Survived = as.factor(titanic$Survived)
levels(titanic$Survived) <- c("Dead","Survived")

titanic = titanic[,c(2,3,5,13,16:20,23,24)]
#training dataset with the following columns after variable selection
# [1] "Survived" "Pclass"   "Sex"      "GrpSz"    "Top"      "Rear"     "Family"   "miss"    
# [9] "mrs"      "AgeBin"   "FareScl" 
holdout = holdout[,c(1,2,3,5,13,16:20,23,24)]
#holdout dataset to predict on with the same columns as the tranind dataset
#with the exception of including the passengerID for verification through kaggle

model.specs = data.frame(matrix(NA, nrow = 9,ncol = 4))
colnames(model.specs) = c("model","ntree","mtry","node_size")
model.specs[1,]=c(1,250,5,5)
model.specs[2,]=c(2,200,6,5)
model.specs[3,]=c(3,250,6,5)
model.specs[4,]=c(5,100,5,5)
model.specs[5,]=c(9,150,5,5)
model.specs[6,]=c(10,150,5,15)
model.specs[7,]=c(13,200,5,15)
model.specs[8,]=c(14,100,6,15)
model.specs[9,]=c(15,250,6,25)
#9 most promising random forest models to cross validate 

cl = makeCluster(3, type = "SOCK")
registerDoSNOW(cl)
#using 3 processors to test models in parallel

metrics = data.frame(matrix(NA,ncol = 4))
colnames(metrics) = c("Model","Accuracy","Sensitivity","Specificity")
j = 1
i = 1
while(i<=180) {
  set.seed(i)
  indexes = sample(1:nrow(titanic),0.7*nrow(titanic),replace = FALSE)
  train = titanic[indexes,]
  test = titanic[-indexes,]
  
  model <- ranger(
    formula         = Survived ~ .,
    data            = train,
    num.trees       = model.specs[j,2],
    mtry            = model.specs[j,3],
    min.node.size   = model.specs[j,4],
    seed = i,
    sample.fraction = 1,
    importance      = 'impurity'
  )
  preds = predict(model,test)
  metrics[i,1] = j
  metrics[i,2] = sum(diag(confusionMatrix(preds$predictions,test$Survived)$table))/sum(confusionMatrix(preds$predictions,test$Survived)$table)
  metrics[i,3] = confusionMatrix(preds$predictions,test$Survived)$table[1,1]/sum(confusionMatrix(preds$predictions,test$Survived)$table[,1])
  metrics[i,4] = confusionMatrix(preds$predictions,test$Survived)$table[2,2]/sum(confusionMatrix(preds$predictions,test$Survived)$table[,2])  
  
  print(i)
  if(i%%20 == 0){j = j + 1}
  i = i + 1
}
#loop to use a 70/30 split of training data to train and test each model 20 times
stopCluster(cl)
#ending parallel processing

ggplot(metrics, aes(x = as.factor(Model),y = Accuracy))+geom_boxplot()+
  labs(title = "Model Accuracy", subtitle = "Each model trained and tested 20 times", x = "Model \n(see dataframe model.specs for parameters)")
metrics %>% group_by(Model) %>%
  summarize(
    AvgAcc = mean(Accuracy),
    MedAcc = median(Accuracy),
    Min = min(Accuracy),
    Max = max(Accuracy),
    Range = max(Accuracy) - min(Accuracy),
    Var = var(Accuracy),
    CV = sqrt(var(Accuracy))/mean(Accuracy)
  ) %>% arrange(desc(MedAcc))
#Model 1 was found to be the most accurate in predicting the fate of the passengers in the holdout set
#Model 1 predicted which passengers survived or not with 76% accuracy

model <- ranger(
  formula         = Survived ~ .,
  data            = titanic,
  num.trees       = model.specs[1,2],
  mtry            = model.specs[1,3],
  min.node.size   = model.specs[1,4],
  seed = i,
  sample.fraction = 1,
  importance      = 'impurity'
)
holdout$Survived = predict(model,holdout[,3:12],type = "response")$prediction
holdout$Survived = as.character(holdout$Survived)
holdout$Survived[which(holdout$Survived == "Dead")] = 0
holdout$Survived[which(holdout$Survived == "Survived")] = 1
write.csv(holdout[,c(1,2)],"path to save csv of prediction results")
#update path to write prediction results

imps = data.frame(names(model$variable.importance),as.numeric(model$variable.importance))
colnames(imps) = c("variable", "value")
imps = imps %>% arrange_(~ desc(value))
imps = as.data.frame(imps)
ggplot(imps, aes(reorder(variable, value), value))+
  geom_col()+
  labs(title = "Variable Importance",y = "Importance",x = "Variable")+
  coord_flip()
#Variable Importance of predictors of random forest model 1

