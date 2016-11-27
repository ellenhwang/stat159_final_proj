
url_income = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-Treasury-Elements.csv

.PHONY = all data

data: data/raw_data/income.csv

data/raw_data/income.csv: 
	curl $(url_income) > $@

#creating slides in html file based on Rmd file
slides: slides/presentation.html
slides/presentation.html: slides/presentation.Rmd
	cd slides; Rscript -e "library(rmarkdown); render('presentation.Rmd')"

session:
	bash code/session.sh