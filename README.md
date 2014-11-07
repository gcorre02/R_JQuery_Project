R_JQuery_Project
================
exploration of how to implement a simple financial analysis algorithm and create a full web service around it.

published at www.prtfanalyst.co.uk, currently the UI is massively incomplete.

a sample of the SP500 can be analysed by inputing a number for the sample of the sp500 to take and anyone can login with these credentials:

user: admin

password: pass



================

all JS, CSS and HTML logic is inside the folder /inst/www
all the R code is in the folder /R/
currently the DB access is done through an absolute address declared every time it is needed, it is setup according to how it is used in the server

======================
next update will address:

PRIORITY : implement a single function for DB access that handles opening and closing the connection and takes the operation as an argument

Plus a variety of UI issues
