/*make sure to export demography and death to your personal directory

These are common file names for VRDC users!
Do not overwrite something important!

*/


/*if the files are indexed,proc sort will not work without FORCE; which is fine really 
proc sort 
data=<userDIR>.demographic;
by patid;run;
proc sort 
data=<userDIR>.DEATH;
by patid;run;
*/

data work.OMOP_Person_;
merge 
<userDIR>.death (in=b)
<userDIR>.demographic(in=a);
by patid;
run;
proc contents data=work.omop_person_;

data <userDIR>.OMOP_Person_Table
(keep=
personid
gender_concept_id
year_of_birth
month_of_birth
day_of_birth
birth_date_time
death_date_time
race_concept_id
ethnicity_concept_id
location_id
provider_id
care_site_id
person_source_value
gender_source_value
gender_source_concept_id
race_source_value
race_source_concept_id
ethnicity_source_value
ethnictry_source_concept_id)
;
set
work.omop_person_;
personid=PATID;
if sex="F" then gender_concept_id=8532;
if sex="M" then gender_concept_id=8507;
if sex="U" then gender_concept_id=8551;
year_of_birth=year(BIRTH_DATE);
month_of_birth=month(BIRTH_DATE);
day_of_birth=day(BIRTH_DATE);
birth_date_time="NA";
death_date_time=DEATHDT;
if RACE=0 then race_concept_id=0;
if RACE=1 then race_concept_id=1;
if RACE=2 then race_concept_id=2;
if RACE=3 then race_concept_id=3;
if RACE=4 then race_concept_id=4;
if RACE=5 then race_concept_id=5;
if Hispanic='Y' then ethnicity_concept_id=38003563;
if Hispanic='N' then ethnicity_concept_id=38003564;
location_id=ZIP;
provider_id="NA";
care_site_id="NA";
person_source_value=PATID;
gender_source_value=SEX;
gender_source_concept_id="NA";
race_source_value=RACE;
race_source_concept_id="NA";
ethnicity_source_value=Hispanic;
ethnictry_source_concept_id="NA";
format death_date_time date.;
run;
/*OMOP person table*/

