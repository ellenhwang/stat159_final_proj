# Section Names
Rnws = $(wildcard report/sections/*.Rnw) 
report = report

# url of data
url_income = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-Treasury-Elements.csv

.PHONY = all data cleaning eda report ols ridge lasso pslr pcr

data: data/raw_data/income.csv

data/raw_data/income.csv: 
	curl $(url_income) > $@

cleaning:
	cd code; Rscript data_cleaning_script.R



#regression targets 
ols: 
	cd code/regression_scripts/; Rscript ols_script.R

ridge: data/RData/ridge.RData
data/ridge.RData: code/regression_scripts/ridge.R
	cd code/regression_scripts/; Rscript ridge.R

lasso: data/RData/lasso.RData
data/lasso.RData: code/lasso.R
	cd code/regression_scripts/; Rscript lasso.R

#pcr: data/RData/pcr.RData
#data/pcr.RData: code/scripts/pcr.R
#	cd code/regression_scripts/; Rscript pcr.R

#plsr: data/RData/plsr.RData
#data/plsr.RData: code/scripts/plsr.R
#	cd code/regression_scripts/; Rscript plsr.R
#eda: 
#	cd code; Rscript eda_script.R


#running regression targets at once
regressions: 
	make ols
	make ridge
	make lasso
	make pcr
	make plsr


#First generating compiled Rnw files and then generate pdf version of Rnw	
report: $(Rnws)
	cat $(Rnws) > report/report.Rnw #Automatic variable: the first target
	cd report; pdflatex report.Rnw; rm report.aux report.out report.log

#creating slides in html file based on Rmd file
slides: slides/presentation.html
slides/presentation.html: slides/presentation.Rmd
	cd slides; Rscript -e "library(rmarkdown); render('presentation.Rmd')"

session:
	bash code/session.sh