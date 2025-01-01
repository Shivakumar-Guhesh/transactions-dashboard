# transactions-dashboard

This project is cross-platform application developed for providing insights about personal finance. 

Currently the approach is based on tracking transactions in an excel file. A python script which is scheduled to run daily load this into a local sqlite db. FastApi backend reads this database and provides required information to flutter frontend,

https://www.kubera.com/blog/financial-dashboard