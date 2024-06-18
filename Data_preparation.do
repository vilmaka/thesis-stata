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
merge m:1 c_firm_id c_fy using "C:\Users\Lab user\Desktop\UNU-WIDER STUDENTS 2024\DATA\CIT\CIT PANEL 2014-2022.dta", keepusing(c_firm_id c_fy c_year c_reg_status c_currentsectormainactivity c_taxpayertype c_groupdescription pl_y_totalsales pl_y_incometaxturnover pl_grossprofit pl_y_tot_other_income pl_profitbeforetax tagFullFinancialYear)

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

*Create a new variable "division" from the variable c_groupdescription that pertains to the second level of ISIC groups with 2-digit codes. Note that division from 01-09 are coded as 1-9.
generate division = real(substr(c_groupdescription, 1, 2))
drop c_groupdescription

*Define labels for all 2-digit ISIC Rev. 4 divisions
label define ISIC_divisions ///
1 "01 - Crop and animal production, hunting and related service activities" ///
2 "02 - Forestry and logging" ///
3 "03 - Fishing and aquaculture" ///
5 "05 - Mining of coal and lignite" ///
6 "06 - Extraction of crude petroleum and natural gas" ///
7 "07 - Mining of metal ores" ///
8 "08 - Other mining and quarrying" ///
9 "09 - Mining support service activities" ///
10 "10 - Manufacture of food products" ///
11 "11 - Manufacture of beverages" ///
12 "12 - Manufacture of tobacco products" ///
13 "13 - Manufacture of textiles" ///
14 "14 - Manufacture of wearing apparel" ///
15 "15 - Manufacture of leather and related products" ///
16 "16 - Manufacture of wood and products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials" ///
17 "17 - Manufacture of paper and paper products" ///
18 "18 - Printing and reproduction of recorded media" ///
19 "19 - Manufacture of coke and refined petroleum products" ///
20 "20 - Manufacture of chemicals and chemical products" ///
21 "21 - Manufacture of basic pharmaceutical products and pharmaceutical preparations" ///
22 "22 - Manufacture of rubber and plastics products" ///
23 "23 - Manufacture of other non-metallic mineral products" ///
24 "24 - Manufacture of basic metals" ///
25 "25 - Manufacture of fabricated metal products, except machinery and equipment" ///
26 "26 - Manufacture of computer, electronic and optical products" ///
27 "27 - Manufacture of electrical equipment" ///
28 "28 - Manufacture of machinery and equipment n.e.c." ///
29 "29 - Manufacture of motor vehicles, trailers and semi-trailers" ///
30 "30 - Manufacture of other transport equipment" ///
31 "31 - Manufacture of furniture" ///
32 "32 - Other manufacturing" ///
33 "33 - Repair and installation of machinery and equipment" ///
35 "35 - Electricity, gas, steam and air conditioning supply" ///
36 "36 - Water collection, treatment and supply" ///
37 "37 - Sewerage" ///
38 "38 - Waste collection, treatment and disposal activities; materials recovery" ///
39 "39 - Remediation activities and other waste management services" ///
41 "41 - Construction of buildings" ///
42 "42 - Civil engineering" ///
43 "43 - Specialised construction activities" ///
45 "45 - Wholesale and retail trade and repair of motor vehicles and motorcycles" ///
46 "46 - Wholesale trade, except of motor vehicles and motorcycles" ///
47 "47 - Retail trade, except of motor vehicles and motorcycles" ///
49 "49 - Land transport and transport via pipelines" ///
50 "50 - Water transport" ///
51 "51 - Air transport" ///
52 "52 - Warehousing and support activities for transportation" ///
53 "53 - Postal and courier activities" ///
55 "55 - Accommodation" ///
56 "56 - Food and beverage service activities" ///
58 "58 - Publishing activities" ///
59 "59 - Motion picture, video and television programme production, sound recording and music publishing activities" ///
60 "60 - Programming and broadcasting activities" ///
61 "61 - Telecommunications" ///
62 "62 - Computer programming, consultancy and related activities" ///
63 "63 - Information service activities" ///
64 "64 - Financial service activities, except insurance and pension funding" ///
65 "65 - Insurance, reinsurance and pension funding, except compulsory social security" ///
66 "66 - Activities auxiliary to financial services and insurance activities" ///
68 "68 - Real estate activities" ///
69 "69 - Legal and accounting activities" ///
70 "70 - Activities of head offices; management consultancy activities" ///
71 "71 - Architectural and engineering activities; technical testing and analysis" ///
72 "72 - Scientific research and development" ///
73 "73 - Advertising and market research" ///
74 "74 - Other professional, scientific and technical activities" ///
75 "75 - Veterinary activities" ///
77 "77 - Rental and leasing activities" ///
78 "78 - Employment activities" ///
79 "79 - Travel agency, tour operator and other reservation service and related activities" ///
80 "80 - Security and investigation activities" ///
81 "81 - Services to buildings and landscape activities" ///
82 "82 - Office administrative, office support and other business support activities" ///
84 "84 - Public administration and defence; compulsory social security" ///
85 "85 - Education" ///
86 "86 - Human health activities" ///
87 "87 - Residential care activities" ///
88 "88 - Social work activities without accommodation" ///
90 "90 - Creative, arts and entertainment activities" ///
91 "91 - Libraries, archives, museums and other cultural activities" ///
92 "92 - Gambling and betting activities" ///
93 "93 - Sports activities and amusement and recreation activities" ///
94 "94 - Activities of membership organizations" ///
95 "95 - Repair of computers and personal and household goods" ///
96 "96 - Other personal service activities" ///
97 "97 - Activities of households as employers of domestic personnel" ///
98 "98 - Undifferentiated goods- and services-producing activities of private households for own use" ///
99 "99 - Activities of extraterritorial organizations and bodies"

