# Titanic-Survivor-Classification-Random-Forest
Titanic dataset, description, and R code used to create a random forest model to predict which passengers in the hold out set would survive the ship's sinking

## Intro:  
Hello! Thanks for reviewing my random forest model created in R to predict whether or not Titanic passengers in a blind holdout dataset would survive. I completed this project independently while attending a data science bootcamp from Data Science Dojo. Within my course my model was the third most accurate in predicting a passenger's fate within the holdout set. My model achieved an accuracy of 76%!  

Omar El-Ghirani  
oelghira@gmail.com  

## Brief R Code Description:  
To run the code the code on your own, you will need to download the "train-test combo" excel spreadsheet. The code uses this dataset to operate. Passengers without an entry in the second column (Survived) were in the blind holdout set that needed predicting. The code uses this merged form to create variables and fill in missing entries before separating the dataset into separate dataframes. **For brievity's sake this repository and code is meant to show some feature engineering and the final product, not the exploratory data analysis or hyperparameter tuning of the model.**  

## Variable/Column Definitions:  
**PassengerId:** Unique identifier of passenger  
**Survived:** Survival indicator.	0 = No, 1 = Yes  
**Pclass:** Ticket class. 1 = 1st, 2 = 2nd, 3 = 3rd  
**Name:** Passenger name   
**Sex:** male or female   
**Age:** Age in years  
**Sibsp:** Number of siblings/spouses aboard the Titanic  
**Parch:** Number of parents/children aboard the Titanic  
**Ticket:** Ticket number  
**Fare:** Passenger fare  
**Cabin:** Cabin number  
**Embarked:** Port of Embarkation. C = Cherbourg, Q = Queenstown,S = Southampton  
:arrow_up: given variables  
:arrow_down: created variables   
**GrpSz:** (Created in Excel) Number passengers with same ticket number  
**WifeAboard:** (Created in Excel) Indicator if passenger has wife aboard   
**HusbandAboard:**  (Created in Excel) Indicator if passenger has husband aboard    
**Top:** (Created in Excel from Titanic map of cabins) Measure of how high up on ship passenger cabin was  
**Rear:** (Created in Excel from Titanic map of cabins) Measure of how close to rear end of ship passenger cabin was    
**Family:** (Created with R code) Total family size aboard the Titanic    
**miss:** (Created with R code) Indicator if female passenger was not married      
**mrs:**  (Created with R code) Indicator if female passenger was married    
**master:** (Created with R code) Indicator if passenger had title of "Master" in name  
**mstrgrp:** (Created with R code) Indicator if passenger was part of a group with someone with the tite of "Master"  
**AgeBin:** (Created with R code) Age class. 1 = Age 0 to 15, 2 = Age 15 to 30, 3 = Age 30 to 45, 4 = Age 45 to 60, 5 = Age 60+  
**FareScl:** (Created with R code) Scaled passenger fare  

## Additional Resources:  
**Titanic deck plan referenced to create Top variable:** http://titanictimes.com/plans.htm  
**Titanic deck plan referenced to create Rear variable:** http://www.crismatec.com/python/pl/deck-plans-and-cabin-layouts_home-elements-and-style.jpg  





