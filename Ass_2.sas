/*********************************************
Assignment 2
Mikaela Taylor
7/13/2023
STA 551: Foundations in Data Science
 **********************************************/
*/defining the library shortcut name*/;
LIBNAME sql "/home/u63488758/Sta 551/Assignment 2 Stuff";
*/bringing in the data set from github;
filename dat01 url 'https://github.com/MT24STA490/STA-551/blob/13e8eaba3cab04b5f973ec1af4abe0653d0c35ac/BankMarketingCSV.csv';
*/bringing in the data set from the folder;

PROC IMPORT OUT=SQL.data 
		DATAFILE="/home/u63488758/Sta 551/Assignment 2 Stuff/BankMarketingCSV.csv" 
		DBMS=CSV REPLACE;
	GETNAMES=YES;
	GUESSINGROWS=MAX;
	DATAROW=2;
RUN;

*/getting a look at the data set;

proc contents data=sql.data;
run;

*looking at frequency tables for catigorical variables;

PROC FREQ DATA=sql.data;
	TABLES marital education default housing loan contact month poutcome;
RUN;

****AGE***;
*/finding any missing observations for age*/;

PROC SQL;
	SELECT nmiss(age) FROM sql.data quit;
	*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE age IS NULL;
QUIT;

*/looking at a boxplot for numerical variables, trying to find outliers.
There were quite a few outliers found in age, but they all seemed like plausible observations
all look like they are 70+*/;
ods output sgplot=boxplot_data;

proc sgplot data=sql.data;
	vbox age;
run;

*testing for normality, not normal;

proc univariate data=sql.data normal;
	var age;
	histogram age;
run;

*transforming data to look more normal and get rid of right skew;

data sql.transformed_data;
	set sql.data;
	transformed_age=log(age);
run;

*new age variables looks more normal;

proc univariate data=sql.transformed_data normal;
	var transformed_age;
	histogram transformed_age;
run;

***JOB***;
*/finding any missing observations for job*/;

PROC SQL;
	SELECT nmiss(job) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE job IS NULL;
QUIT;

***MARITAL***;
*/finding any missing observations for marital*/;

PROC SQL;
	SELECT nmiss(marital) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE marital IS NULL;
QUIT;

***EDUCATION***;
*/finding any missing observations for education*/;

PROC SQL;
	SELECT nmiss(education) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE education IS NULL;
QUIT;

***DEFAULT***;
*/finding any missing observations for default*/;

PROC SQL;
	SELECT nmiss(default) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE default IS NULL;
QUIT;

***BALANCE***;
*/finding any missing observations for balance*/;

PROC SQL;
	SELECT nmiss(balance) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE balance IS NULL;
QUIT;

*/looking at a boxplot for numerical variables, trying to find outliers.Many outliers 
found in balance above and below*/;
ods output sgplot=boxplot_data;

proc sgplot data=sql.data;
	vbox balance;
run;

proc univariate data=sql.data normal;
	var balance;
	histogram balance;
run;

*transforming data by cube root to look more normal and get rid of right skew;

data sql.transformed_data;
	set sql.transformed_data;
	transformed_balance=(balance)**(1/3);
run;

*new balance variables looks more normal;

proc univariate data=sql.transformed_data normal;
	var transformed_balance;
	histogram transformed_balance;
run;

***HOUSING***;
*/finding any missing observations for housing*/;

PROC SQL;
	SELECT nmiss(housing) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE housing IS NULL;
QUIT;

***LOAN***;
*/finding any missing observations for loan*/;

PROC SQL;
	SELECT nmiss(loan) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE loan IS NULL;
QUIT;

***CONTACT***;
*/finding any missing observations for contact*/;

PROC SQL;
	SELECT nmiss(contact) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE contact IS NULL;
QUIT;

***DAY***;
*/finding any missing observations for day*/;

PROC SQL;
	SELECT nmiss(day) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE day IS NULL;
QUIT;

*/ no outliers found in day varaible*;
ods output sgplot=boxplot_data;

proc sgplot data=sql.data;
	vbox day;
run;

***MONTH***;
*/finding any missing observations for month*/;

PROC SQL;
	SELECT nmiss(month) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE month IS NULL;