*Assign these labels to the division variable.
label values division ISIC_divisions



*################################################################
*Fallback macro and 2-digit sector for PAYE observations which are matched on some years and some years not.
generate section_fallback = section
sort c_firm_id section_fallback
replace section_fallback = section_fallback[_n-1] if missing(section_fallback) & c_firm_id[_n-1] == c_firm_id[_n] & _merge == 1
label values section_fallback section

generate division_fallback = division
sort c_firm_id division_fallback
replace division_fallback = division_fallback[_n-1] if missing(division_fallback) & c_firm_id[_n-1] == c_firm_id[_n] & _merge == 1
label values division_fallback ISIC_divisions

*Create another a new sector variable that pertains to the intermediate ISIC code aggregation with 38 different categories. This is created from the ISIC division variable which has 88 cateogories.
recode division (1/3 = 1) (5/9 = 2) (10/12 = 3) (13/15 = 4) (16/18 = 5) ///
(19 = 6) (20 = 7) (21 = 8) (22/23 = 9) (24/25 = 10) ///
(26 = 11) (27 = 12) (28 = 13) (29/30 = 14) (31/33 = 15) ///
(35 = 16) (36/39 = 17) (41/43 = 18) (45/47 = 19) (49/53 = 20) ///
(55/56 = 21) (58/60 = 22) (61 = 23) (62/63 = 24) (64/66 = 25) ///
(68 = 26) (69/71 = 27) (72 = 28) (73/75 = 29) (77/82 = 30) ///
(84 = 31) (85 = 32) (86 = 33) (87/88 = 34) (90/93 = 35) ///
(94/96 = 36) (97/98 = 37) (99 = 38), generate(A38_code)

*Label the A38_code variable.
label define A38_labels ///
1 "A - Agriculture, forestry and fishing" ///
2 "B - Mining and quarrying" ///
3 "CA - Manufacture of food products, beverages and tobacco products" ///
4 "CB - Manufacture of textiles, wearing apparel, leather and related products" ///
5 "CC - Manufacture of wood and paper products; printing and reproduction of recorded media" ///
6 "CD - Manufacture of coke and refined petroleum products" ///
7 "CE - Manufacture of chemicals and chemical products" ///
8 "CF - Manufacture of basic pharmaceutical products and pharmaceutical preparations" ///
9 "CG - Manufacture of rubber and plastics products, and other non-metallic mineral products" ///
10 "CH - Manufacture of basic metals and fabricated metal products, except machinery and equipment" ///
11 "CI - Manufacture of computer, electronic and optical products" ///
12 "CJ - Manufacture of electrical equipment" ///
13 "CK - Manufacture of machinery and equipment n.e.c." ///
14 "CL - Manufacture of transport equipment" ///
15 "CM - Other manufacturing; repair and installation of machinery and equipment" ///
16 "D - Electricity, gas, steam and air conditioning supply" ///
17 "E - Water supply; sewerage, waste management and remediation" ///
18 "F - Construction" ///
19 "G - Wholesale and retail trade; repair of motor vehicles and motorcycles" ///
20 "H - Transportation and storage" ///
21 "I - Accommodation and food service activities" ///
22 "JA - Publishing, audiovisual and broadcasting activities" ///
23 "JB - Telecommunications" ///
24 "JC - IT and other information services" ///
25 "K - Financial and insurance activities" ///
26 "L - Real estate activities" ///
27 "MA - Legal, accounting, management, architecture, engineering, technical testing and analysis activities" ///
28 "MB - Scientific research and development" ///
29 "MG - Other professional, scientific and technical activities" ///
30 "N - Administrative and support service activities" ///
31 "O - Public administration and defence; compulsory social security" ///
32 "P - Education" ///
33 "QA - Human health activities" ///
34 "QB - Residential care and social work activities" ///
35 "R - Arts, entertainment and recreation" ///
36 "S - Other service activities" ///
37 "T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use" ///
38 "U - Activities of extraterritorial organizations and bodies"

