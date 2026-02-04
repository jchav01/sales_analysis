# E-commerce Sales Analysis (Olist)

## Context
This project is part of a personal training program aimed at preparing for a
Data Analyst position.  
It focuses on analyzing a real-world e-commerce dataset to extract business insights
using SQL and Python.

## Dataset
The analysis is based on the **Olist Brazilian E-commerce Dataset** (Kaggle), which contains
information about:
- orders
- customers
- products
- sellers
- payments
- reviews
- delivery dates

The dataset reflects real-world data issues such as missing values, outliers,
and heterogeneous data sources.

## Tools & Technologies
- PostgreSQL (data storage and querying)
- SQL (joins, aggregations, CTEs, window functions)
- Python (pandas, matplotlib, scipy)
- Jupyter Notebook

## Business Questions
The project aims to answer the following questions:
- How does revenue evolve over time?
- Which product categories generate the most revenue?
- What is the distribution of order values?
- How long do deliveries take?
- Is there a relationship between order value, delivery costs, and customer satisfaction?

## Methodology
1. Import and structure CSV data into a PostgreSQL database  
2. Extract and aggregate data using SQL  
3. Perform exploratory data analysis (EDA) with Python  
4. Apply basic statistical methods to compare groups and identify relationships  
5. Visualize results and interpret findings from a business perspective  

## Key Results
- Revenue is highly concentrated: the top 10 product categories represent ~62% of total revenue.
- Order value distribution is strongly right-skewed (median ≈ 87, mean ≈ 138), indicating
  the presence of high-value outliers.
- Delivery times show high variability, with a median of ~10 days and 10% of deliveries
  exceeding ~23 days.
- A moderate positive correlation (~0.41) exists between order value and freight cost.
- Orders associated with negative customer reviews (scores 1–2) have a significantly higher
  average order value than those with positive reviews (scores 4–5), suggesting that
  higher-value orders may be more prone to customer dissatisfaction.

## Limitations
- The dataset ends in September 2018, which impacts the interpretation of recent trends.
- Extreme outliers in order value and delivery time influence aggregate metrics.

## Repository Structure
project_sales_analysis/
│
├── data/ # Raw CSV files
├── sql/
│ ├── import_all.sql # Database creation and data import
│ └── queries.sql # Analytical SQL queries
├── notebooks/
│ └── analysis.ipynb # Main analysis notebook
├── README.md
└── .gitignore

## How to Run
1. Import the CSV files into PostgreSQL using `sql/import_all.sql`
2. Run the SQL queries in `sql/queries.sql`
3. Open and execute `notebooks/analysis.ipynb`