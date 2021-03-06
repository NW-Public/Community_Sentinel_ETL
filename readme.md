# Introduction
The Centers for Medicare and Medicaid Services (CMS) harmonizes, processes, reimburses and curates claims for a national insurance program (Medicare) and state based insurance programs (Medicaid) in the United States. Medicare and Medicaid is a major provider of payment for American healthcare. CMS claims can reveal complexities and produce ‘evidence based medicine’ grade findings for the American population. 

The Virtual Data Research Center (VRDC) is a virtual desktop environment where users can access encounter level claims for clinical services billed to CMS. The claims are accessed via a local SAS server native to the virtual environment. VRDC curates CMS claims in a format conducive to health economics research; not to clinical research. 

The Sentinel Initiative is a Food and Drug Administration project to harmonize clinical data (including claims) to improve pharmacovigilance and advance several FDA missions. A SAS program ETL was produced that transforms VRDC curated CMS claims into the Sentinel Common Data Model (SCDM). Sentinels’ common data model is a data standard that ensures analysis across datasets can be implemented easily by storing data from different sources and formats commensurately. The SAS ETL from VRDC to SCDM requires 32 gigabytes of ram (four is standard), batch processing rights and several SAS server permissions which are very rare among VRDC users. 

The Observational Health Data Sciences and Informatics (OHDSI) collaboration has produced a Common Data Model (CDM) for the standardization and analysis of multi-format clinical data for observational health research. The OHDSI CDM is an international standard for observational health research. 

This code is based on code provided here by Sentinel Operations Center (SOC): https://dev.sentinelsystem.org/projects/DCMS/repos/cms_medicare_ffs_datamart/browse/CMS-ETL-100pct  

Documentation link:
https://dev.sentinelsystem.org/projects/DCMS/repos/cms_medicare_ffs_datamart/raw/Medicare_Fee-For-Service_Data_Transformation_SCDM_Technical_Specifications.pdf?at=refs%2Fheads%2Fmaster

What this program does: This program implements the SAS ETL for VRDC to SCDM on a ‘non- elite’ machine and further transforms SAS SCDM ETL output to match the OMOP CDM. 


## Regular vs. enhanced account
The SOC code may requrie tweaks to make it run as regular VRDC user. Our code includes those tweaks.

Per https://www.sentinelinitiative.org/sentinel/surveillance-tools/software-packages-and-toolkits/centers-medicare-and-medicaid-services-cms-medicare, the required RAM is 32 GB and ability to use batch processing.




## Community

While the SOC code is static and not officialy maintained, we hope to incorporate any community contribution and have this code evolve. (here on github). Please contribute with your pull request.

### No support statement from SOC ETL
https://www.sentinelinitiative.org/sentinel/surveillance-tools/software-packages-and-toolkits/centers-medicare-and-medicaid-services-cms-medicare

>There is no mechanism for technical support by Duke University, the Sentinel Operations Center, ResDAC, CMS, or by the U. S. Food and Drug Administration (FDA) for use of this SAS program package.


# Steps to run the ETL
In order to run this program successfully several configuration steps are necessary.

## Step 1:  preparation


Download the code, upload the code to VRDC and save the code in a system folder on your local SAS server. The correct folder architecture is reproduced below:
```
Dua_######/etl/etl5/v1/programs
Dua_######/etl/etl5/v1/Final
Dua_######/etl/etl5/v1/Dev
Dua_######/etl/etl5/v1/Prelim
Dua_######/etl/etl5/v1/temp
Dua_######/etl/etl4/v1/Final
Dua_######/etl/etl4/v1/Dev
Dua_######/etl/etl4/v1/Prelim
```
The ##### should be your DUA number. VRDC has SAS server folders that users can create subdirectories within. Your final folders, final, dev, prelim and temp should live as sub-directories under the superior folders listed above. If you want to change the directories you must change program 002 as well.

Save the individual sas programs into the ‘programs’ folder or the scripts will not find the programs to run.

If you want to set the folder structure to run#1, version#1 you must configure 002_options_lib.sas under ETL-Related Macro Variable Assignments. Your folders must already exist or SAS will return an error! I highly recommend starting on ETL2 V2 at the earliest and creating a dummy directory. Depending on how your SAS instance is configured not finding the prior run may cause the program to crash. Please note SAS will not generate these directories sequentially or retrospectively. They must be hand generated each time. It is highly likely that the ‘set up’ of sentinel handles this in a pre-ETL step that was not provided with the Sentinel ETL SAS code. 

## Step 2: Configure programs pre-fixed from 00 to 02.

000_run_etl
Pick which ETL output products to make and specify where the programs live. 

001_etl_info
This program works by making a dummy table that describes the operations to be run and then interpreting the dummy table as if it were a set of instructions. In program 02, you can configure the dummy table and effectively submit instructions to the job itself. 
Instructions are described as a fixed file (the Master Summary Beneficiary File) that is populated as an annualized set. You declare which years of the file, duration of the observation months and a few other items. The parameters are described here: 
a. To run one model year erase all but one line, save the line that describes the MSBF for the desired year.
B. To run more than one year add the desired lines. 

You must specify this table input three times. In native SAS the CARDS statement should populate in the console as YELLOW highlighted text. The text block should not have a semi-colon on the same line as the highlighted yellow text, but right below it. The following is the appropriate syntax for two years:
```
datalines;
2010	1	12	ETL	MBSF.MBSF_ABCD_2010
2011	1	12	ETL	MBSF.MBSF_ABCD_2011
;/* ‘;’ not on the line above!*/
Run; /*you must do this twice more with two other dummy tables with different variables!*/
```
002_options_libs_sas:
You must configure the file paths, etl version, the previous file path to the previous version to match your configuration in Step 1. This should be the native configuration: Run ETL  5 v1, reference ELT4 version 1. If you do not reconfigure the native file paths and syntax should work. 



# Person table

- run demo, encounter and mortality  (community modified versions of those sas files)
- run OMOP person sas file

# Encouter table

We extended the ETL to preserve claim ID and placer of service. The outputed table has thus extra columns.
