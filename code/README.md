This directory contains code files for STAT 159 Final project

Directory tree:
```
code/
	README.md
	eda_script.R
	session.sh
	session_info_script.R
	data_cleaning/
		data_cleaning_script.R
		tsa_dataprep.R
	regression_scripts/
		ols_script.R 
		lasso.R
		ridge.R
		pcr.R
		plsr.R
		tsa.R
	functions/
		functions.R
	tests/
		test_cleaning.R
	test_that.R

```

```
Code files:
	eda_script.R: Exploratory Data Analysis
	session_info_script.R: containg all the software versions and R's session information
	ols.R: ols regression
	lasso.R: lasso regression
	ridge.R: ridge regression
	pcr.R: pcr regression
	plsr.R: plsr regression
	test_cleaning.R: containing test_that code
	test_that.R: R file that runs tests
	session.sh: bash script file generating session_info.txt
	functions.R: file containing a funciton removing "PrivacySuppressed" and "NULL" of the Data to NA
	data_cleaning_script.R: a script that writes: rpy3yr_train.csv, rpy3yr_test.csv, rpy3yr_tbl.csv, cdr3_train.csv, cdr3_test.csv, cdr3_tbl.csv, clean_data.csv, cdr3_x.csv, cdr3_y.csv, cdr3_test_x.csv, cdr3_test_y.csv, cdr3_train_x.csv, cdr3_train_y.csv,	rpy3yr_x.csv, rpy3yr_y.csv, rpy3yr_test_x.csv, rpy3yr_test_y.csv, rpy3yr_train_x.csv, and rpy3yr_train_y.csv
	tsa.R: tsa.R file reads in ts_to_use.RData file and conducts time series analysis on all the schools included in rpy_allyr data set. It is set to produce a data set, rpy_upto_2017, which includes 6 years of 3 year repayment rate data and the three year projected repayment rates. This file writes out rpy_upto_2017 and top_100 files as tsa_data.RData.
	tsa_dataprep.R: tsa_dataprep.R file reads in the raw data from MERGED2009_10_PP.csv to MERGED2014_15_PP.csv, filters cleans data and drop schools if they are not included in any of the data set at least once. Eventually it writes rpy_allyr data set which consists of INSTNM, UNITID, 2009, 2010, 2011, 2012, 2013, 2014 as its columns. It writes ts_data.csv and ts_to_use.RData files (ts_to_use.RData file is created for users to use the data set more easily).
```

```
Folder: 
	Functions: Containing functions.R file
	Data_cleaning: containing code that cleans data for regression
	Test: containing test code
	regression_scripts: containing all the regression code
```
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-
width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license"
href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

AUTHOR: YOUNG HOON KIM, YOON JUNG RHO, ELLEN HWANG, JOSEPH SIMONIAN