label values A38_code A38_labels

*Fallback for A38_code for PAYE observations which are matched on some years and some years not.
generate A38_fallback = A38_code
sort c_firm_id A38_fallback
replace A38_fallback = A38_fallback[_n-1] if missing(A38_fallback) & c_firm_id[_n-1] == c_firm_id[_n] & _merge == 1
label values A38_fallback A38_labels

*######################################################
*Clean data.

*Drop observations with tagPAYEdeducted == 1.
drop if tagPAYEdeducted == 1

*Drop observations with zero total annual wages for some financial year together with zero/negative sales or missing sales.
*First, create sum of yearly firm wages. If all values are missing for a year the variable is set to missing.
egen yearly_firm_wages = total(sch1_basic_salary), missing by(c_firm_id financial_year)
drop if (yearly_firm_wages == 0 & pl_y_incometaxturnover <= 0) | (yearly_firm_wages == 0 & missing(pl_y_incometaxturnover))

*Clean data further by dropping firm_year pairs that appear only in the CIT data since for these there is no wage information and hence no information on the number of workers either.
drop if _merge == 2

*Drop negative sch1_basic_salary entries.
drop if sch1_basic_salary < 0

*################################################################
*Create a firm-year specific average wage.
*Calculate the average monthly wage such that it takes the average from only months were there are at least one positive entry.
egen monthly_firm_wages = total(sch1_basic_salary), missing by(c_firm_id financial_year PAYE_return_month)
egen avgsalary = mean(sch1_basic_salary) if monthly_firm_wages > 0, by(c_firm_id financial_year)
sort avgsalary c_firm_id financial_year
replace avgsalary = avgsalary[_n-1] if missing(avgsalary) & c_firm_id[_n-1] == c_firm_id[_n] & financial_year[_n-1] == financial_year[_n]
replace avgsalary = 0 if missing(avgsalary)

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
generate indicator = 0
replace indicator = 1 if sch1_basic_salary > 0
egen firmsizeforproductivity = total(indicator), by(c_firm_id financial_year)
replace firmsizeforproductivity = firmsizeforproductivity / 12
*If firmsizeforproductivity is zero replace the value with the variable firmsize_estimate, which assures that firmsize is not zero.
replace firmsizeforproductivity = firmsize_estimate if firmsizeforproductivity == 0

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
egen countzeros = total(firm_year_tag == 1) if pl_y_incometaxturnover == 0 & sales_per_worker != ., by(c_firm_id), missing
sort c_firm_id countzeros
replace countzeros = countzeros[_n-1] if missing(countzeros) & c_firm_id[_n-1] == c_firm_id[_n]

*Tag firms with at least one zero turnover year.
egen zero = tag(c_firm_id) if pl_y_incometaxturnover == 0 

egen zerotest = tag(c_firm_id) if pl_y_incometaxturnover == 0 & sales_per_worker != .

*Cumulative sales.
egen cumulative_sales = total(pl_y_incometaxturnover), by(c_firm_id) missing

*Share one year firms.

egen singleyearfirms = total(firm_year_tag == 1) if reported_years == 1, by(financial_year section_fallback)

egen nfirms = total(firm_month_year_tag == 1), by(financial_year section_fallback)

generate shareosingleyearfirms = singleyearfirms / nfirms


replace yearly_firm_wages = sum(sch1_basic_salary) if c_firm_id == "8ZNNmmNNZ8V9ZZXXZZ9V" & financial_year == 8

replace yearly_firm_wages = sum(sch1_basic_salary) if c_firm_id == "m8VNMMNV8mCZXZXXZXZC" & financial_year == 9

egen wsampletag = tag(c_firm_id) if section_fallback != . & section_fallback != 20 & section_fallback != 21

egen psampletag = tag(c_firm_id) if section_fallback != . & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover > 0 & sales_per_worker != .