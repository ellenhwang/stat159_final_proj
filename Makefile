.PHONY = all data cleaning eda report ols ridge lasso pslr pcr tsa clean

all: data cleaning regressions report slides session

# Section Names
Rnws = $(wildcard report/sections/*.Rnw)
report = report

# url of data
url_income = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-Treasury-Elements.csv

data: data/raw_data/non_null_cols.csv

data/raw_data/non_null_cols.csv: data/raw_data/CollegeScorecard_Raw_Data.zip
	cd code/data_cleaning; Rscript remove_null_columns.R

data/raw_data/CollegeScorecard_Raw_Data.zip:
	cd data/raw_data; wget https://ed-public-download.apps.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip; unzip CollegeScorecard_Raw_Data.zip
	cd data/raw_data; curl $(url_income) > income.csv

cleaning: data
	cd code/data_cleaning; Rscript data_cleaning_script.R
	cd code/data_cleaning; Rscript tsa_dataprep.R


eda: code/eda_script.R
	cd code; Rscript eda_script.R

#regression targets
ols: code/data_cleaning/data_cleaning_script.R
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
	cd code/regression_scripts; Rscript $@.R; mv Rplots.pdf ../../images/ts_plots.pdf


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
	cd report; Rscript -e "library(knitr); knit2pdf('report.Rnw', output = 'report.tex')"
	cd report; rm report.aux report.log report.out report.tex

#creating slides in html file based on Rmd file
slides: slides/presentation.html

slides/presentation.html: slides/presentation.Rmd
	cd slides; Rscript -e "library(rmarkdown); render('presentation.Rmd')"

tests:
	Rscript code/test_that.R

session:
	bash code/session.sh

clean:
	rm -f report/report.pdf report/report.Rnw
