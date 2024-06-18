*This do-file includes the codes for data merging and preparation.

*Set working directory.
cd "C:\Users\Lab user\Desktop\UNU-WIDER STUDENTS 2024\DATA\PAYE RETURNS"

*#################################################
*Start by appending the PAYE datasets.
append using RESEARCHLAB_PAYE_RETURN_20130701_20140630 RESEARCHLAB_PAYE_RETURN_20140701_20150630 RESEARCHLAB_PAYE_RETURN_20150701_20160630 RESEARCHLAB_PAYE_RETURN_20160701_20170630 RESEARCHLAB_PAYE_RETURN_20170701_20180630 RESEARCHLAB_PAYE_RETURN_20180701_20190630 RESEARCHLAB_PAYE_RETURN_20190701_20200630 RESEARCHLAB_PAYE_RETURN_20200701_20210630 RESEARCHLAB_PAYE_RETURN_20210701_20220630

*Drop not needed variables to reduce the dataset size.
drop c_source_type c_return_no c_currentstationname c_tin_of_employee c_return_date c_returnfromdate c_returntodate sch1_housing_allowance sch1_transport sch1_medical sch1_leave sch1_over_time sch1_other_taxable_allow sch1_housing sch1_motor_vehicle sch1_domestic_servants sch1_other_taxable_benf sch1_allowable_deductions

*Destring month and year variables, again to reduce the dataset size.
destring(c_return_period_month), generate(PAYE_return_month)
drop c_return_period_month
destring(c_return_period_year), generate(PAYE_return_year)
drop c_return_period_year

*###################################################
*Merge the appended PAYE data with CIT data. This is a many-to-one merge. The data are merged with the unique firm identifier c_firm_id and fiscal year variable c_fy as key variables as they uniquely identify the firm-year observations in the CIT data. Keep using only the variables that are needed.
merge m:1 c_firm_id c_fy using "C:\Users\Lab user\Desktop\UNU-WIDER STUDENTS 2024\DATA\CIT\CIT PANEL 2014-2022.dta", keepusing(c_firm_id c_fy c_year c_reg_status c_currentsectormainactivity c_taxpayertype pl_y_totalsales pl_y_incometaxturnover pl_grossprofit pl_y_tot_other_income pl_profitbeforetax tagFullFinancialYear)

*###################################################
*Reduce the dataset size with encoding and destringing.

*Encode c_fy c_currentsectormainactivity c_reg_status and c_taxpayertype and drop the original variables.
encode(c_fy), generate(financial_year)
drop c_fy
order financial_year
encode(c_currentsectormainactivity), generate(section)
drop c_currentsectormainactivity
encode(c_reg_status), generate(firm_regstatus)
drop c_reg_status
encode(c_taxpayertype), generate(firm_taxpayertype)
drop c_taxpayertype

*################################################################
*Fallback A21-level for PAYE observations which are matched on some years and some years not.
generate section_fallback = section
sort c_firm_id section_fallback
replace section_fallback = section_fallback[_n-1] if missing(section_fallback) & c_firm_id[_n-1] == c_firm_id[_n] & _merge == 1
label values section_fallback section

*######################################################
*Clean data.

*Drop observations with tagPAYEdeducted == 1.
drop if tagPAYEdeducted == 1
*Drop zero or negative sch1_basic_salary entries.
drop if sch1_basic_salary < 0

*Drop observations with zero total annual wages for some financial year together with zero/negative sales or missing sales.
*First, create sum of yearly firm wages. If all values are missing for a year the variable is set to missing.
egen yearly_firm_wages = total(sch1_basic_salary), missing by(c_firm_id financial_year)
drop if (yearly_firm_wages == 0 & pl_y_incometaxturnover <= 0) | (yearly_firm_wages == 0 & missing(pl_y_incometaxturnover))

drop if yearly_firm_wages == 0

*Clean data further by dropping firm_year pairs that appear only in the CIT data since for these there is no wage information and hence no information on the number of workers either.
drop if _merge == 2


