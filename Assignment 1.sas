/*********************************************
  	Assignment 1: Merging Data Sets
  	Mikaela Taylor
  	7/6/23
	Tasks: Merging Pet Data Sets
     
**********************************************/
/*creating a library shortcut to access existing library*/
LIBNAME sql "/home/u63488758/Sta 551/Assignment 1 Stuff";


/* loading four data files from github using the url's*/

filename data1 url 'https://github.com/MT24STA490/STA-551/blob/main/PetsInfomation.csv';
filename data2 url 'https://github.com/MT24STA490/STA-551/blob/main/PetsOwners.csv';
filename data3 url 'https://github.com/MT24STA490/STA-551/blob/main/ProceduresDetails.csv';
filename data4 url 'https://github.com/MT24STA490/STA-551/blob/main/ProceduresHistory.csv';


/*importing data sets from SAS folder*/
PROC IMPORT OUT= SQL.info
            DATAFILE= "/home/u63488758/Sta 551/Assignment 1 Stuff/PetsInfomation.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
	 GUESSINGROWS = MAX;
     DATAROW=2; 
RUN;
/*importing data sets from SAS folder*/
PROC IMPORT OUT= SQL.owner
            DATAFILE= "/home/u63488758/Sta 551/Assignment 1 Stuff/PetsOwners.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
	 GUESSINGROWS = MAX;
     DATAROW=2; 
RUN;
/*importing data sets from SAS folder*/
PROC IMPORT OUT= SQL.details
            DATAFILE= "/home/u63488758/Sta 551/Assignment 1 Stuff/ProceduresDetails.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
	 GUESSINGROWS = MAX;
     DATAROW=2; 
RUN;
/*importing data sets from SAS folder*/
PROC IMPORT OUT= SQL.history
            DATAFILE= "/home/u63488758/Sta 551/Assignment 1 Stuff/ProceduresHistory.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
	 GUESSINGROWS = MAX;
     DATAROW=2; 
RUN;
/*counting how many observations there are in info dataset : 100*/
PROC SQL;
SELECT COUNT(*)
FROM sql.info;
QUIT;
/*counting how many observations there are in owner dataset: 89*/
PROC SQL;
SELECT COUNT(*)
FROM sql.owner;
QUIT;
/*counting how many observations there are in details dataset: 41*/
PROC SQL;
SELECT COUNT(*)
FROM sql.details;
QUIT;
/*counting how many observations there are in history dataset: 2284*/
PROC SQL;
SELECT COUNT(*)
FROM sql.history;
QUIT;

* sorting pet info data set by PetID in Ascending ordering;
PROC SQL;
SELECT *
FROM sql.info
ORDER BY PetID ASC;
QUIT;

* sorting pet history data set by PetID in Ascending ordering;
PROC SQL;
SELECT *
FROM sql.history
ORDER BY PetID ASC;
QUIT;

/*looking for null observations in info dataset under PetID: 0*/
PROC SQL;
SELECT *
FROM sql.info
WHERE PetID IS NULL;
QUIT;

/*looking for null observations in history dataset under PetID: 0*/
PROC SQL;
SELECT *
FROM sql.history
WHERE PetID IS NULL;
QUIT;

/*making proceduresubcode character for history*/
data sql.history1;
set sql.history;
prosubcode = put(ProcedureSubCode, 9.);
run;
proc print data = sql.history1;
run;

/*making proceduresubcode character for details*/
data sql.details1;
set sql.details;
prosubcode = put(ProcedureSubCode, 9.);
run;
proc print data = sql.details1;
run;

/*defining new key*/
PROC SQL;
CREATE TABLE sql.details_key AS
SELECT *, 
      ProcedureType||'-'||prosubcode AS Key
FROM sql.details1;
QUIT; 

/*defining new key*/
PROC SQL;
CREATE TABLE sql.hist_key AS
SELECT *,
       ProcedureType||'-'||prosubcode AS Key
FROM sql.history1;
QUIT; 

*full join between details and history data sets by key getting 2,284 observations;
PROC SQL;
CREATE TABLE sql.FULLTJOIN0 AS
SELECT *
FROM sql.hist_key AS A
FULL JOIN sql.details_key AS B
ON A.key = B.key;
QUIT;


/*inner join to get observations shared between info and history datasets by PetID*/
PROC SQL;
SELECT *
FROM sql.hist_key AS history
JOIN sql.info AS info
ON history.PetID = info.PetID;
QUIT;

*full join between info and history data sets by PetID getting 2,350 observations;
PROC SQL;
CREATE TABLE sql.FULLTJOIN1 AS
SELECT *
FROM sql.FULLTJOIN0 AS A
FULL JOIN sql.info AS B
ON A.PetID = B.PetID;
QUIT;


/*inner join to get observations shared between info and owner datasets by ownerID*/
PROC SQL;
SELECT *
FROM sql.info AS info
JOIN sql.owner AS owner
ON info.OwnerID = owner.OwnerID;
QUIT;

*full join between info and owner data sets by OwnerID getting 2,350 observations;
PROC SQL;
CREATE TABLE sql.FULLTJOIN2 AS
SELECT *
FROM sql.owner AS A
FULL JOIN sql.FULLTJOIN1 AS B
ON A.OwnerID = B.OwnerID;
QUIT;

*/ All of the information was maintained in the final data set as the inner joins showed 
how many observations each data set shared with eachother, and the fulljoins combined the 
data sets based on common variables.*/


