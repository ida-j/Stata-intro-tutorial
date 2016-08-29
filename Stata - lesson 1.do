******** copyright Ida Johnsson, 2016. All right reserved.


* clear data from memory
clear all 

************************************************************************************************************************
****************                1. INTRODUCTION
************************************************************************************************************************

* Commands can be typed directly in the "Command" window or specified in a do-file.
* Notice that lines of code can be commented by using "*" or /* text */
/* You run the commands in a do-file by clicking on "Do" in the upper right corner.
 You can also execute all commands in a do-file by clicking cmd+shift+D (mac) or ctrl+shift+D (Windows)
 To exectute only selected commands, highlight them and click on Do or cmd+shift+D/ctrl+shift+D
 I strongly recommend writing all commands in a do-file, that way the results are easy to reproduce and change,
 and you don't have to type in everything. 
 Also, note that recent commands are stored in the "Review" window.*/

/* Log files allow you to save the output produced during a Stata session.
A log is specified with the command "log using logname".
In order to start a log there can't be a log file that is already open.
The commandn */
capture log close
/*closes any open logs.
"capture" is necessary because if you just run "log close" and there is no open log file,
Stata will signal an error. */


* (optional, useful for working with large data sets)
set mem 600m
set matsize 5000

* Tell Stata not to pause if the output doesn't fit in the Results window:
set more off


* set current directory, this is where the log and other output files will be stored
cd "~/Dropbox/TAing/Stata/"

* Specify log file, replace tells Stata to overwrite any existing files with the same name.
log using "log_lesson1", replace

************************************************************************************************************************
****************                2. LOADING  AND GENRATING DATA & SUMMARY STATISTICS
************************************************************************************************************************

* Stata has a number of built in data sets which can be accessed with the command "sysuse"
sysuse auto

* summary of all variables
summarize

* turn off log file, results between "log off" and "log on" won't be saved in the log file
log off 

* summary of selected variables
summarize mpg

* turn log file back on
log on

* detalied summary
summarize mpg, detail

****************** structure of Stata commands ******************************************************

* Most commands in Stata have the same structure:
* command conditions, options
* For example, in "summarize mpg, detail", "detail" is an option
* We can add a condition using "if"
summarize mpg if mpg>15, detail
summarize trunk if mpg>16
* etc
* This structure of Stata commands is clearly seen in the help files
* To get more information about a command type "help command"
* For example
help summarize
* try this with a few commands to get acquainted with the Stata syntax

* scatterplot
twoway scatter trunk weight

* scatterplot with fitted regression line
twoway (scatter trunk weight) (lfit trunk weight)

* This is a good source of plot examples in Stata along with codes that produce them
* http://www.ats.ucla.edu/stat/stata/library/GraphExamples/

****************** generating new variables

* We can generate variables using "gen" or "egen".
* gen is typically used for simple transformtion, for example

gen x1=mpg*2
gen x2= mpg*weight

* etc
* With "egen" we can perform more complex operations like
egen max_trunk = max(trunk)
egen newvar = rowmax(trunk weight)
* calculate average price by make
* 1. sort data
sort make 
* 2. calculate mean price by group
by make: egen mprice=mean(price)

* count observations in each group
by make: gen counter=_n
by make: egen nobs=max(counter)

* Since there is just one observation per make in the auto data, it is more interesting to look at a different data set
* Load lifeexp data, "clear" deletes the current auto data 
sysuse lifeexp, clear 
* look at data
browse
* As you can see, the region variable is blue, the country variable is red.
* Red variables are string variables, black and blue variables are numeric variables
* A blue variable is a numeric variable that is an encoded string variable, it means that a 
* number is assigned to each unique occurence of the string
* you can see the encoding by typing
codebook region

* You can encode the country variable by typing
encode country, gen(country_num)
codebook country_num

* calculate number of observations per region
sort region
by region: gen counter=_n
by region: egen nobs=max(counter)

* sort data
sort region
browse region counter nobs

****************** finding and installing packages
* There are many very useful packages that don't come with the standard installation of Stata
* For example, estout is a package that exports regression resutls to excel, latex etc

findit estout

/* scroll down to
 Web resources from Stata and other users

(contacting http://www.stata.com)

19 packages found (Stata Journal and STB listed first) */

/* click on

st0085_2 from http://www.stata-journal.com/software/sj14-2

and then click on

 (click here to install) */
 
* This installs the estout package

* I will demostrate how to use it in the next section  

************************************************************************************************************************
****************                2. ESTIMATION & SAVING OUTPUT
************************************************************************************************************************


**** basic regressions and options, saving regression output

* run an ols regression of life expectancy on GNP
reg lexp gnppc

* suppose we want to export multiple regression results to Excel
* then we need to store the estimates from each regression and export them using esttab

* 1. clear any stored estimates

eststo clear

reg lexp gnppc
* store estiamtes
eststo est1

reg popgrowth gnppc
eststo est2

* show both sets of results in the Results window
esttab est1 est2

* export results to Excel
esttab est1 est2 using results.csv, replace 


* Variable labels are very useful in plotting and reporting regression results
* In many commands, we can specify the option "label" after the comma
* so that Stata uses variable labels instead of variable names
* For example 
label variable safewater "Safe Water"


* compare to what you get if you use labels
esttab est1 est2 using results_with_varlabels.csv, replace label

* a nice description of the esttab command can be found here
* http://repec.org/bocode/e/estout/esttab.html#esttab010













capture log close
