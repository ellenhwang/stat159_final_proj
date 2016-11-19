
url_income = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-Treasury-Elements.csv

.PHONY = all data

data: data/raw_data/income.csv

data/raw_data/income.csv: 
	curl $(url_income) > $@