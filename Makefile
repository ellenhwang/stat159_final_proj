# Section Names
Rnws = $(wildcard report/sections/*.Rnw) 
report = report

# url of data
url_income = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-Treasury-Elements.csv

.PHONY = all data cleaning eda report ols ridge lasso pslr pcr tsa

data: 
	wget “https://ed-public-download.apps.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip”; unzip
	

data/raw_data/income.csv: 
	curl $(url_income) > $@

cleaning:
	cd code/data_cleaning; Rscript data_cleaning_script.R
	cd code/data_cleaning; Rscript tsa_dataprep.R


#regression targets 
ols: 
	cd code/regression_scripts; Rscript $@.R

ridge: code/data_cleaning/data_cleaning_script.R
	cd code/regression_scripts; Rscript $@.R

lasso: code/data_cleaning/data_cleaning_script.R
	cd code/regression_scripts; Rscript $@.R

pcr: code/data_cleaning/data_cleaning_script.R
	cd code/regression_scripts/; Rscript $@.R

plsr: code/data_cleaning/data_cleaning_script.R
	cd code/regression_scripts/; Rscript $@.R

tsa: code/data_cleaning/tsa_dataprep.R
	cd code/regression_scripts; Rscript $@.R

eda: code/eda_script.R
	cd code; Rscript eda_script.R


#running regression targets at once
regressions: 
	make ols
	make ridge
	make lasso
	make pcr
	make plsr
	make tsa


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

clean: 
	rm -f report/report.pdf report/report.Rnw