*################################################################
*Create a firm-year specific average wage.
egen monthly_firm_wages = total(sch1_basic_salary), missing by(c_firm_id financial_year PAYE_return_month)
egen avgsalary = mean(sch1_basic_salary) if monthly_firm_wages > 0, by(c_firm_id financial_year)
sort c_firm_id financial_year avgsalary
replace avgsalary = avgsalary[_n-1] if missing(avgsalary) & c_firm_id[_n-1] == c_firm_id[_n] & financial_year[_n-1] == financial_year[_n]

*#######################################################
*Create tags.
*Create tag for an unique firm-year-month combination.
egen firm_month_year_tag = tag(c_firm_id financial_year PAYE_return_month)

*Create tag for an unique firm-year combination.
egen firm_year_tag = tag(c_firm_id financial_year)

*Create a tag for an unique firm.
egen firm_tag = tag(c_firm_id)

*##############################################################
*Create variables for firm size.
*Calculate the monthly number of employees and store it into "firmsize_monthly".
egen firmsize_monthly = count(sch1_basic_salary), by(c_firm_id financial_year PAYE_return_month)
*This is the average firm size during the months it has reported PAYE entries.
egen firmsize_estimate = mean(firmsize_monthly) if firm_month_year_tag == 1, by(c_firm_id financial_year)
sort c_firm_id financial_year PAYE_return_month firmsize_estimate
replace firmsize_estimate = firmsize_estimate[_n-1] if missing(firmsize_estimate) & c_firm_id[_n-1] == c_firm_id[_n] & financial_year[_n-1] == financial_year[_n]

*##############################################################
*Create variables for the productivity percentile calculation.

*Create the headcount for labour productivity calculation.
egen firmsizeforproductivity = count(sch1_basic_salary), by(c_firm_id financial_year)
replace firmsizeforproductivity = firmsizeforproductivity / 12

*Create the labour productivity variable. The first one is the one currently used in the thesis results about labour productivity.
generate sales_per_worker = pl_y_incometaxturnover / firmsizeforproductivity
generate sales_per_worker_est = pl_y_incometaxturnover / firmsize_estimate

generate profits_per_worker = pl_grossprofit / firmsizeforproductivity
generate profits_per_worker_est = pl_grossprofit / firmsize_estimate

*Generate a variable that combines all income the firm generates.
generate income_per_worker = (pl_y_incometaxturnover + pl_y_tot_other_income) / firmsizeforproductivity

*Sector size per month and annual average for the A21-level sectors.
egen A21_sectorsize_monthly = count(sch1_basic_salary), by(financial_year PAYE_return_month section_fallback)
egen A21_sectorsize_annual = mean(A21_sectorsize_monthly), by(financial_year section_fallback)
replace A21_sectorsize_annual = round(A21_sectorsize_annual)

*Additional variables.
*On how many years firm appears in the panel:
egen reported_years = total(firm_year_tag), by(c_firm_id)
*How many reported PAYE years:
egen reported_years_PAYE = total(firm_month_year_tag), by(c_firm_id)
*How many reported CIT years:
egen reported_years_CIT = total(firm_month_year_tag) if _merge == 3, by(c_firm_id)

*Variables for the zero turnover firms.
*Count how many zero turnover year firm has:
egen countzeros = total(firm_year_tag == 1) if pl_y_incometaxturnover == 0 & sales_per_worker != ., by(c_firm_id) missing
sort c_firm_id countzeros
replace countzeros = countzeros[_n-1] if missing(countzeros) & c_firm_id[_n-1] == c_firm_id[_n]

*Tag firms with at least one zero turnover year.
egen zero = tag(c_firm_id) if pl_y_incometaxturnover == 0 

*Cumulative sales.
egen cumulative_sales = total(pl_y_incometaxturnover), by(c_firm_id) missing

*Miscancellous.
replace yearly_firm_wages = sum(sch1_basic_salary) if c_firm_id == "8ZNNmmNNZ8V9ZZXXZZ9V" & financial_year == 8

replace yearly_firm_wages = sum(sch1_basic_salary) if c_firm_id == "m8VNMMNV8mCZXZXXZXZC" & financial_year == 9

egen wsampletag = tag(c_firm_id) if section_fallback != . & section_fallback != 20 & section_fallback != 21

egen psampletag = tag(c_firm_id) if section_fallback != . & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover > 0 & sales_per_worker != .