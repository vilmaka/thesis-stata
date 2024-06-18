*For all.
log using allsamplestats_NEW

count if firm_tag == 1
tabstat firmsize_estimate avgsalary if firm_year_tag == 1, by(financial_year) stats(N mean median)
tabstat sch1_basic_salary, by(financial_year) stats(N mean median)
log close

*For wage sample.
log using wagesamplestats_NEW

count if wsampletag == 1
tabstat firmsize_estimate avgsalary if firm_year_tag == 1 & section_fallback != . & section_fallback != 20 & section_fallback != 21, by(financial_year) stats(N mean median)

tabstat sch1_basic_salary if section_fallback != . & section_fallback != 20 & section_fallback != 21, by(financial_year) stats(N mean median) 

log close


*For productivity sample.
log using prodsamplestats_NEW
count if psampletag == 1
tabstat firmsize_estimate avgsalary sales_per_worker if firm_year_tag == 1 & section_fallback != . & pl_y_incometaxturnover > 0 & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover != ., by(financial_year) stats(N mean median)

tabstat sch1_basic_salary if pl_y_incometaxturnover > 0 & section_fallback != . & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover != ., by(financial_year) stats(N mean median)

log close

log using tabA21_NEW, append

tabulate section_fallback if firm_tag == 1
tabulate section_fallback if firm_tag == 1, missing


tabulate section_fallback if wsampletag == 1

tabulate section_fallback if psampletag == 1

log close



*For firms with zero productivity.
log using zeroprodstats_NEW
tabstat firmsize_estimate avgsalary if pl_y_incometaxturnover == 0 & firm_year_tag == 1 & pl_y_incometaxturnover != ., by(financial_year) stats(N mean median)

tabstat firmsize_estimate avgsalary if pl_y_incometaxturnover == 0 & firm_year_tag == 1 & pl_y_incometaxturnover != . & section_fallback != . & section_fallback != 20 & section_fallback != 21, by(financial_year) stats(N mean median)

tabstat sch1_basic_salary if pl_y_incometaxturnover == 0 & pl_y_incometaxturnover != ., by(financial_year) stats(N mean median)

tabstat sch1_basic_salary if pl_y_incometaxturnover == 0 & pl_y_incometaxturnover != . & section_fallback != . & section_fallback != 20 & section_fallback != 21, by(financial_year) stats(N mean median)

bysort financial_year: count if pl_y_incometaxturnover == 0 & income_per_worker > 0 & firm_year_tag == 1 & pl_y_incometaxturnover != .

bysort financial_year: count if pl_y_incometaxturnover == 0 & income_per_worker > 0 & firm_year_tag == 1 & section_fallback != . & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover != .

tabulate section_fallback if zero == 1, missing

tabulate section_fallback if zero == 1 & section_fallback != . & section_fallback != 20 & section_fallback != 21

tabulate section_fallback if pl_y_incometaxturnover == 0 & firm_year_tag == 1 & sales_per_worker != ., missing

tabulate section_fallback if pl_y_incometaxturnover == 0 & firm_year_tag == 1 & sales_per_worker != . & section_fallback != . & section_fallback != 20 & section_fallback != 21

tabulate reported_years if zero == 1
tabulate reported_years if zero == 1 & section_fallback != . & section_fallback != 20 & section_fallback != 21

count if zero == 1 & cumulative_sales == 0

tabulate reported_years if zero == 1 & cumulative_sales == 0
tabulate reported_years if zero == 1 & cumulative_sales == 0 & section_fallback != . & section_fallback != 20 & section_fallback != 21

tabulate countzeros if zero == 1
tabulate countzeros if zero == 1 & section_fallback != . & section_fallback != 20 & section_fallback != 21

log close

log using reported_years_NEW

tabulate reported_years if firm_tag == 1

tabulate reported_years if wsampletag == 1

tabulate reported_years if psampletag == 1

log close

log using sector_stats

tabstat firmsize_estimate avgsalary if firm_year_tag == 1 & section_fallback != . & section_fallback != 20 & section_fallback != 21, by(section_fallback financial_year) stats(N mean median)

tabstat firmsize_estimate avgsalary sales_per_worker if firm_year_tag == 1 & section_fallback != . & pl_y_incometaxturnover > 0 & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover != ., by(section_fallback financial_year) stats(N mean median)

tabstat firmsize_estimate avgsalary sales_per_worker if firm_year_tag == 1 & section_fallback != . & pl_grossprofit > 0 & section_fallback != 20 & section_fallback != 21 & pl_grossprofit != ., by(section_fallback financial_year) stats(N mean median)

tabstat sch1_basic_salary if section_fallback != . & section_fallback != 20 & section_fallback != 21, by(section_fallback financial_year) stats(N mean median)

tabstat sch1_basic_salary if & section_fallback != . & pl_y_incometaxturnover > 0 & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover != ., by(section_fallback financial_year) stats(N mean median)

tabstat sch1_basic_salary if & section_fallback != . & pl_grossprofit > 0 & section_fallback != 20 & section_fallback != 21 & pl_grossprofit != ., by(section_fallback financial_year) stats(N mean median) 

log close

log using zeronegativeprofitfirms

egen zeroprof = tag(c_firm_id) if pl_grossprofit <= 0 & pl_grossprofit != .

bysort financial_year section_fallback: count if firm_year_tag == 1 & pl_grossprofit <= 0 & pl_grossprofit != .


tabstat firmsize_estimate avgsalary if firm_year_tag == 1 & section_fallback != . & pl_grossprofit > 0 & pl_grossprofit != .

tabstat firmsize_estimate avgsalary if firm_year_tag == 1 & section_fallback != . & pl_grossprofit > 0 & section_fallback != 20 & section_fallback != 21 & pl_grossprofit != .


tabstat sch1_basic_salary if section_fallback != . & pl_grossprofit > 0 & pl_grossprofit != .

tabstat sch1_basic_salary if section_fallback != . & pl_grossprofit > 0 & section_fallback != 20 & section_fallback != 21 & pl_grossprofit != .

log close