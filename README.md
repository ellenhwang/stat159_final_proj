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
		eda_script.R
		session.sh
		session_info_script.R
		data_cleaning/
			data_cleaning_script.R
			tsa_dataprep.R
		regression_scripts/
			ols_script.R 
			lasso.R
			tsa.R
			ridge.R
			pcr.R
			plsr.R
			tsa.R
		functions/
			functions.R
		tests/
			test_cleaning.R
		test_that.R

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


.PHONY = all data cleaning eda report ols ridge lasso pslr pcr tsa clean slides session clean

1. all: data cleaning regressions report slides session

2. data: data/raw_data/CollegeScorecard_Raw_Data.zip

   data/raw_data/CollegeScorecard_Raw_Data.zip:
		cd data/raw_data; wget https://ed-public-download.apps.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip; unzip CollegeScorecard_Raw_Data.zip
		cd data/raw_data; curl $(url_income) > income.csv
	
3. cleaning: 
		cd code/data_cleaning; Rscript data_cleaning_script.R
		cd code/data_cleaning; Rscript tsa_dataprep.R


4. eda: code/eda_script.R
		cd code; Rscript eda_script.R

5. ols: code/data_cleaning/data_cleaning_script.R
		cd code/regression_scripts; Rscript $@.R

6. ridge: code/data_cleaning/data_cleaning_script.R
		cd code/regression_scripts; Rscript $@.R

7. lasso: code/data_cleaning/data_cleaning_script.R
		cd code/regression_scripts; Rscript $@.R

8. pcr: code/data_cleaning/data_cleaning_script.R
		cd code/regression_scripts/; Rscript $@.R

9. plsr: code/data_cleaning/data_cleaning_script.R
		cd code/regression_scripts/; Rscript $@.R

10. tsa: code/data_cleaning/tsa_dataprep.R
		cd code/regression_scripts; Rscript $@.R; mv Rplots.pdf ../../images/ts_plots.pdf

11. regressions: 
		make ols
		make ridge
		make lasso
		make pcr
		make plsr
		make tsa


12. report: $(Rnws)
		cat $(Rnws) > report/report.Rnw #Automatic variable: the first target
		cd report; Rscript -e "library(knitr); knit2pdf('report.Rnw', output = 'report.tex')"
		cd report; rm report.aux report.log report.out report.tex

13. slides: slides/presentation.html
	slides/presentation.html: slides/presentation.Rmd
		cd slides; Rscript -e "library(rmarkdown); render('presentation.Rmd')"

14. session:
		bash code/session.sh

15. clean: 
		rm -f report/report.pdf report/report.Rnw
16. tests:
		Rscript code/test_that.R

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


