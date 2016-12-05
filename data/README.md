This directory contains data files for STAT 159 Final project

Directory tree:
```
data/
	README.md
	raw_data/
		MERGED2014_15_PP.csv #have unzip code for 
		income.csv
	cleaned_data/
		clean_data.csv
		cdr3_tbl.csv
		cdr3_test.csv
		cdr3_train.csv
		rpy3yr_tbl.csv
		rpy3yr_test.csv
		rpy3yr_train.csv
		ts_data.csv
		NA_removed/
			cdr3_x.csv
			cdr3_y.csv
			cdr3_test_x.csv
			cdr3_test_y.csv
			cdr3_train_x.csv
			cdr3_train_y.csv
			rpy3yr_x.csv
			rpy3yr_y.csv
			rpy3yr_test_x.csv
			rpy3yr_test_y.csv
			rpy3yr_train_x.csv
			rpy3yr_train_y.csv
	RData/
		lasso.RData
		ridge.RData
		pcr.RData
		plsr.RData
		ols.R 
		tsa_data.RData
		ts_to_use.RData
```
```
Folders:
	cleaned_data: a subfolder containing cleaned data set
	raw_data: a subfolder containing all raw data 
	NA_removed: a subfolder containing data set NA values replaced with avg value

```
```
RData files:
	ridge.RData: contains  the value of lambda for the "best" model, the test MSE, and the "official" coefficients of the model on the full data set using the parameter chosen by cross-validation.bestlamda for ridge regression #generated from ridge.R
	lasso.RData: contains  the value of lambda for the "best" model, the test MSE, and the "official" coefficients of the model on the full data set using the parameter chosen by cross-validation.bestlamda for lasso regression #generated from lasso.R
	pcr.RData: contains the test MSE, and the "official" coefficients of the model on the full data set using the parameter chosen by cross-validation.bestlamda for pcr #generated from pcr.R
	plsr.RData: contains the test MSE, and the "official" coefficients of the model on the full data set using the parameter chosen by cross-validation.bestlamda for plsr #generated from plsr.R
	tsa_data.RData: Output of tsa.R. Includes rpy_upto_2017 data set, which consists of RPY3YR data from 2009 to 2014 with the predicted RPY3YR values from 2015 to 2017. Rownames of the data set are given UNITID of the schools as some schools share same name with different UNITIDs.
	ts_to_use.RData: Same data as ts_data.csv, but with two objects (names and rpy_allyr). names: Institution Names, UNITID, rpy_allyr: RPY3YR data from 2009 to 2014 (Note that rpy_allyr in this data file is in fact a subset of columns 3 to 8 from the data in ts_data.csv).

csv files:
	clean_data.csv: removed columns of the raw data set that had 95% or more NA values and manually picked out columns that are related to the client profile
	rpy3yr_train.csv: train data set for 3yr repayment
	rpy3yr_test.csv: test data set for 3yr repayment
	rpy3yr_tbl.csv: data set for 3yr repayment
	cdr3_train.csv: train data set for cdr3 
	cdr3_test.csv: test data set for cdr3
	cdr3_tbl.csv: data set for cdr3
	income.csv: raw data set for post-earnings
	MERGED2014_15_PP.csv: raw data set
	ts_data.csv: Prepped data for time series analysis (rpy_allyr). Columns: Institution Names, UNITID, RPY3YR data from 2009 to 2014


```


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-
width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license"
href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

AUTHOR: YOUNG HOON KIM, YOON JUNG RHO, ELLEN HWANG, JOSEPH SIMONIAN
