# Stat 159 Final Project - Providing Credit to Students

## Authors

Ellen Hwang, Joseph Simonian, Yoon Rho, and Hoon Kim

## File Structure

```
stat159_final_proj/
	README.md
	Makefile	
	LICENSE
	session-info.txt
	.gitignore
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

	code/
		README.md
		data_cleaning/
			data_cleaning_script.R
			tsa_dataprep.R
		eda_script.R
		remove_NA_values.R
		session.sh
		session_info_script.R
		regression_scripts/
			ols_script.R 
			lasso.R
			tsa.R
			ridge.R
			pcr.R
			plsr.R
		functions/
			functions.R

	shiny_app/
		README.md
		app.R
		data/
			clean_data.csv
		rsconnect/
			shinyapps.io/
				wos_159/
					shiny_app.dcf
		server.R
		setup.R
		ui.R

	report/
		README.md
		report.pdf
		report.Rnw
			sections/
				00_abstract.Rnw
				01_introduction.Rnw
				02_data.Rnw
				03_methods.Rnw
				04_results.Rnw
				05_analysis.Rnw
				06_conclusion.Rnw

	slides/
		README.md
		presentation.Rmd 
		presentation.html

	images/
		README.md
		eda/
			#images generated by running eda_script.R
		# various images from regression models (more detailed description under images/README.md)
```

## Steps

1. git clone the repository

2. cd into directory

3. run make all to execute all scripts and get all output

## Phony Targets

all data tests eda ols ridge lasso pcr plsr regressions report slides session cleaning

1. all: eda regressions report

2. data: data/raw_data/income.csv
   data/raw_data/income.csv: 
		curl $(url_income) > $@

3. cleaning:
		cd code; Rscript data_cleaning_script.R

4. ols: 
		cd code/regression_scripts/; Rscript ols_script.R

5. ridge: data/RData/ridge.RData
   data/ridge.RData: code/regression_scripts/ridge.R
		cd code/regression_scripts/; Rscript ridge.R

6. lasso: data/RData/lasso.RData
   data/lasso.RData: code/lasso.R
		cd code/regression_scripts/; Rscript lasso.R

7. 	pcr: data/RData/pcr.RData
    data/pcr.RData: code/scripts/pcr.R
		cd code/regression_scripts/; Rscript pcr.R

8. plsr: data/RData/plsr.RData
   data/plsr.RData: code/scripts/plsr.R
		cd code/regression_scripts/; Rscript plsr.R

9. eda: code/eda_script.R
		cd code; Rscript eda_script.R

10. regressions: 
		make ols
		make ridge
		make lasso
		make pcr
		make plsr

11. report: $(Rnws)
		cat $(Rnws) > report/report.Rnw #Automatic variable: the first target
		cd report; pdflatex report.Rnw; rm report.aux report.out report.log

12. slides: slides/presentation.html
	slides/presentation.html: slides/presentation.Rmd
		cd slides; Rscript -e "library(rmarkdown); render('presentation.Rmd')"

13. session:
		bash code/session.sh


## License

This project involves producing software content (R code), as well as media content(narrative, and images).

All media content of this project is under a Creative Commons Attribution 4.0 International License. 


<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.


All the code content of this project is under MIT License

MIT License

Copyright (c) 2016 Ellen Hwang, Joseph Simonian, Yoon Rho, and Hoon Kim

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


