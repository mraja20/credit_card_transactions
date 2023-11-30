# credit_card_transactions

Project Overview:

This project is a SQL-based analysis of the Credit card spends. The project aims to provide further
insights from the dataset.

The project consists of Three main parts:
1. Data Extraction/ Importation to MySQL Workbench
2. Exploratory Data Analysis (EDA)
3. Spending Insights

About the dataset :
This dataset offers a comprehensive overview of credit card transactions in India. The information spans
various aspects, including gender, card types, city-wise expenditures, and the types of expenses. The
dataset provides a valuable opportunity to uncover deeper trends in customer spending and explore
correlations between different data points, offering invaluable business intelligence. Analyzing this
diverse set of variables can paint a detailed picture of how money is being spent in India today using
credit cards.

Columns and their description:
Column name Description
City: The city in which the transaction took place. (Text)
Date: The date of the transaction. (Text)
Time: The time of the transaction corresponding to the date(text)
Card: Type The type of credit card used for the transaction. (Text)
Exp: Type The type of expense associated with the transaction. (Text)
Gender: The gender of the cardholder. (Text)
Amount: The amount of the transaction. (Number)



Data Extraction:
I started the project by obtaining the ‘Credit Card Spending Habits in India’ dataset in a compressed ZIP
file, which I subsequently extracted and converted into the CSV (Comma Separated Values) format.
Following this, I created a MySQL database and imported the dataset into it.

Exploratory Data Analysis :
Once the dataset had been successfully imported into MySQL workbench, I proceeded to write a series of
queries aimed at data preparation methods such as renaming the column names, modifying the data types
of columns, dropping unnecessary columns and handling null values.

Insights into Spending Patterns :

Subsequently, I wrote queries aimed at extracting KPIs and some valuable insights from the data. The full
data cleaning steps and queries are documented on my GitHub repository.
Here are some of the questions that I have answered .
1. Who does the most no of transactions (Males or Females) ?
2. Which card type is used most and least number of times ?
3. Find the 3 cities having the lowest number of transactions ?
4. Top 3 cities having the most number of transactions ?
5. What is the average transaction value during weekends and weekdays in each card type?
6. In which expense category does most and least number of transactions happen ?
7. Which expense type dominates most of the subcategories of Card Type ?
8. Which card type has the highest & lowest contribution to the total amount ?
9. Which Expense Type has the highest & lowest contribution to the total amount ?
10. Which gender type has the highest & lowest contribution to the total amount ?
11. Compute the contribution percentage number of males and females in each card type with respect to the total number of transactions.
12. During weekends which city has the highest total spend to total no of transactions ratio ?
13. Write a query to print 3 columns: city, highest_expense_type , lowest_expense_type.
14. Write a query to find the city which had the lowest percentage spent for gold card type.
15. Which card and expense type combination saw the highest month over month growth in Jan-2014 ?
16. Write a query to print the highest spend month and amount spent in that month for each card type.
17. Write a query to print top 5 cities with highest spends and their percentage contribution to total credit card spends and further within each city, find the percentage contribution of different card types.
18. Which city took the least number of days to reach its 500th transaction after the first transaction in that city ?
19. Write a query to print the transaction details for each card type when it reaches a cumulative of 10,00,000 total spends.


Conclusions :
In conclusion, the analysis of credit card spending in India has provided valuable insights into
consumer behavior and financial trends across the nation. The key findings can be summarized as
follows:

Summary of Key Findings : 
Our examination of the dataset revealed compelling patterns and trends within credit card
transactions. Notable figures and statistics have been identified, forming the basis for a
comprehensive understanding of spending habits in India. City-wise expenditures, gender-specific
spending, and prevalent card types were among the significant variables analyzed. The data
unveiled distinct patterns, showcasing how individuals across different demographics engage in
financial transactions.

Business Implications : 
The implications of our findings extend to practical applications for businesses operating in the
Indian market. Tailoring marketing strategies, product offerings, and financial services based on
demographic spending patterns can lead to more impactful and customer-centric approaches.

Limitations and Recommendations :
While our analysis provides valuable insights, it is important to acknowledge certain limitations.
Factors such as data constraints or assumptions made during the analysis should be considered.
Future research could focus on expanding data sources and refining methodologies to enhance the
depth and accuracy of future analyses.

Overall Significance :
I have answered some of the key business driven questions in credit card spendings in India by
writing SQL queries. The insights gained from answering these questions serves as a foundation
for strategic decision-making and business intelligence.