QUIT;

***DURATION***;
*/finding any missing observations for duration*/;

PROC SQL;
	SELECT nmiss(duration) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE duration IS NULL;
QUIT;

*/many outliers found in duration, mostly above 500*/;
ods output sgplot=boxplot_data;

proc sgplot data=sql.data;
	vbox duration;
run;

*dividing duration by 60 to go by minutes rather then seconds;

PROC SQL;
	CREATE TABLE sql.new_duration_var AS SELECT *, round(duration/60.0, 0.1) AS 
		duration_min FROM sql.transformed_data;
QUIT;

*testing for normality, not normal;

proc univariate data=sql.new_duration_var normal;
	var duration_min;
	histogram duration_min;
run;

*transforming data to look more normal and get rid of right skew;

data sql.transformed_data;
	set sql.new_duration_var;
	transformed_duration_min=log(duration_min);
run;

*new duration variables looks more normal;

proc univariate data=sql.transformed_data normal;
	var transformed_duration_min;
	histogram transformed_duration_min;
run;

***CAMPAIGN***;
*/finding any missing observations for campaign*/;

PROC SQL;
	SELECT nmiss(campaign) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE campaign IS NULL;
QUIT;

*/many outliers found in campaign, mostly upward outliers, looks like above 5ish*/;
ods output sgplot=boxplot_data;

proc sgplot data=sql.data;
	vbox campaign;
run;

*testing for normality, not normal, skewed right;

proc univariate data=sql.data normal;
	var campaign;
	histogram campaign;
run;

*transforming data to look more normal and get rid of right skew;

data sql.transformed_data;
	set sql.transformed_data;
	transformed_campaign=(campaign)**(1/2);
run;

*new duration variables looks the same;

proc univariate data=sql.transformed_data normal;
	var transformed_campaign;
	histogram transformed_campaign;
run;

***PDAYS***;
*/finding any missing observations for pdays*/;

PROC SQL;
	SELECT nmiss(pdays) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE pdays IS NULL;
QUIT;

*/resulted in mostly outliers*/;
ods output sgplot=boxplot_data;

proc sgplot data=sql.data;
	vbox pdays;
run;

*testing for normality, not normal, skewed right, maybe grouping would work?sparse groups;

proc univariate data=sql.data normal;
	var pdays;
	histogram pdays;
run;

data sql.transformed_data;
	set sql.transformed_data;

	if pdays=-1 then
		grp_pdays=-1;

	if pdays ge 0 then
		grp_pdays=1;
run;

proc univariate data=sql.transformed_data normal;
	var grp_pdays;
	histogram grp_pdays;
run;

***PREVIOUS***;
*/finding any missing observations for previous*/;

PROC SQL;
	SELECT nmiss(previous) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE previous IS NULL;
QUIT;

*a couple outliers found in previous variable;
ods output sgplot=boxplot_data;

proc sgplot data=sql.data;
	vbox previous;
run;

*testing for normality, not normal, skewed right, maybe grouping would work?;

proc univariate data=sql.data normal;
	var previous;
	histogram previous;
run;

*grouping previous data;

data sql.transformed_data;
	set sql.transformed_data;

	if previous=0 then
		grp_previous=0;

	if previous > 0 then
		grp_previous=1;
run;

proc univariate data=sql.transformed_data normal;
	var grp_previous;
	histogram grp_previous;
run;

***POUTCOME***;
*/finding any missing observations for poutcome*/;

PROC SQL;
	SELECT nmiss(poutcome) FROM sql.data;
quit;

*/looking for null observations;

PROC SQL;
	SELECT * FROM sql.data WHERE poutcome IS NULL;
QUIT;

**************PAIRWISE COMPARISONS*************;

proc sgscatter data=sql.transformed_data;
	matrix transformed_age transformed_duration_min day transformed_balance 
		campaign / group=y diagonal=(histogram kernel);
run;

*looking at frequency tables and pairwise compaisons for catigorical variables;

PROC FREQ DATA=sql.transformed_data;
	TABLES marital*y education*y default*y housing*y loan*y contact*y month*y 
		poutcome*y grp_previous*y grp_pdays*y/ norow chisq plots=MOSAIC;
RUN;