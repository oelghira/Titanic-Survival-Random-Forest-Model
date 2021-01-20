# Titanic-Survivor-Classification-Random-Forest
Titanic dataset, description, and R code used to create a random forest model to predict which passengers in the hold out set would survive the ship's sinking

## Intro:  
Hello! Thanks for reviewing my creation of a random forest model in R from a dataset of Titanic passengers to predict whether or not passengers in a blind holdout dataset would survive. I completed this project independently while attending a data science bootcamp from Data Science Dojo. Within my course, my model was the third most accurate in predicting a passenger's fate within the holdout set. My model achieved an accuracy of 76%!  

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
**GrpSz:**   	
**WifeAboard:**   
**HusbandAboard:**  	
**Top:**  
**Rear:**   
**Family:**  
**miss:**  
**mrs:**  
**master:**  
**mstrgrp:**  






