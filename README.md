# Stat 159 Final Project - Providing Credit to Students

## Authors

Ellen Hwang, Joseph Simonian, Yoon Rho, and Hoon 

## File Structure

```
stat159_final_proj/
	README.md
	Makefile	
	LICENSE
	Session-info.txt
	.gitignore
	Data/
		README.md
		Data_raw/
			MERGED2014_15_PP.csv #have unzip code for 
		Data_cleaned/
			Clean_data.csv #generated from data_cleaning_script.R
		RData/
			lasso.RData
			ridge.RData
			ols.R#generated by ols_script.R
code/
	README.md
	data_cleaning_script.R(scaling, remove nulls)
	eda_script.R
	ols_script.R 
	regression_scripts/
		lasso.R (branch)
		ridge.R (branch)
	time_series_scripts/
		…
Shiny_app
	README.md
	shiny_app.R
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
	slides.Rmd # to generate using ioslides
	slides.html
images/
	README.md
	… # various images
```

## Steps

1. git clone the repository

2. cd into directory

3. run make all to execute all scripts and get all output

## Phony Targets

1. 
2. 
3. 


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


