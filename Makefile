Rnws = $(wildcard report/sections/*.Rnw) 
url_income = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-Treasury-Elements.csv

.PHONY = all data cleaning eda

data: data/raw_data/income.csv

data/raw_data/income.csv: 
	curl $(url_income) > $@

cleaning:
	cd code; Rscript data_cleaning_script.R



#regression targets 
ridge: data/ridge.RData
data/ridge.RData: code/ridge.R
	cd code/; Rscript ridge.R

lasso: data/lasso.RData
data/lasso.RData: code/lasso.R
	cd code/; Rscript lasso.R

#pcr: data/pcr.RData
#data/pcr.RData: code/scripts/pcr.R
#	cd code/scripts/; Rscript pcr.R

#plsr: data/plsr.RData
#data/plsr.RData: code/scripts/plsr.R
#	cd code/scripts/; Rscript plsr.R
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
report: report/report.Rnw report/report.pdf
report/report.Rmd: $(Rnws)
	cat $(Rnws) > $@ #Automatic variable: the first target
report/report.pdf: report/report.Rnw
	cd report; Rscript -e "library(rmarkdown); render('report.Rnw', 'pdf_document')"

#creating slides in html file based on Rmd file
slides: slides/presentation.html
slides/presentation.html: slides/presentation.Rmd
	cd slides; Rscript -e "library(rmarkdown); render('presentation.Rmd')"

session:
	bash code/session.sh