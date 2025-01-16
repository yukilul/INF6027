Analyzing Stock Trends and Predicting Risk：
The code analyzes Apple Inc.'s stock trends, calculates returns, and uses MACD to enhance predictions. It applies logistic regression to forecast stock defaults, evaluating model performance with accuracy and ROC analysis. Visualizations provide insights into trends and risks, supporting informed investment decisions.

Research questions:
Q1:What is the trend of Apple Inc.’s stock price over time?
Q2:Is it possible to calculate the daily return (up or down) on Apple stock?What is the trend of Apple's gains and losses from 2012-2022?
Q3:Do the daily returns of Apple’s stock exhibit any cyclic patterns?
Q4:What is the daily VAR under the 80% confidence interval for this stock?
Q5:How accurate is it to calculate some technical indicators like MACD and build logistic regression models to predict stock defaults?

Key findings:
1. Key Finding 1: The risk assessment method based on technical indicators has high prediction accuracy and provides an effective risk early warning tool for investors and financial institutions.
2. Key finding 2: Decomposing the logarithmic returns using the time series decomposition method, the analysis shows that Apple's returns have significant cyclical fluctuations, showing a consistent pattern of ups and downs within a given month or quarter.

Instructions for Running the code
1. Load Libraries and Data(e.g., TTR, caret, pROC)
2. Calculate and log returns
3. Calculate MACD and other technical indicators
4. Build Logistic Regression Model
5. ROC curve was generated for visual analysis
