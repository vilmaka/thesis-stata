*############################################################
*Use collapse to get the percentiles for wages and productivity.

*Producitivty percentiles for the A21 level excluding zero turnover firms.
preserve
collapse (count) nfirms = firm_year_tag (mean) mean_sales = sales_per_worker (p90) p90_sales = sales_per_worker (p50) p50_sales = sales_per_worker (p25) p25_sales = sales_per_worker (p10) p10_sales = sales_per_worker if (firm_year_tag == 1 & section_fallback != . & pl_y_incometaxturnover > 0 & pl_y_incometaxturnover != .), by(financial_year section_fallback) cw
export excel productivitypercentiles_A21_cleaned_NEW, firstrow(variables)

*Producitivty percentiles for the A21 level excluding zero turnover with the different firm size measure.
preserve
collapse (count) nfirms = firm_year_tag (mean) mean_sales = sales_per_worker_est (p90) p90_sales = sales_per_worker_est (p50) p50_sales = sales_per_worker_est (p25) p25_sales = sales_per_worker_est (p10) p10_sales = sales_per_worker_est if (firm_year_tag == 1 & section_fallback != . & pl_y_incometaxturnover > 0 & pl_y_incometaxturnover != .), by(financial_year section_fallback) cw
export excel productivitypercentiles_A21_cleaned_est_NEW, firstrow(variables)

*Producitivty percentiles for the A21 level excluding zero income firms.
preserve
collapse (count) nfirms = firm_year_tag (mean) mean_income = income_per_worker (p90) p90_income = income_per_worker (p50) p50_income = income_per_worker (p25) p25_income = income_per_worker (p10) p10_income = income_per_worker if (firm_year_tag == 1 & section_fallback != . & income_per_worker > 0), by(financial_year section_fallback) cw
export excel incomeproductivitypercentiles_A21_cleaned, firstrow(variables)

*Producitivty percentiles for the A21 level with positive profit firms.
preserve
collapse (count) nfirms = firm_year_tag (mean) mean_profits = profits_per_worker (p90) p90_profits = profits_per_worker (p50) p50_profits = profits_per_worker (p25) p25_profits = profits_per_worker (p10) p10_profits = profits_per_worker if (firm_year_tag == 1 & section_fallback != . & pl_grossprofit > 0 & pl_grossprofit != .), by(financial_year section_fallback) cw
export excel profitpercentiles_A21_cleaned_NEW, firstrow(variables)


*###################################################################
*Get the percentiles for wages.
*For all PAYE data.
preserve
collapse (count) nemployees = sch1_basic_salary (mean) mean_sch1_basic_salary = sch1_basic_salary (p90) p90_sch1_basic_salary = sch1_basic_salary (p50) p50_sch1_basic_salary = sch1_basic_salary (p25) p25_sch1_basic_salary = sch1_basic_salary (p10) p10_sch1_basic_salary = sch1_basic_salary, by(PAYE_return_month financial_year) cw
export excel wagepercentiles_all, firstrow(variables)

*For the PAYE data for which sector information (A21) can be recovered.
preserve
collapse (count) nemployees = sch1_basic_salary (mean) mean_sch1_basic_salary = sch1_basic_salary (p90) p90_sch1_basic_salary = sch1_basic_salary (p50) p50_sch1_basic_salary = sch1_basic_salary (p25) p25_sch1_basic_salary = sch1_basic_salary (p10) p10_sch1_basic_salary = sch1_basic_salary if section_fallback != ., by(PAYE_return_month financial_year section_fallback) cw
export excel wagepercentiles_A21_NEW, firstrow(variables)

*For the PAYE data for which sector information (A21) can be recovered without zero turnover firms.
preserve
collapse (count) nemployees = sch1_basic_salary (mean) mean_sch1_basic_salary = sch1_basic_salary (p90) p90_sch1_basic_salary = sch1_basic_salary (p50) p50_sch1_basic_salary = sch1_basic_salary (p25) p25_sch1_basic_salary = sch1_basic_salary (p10) p10_sch1_basic_salary = sch1_basic_salary if (section_fallback != . & pl_y_incometaxturnover > 0 & pl_y_incometaxturnover != .), by(PAYE_return_month financial_year section_fallback) cw
export excel wagepercentiles_A21_cleaned_NEW, firstrow(variables)

*For the PAYE data for which sector information (A21) can be recovered without zero or negative profit firms.
preserve
collapse (count) nemployees = sch1_basic_salary (mean) mean_sch1_basic_salary = sch1_basic_salary (p90) p90_sch1_basic_salary = sch1_basic_salary (p50) p50_sch1_basic_salary = sch1_basic_salary (p25) p25_sch1_basic_salary = sch1_basic_salary (p10) p10_sch1_basic_salary = sch1_basic_salary if (section_fallback != . & pl_grossprofit > 0 & pl_grossprofit != .), by(PAYE_return_month financial_year section_fallback) cw
export excel wagepercentiles_A21_cleaned_prof_NEW, firstrow(variables)


*AVERAGE FIRM WAGES
*Percentiles with average firm wages for all obs with A21.
preserve
collapse (count) nfirms = firm_year_tag (mean) mean_avgsalary = avgsalary (p90) p90avgsalary = avgsalary (p50) p50avgsalary = avgsalary (p25) p25avgsalary = avgsalary (p10) p10avgsalary = avgsalary if (firm_year_tag == 1 & section_fallback != .), by(financial_year section_fallback) cw
export excel averagewagepercentiles_A21, firstrow(variables) replace

*Without zero sales firms.
preserve
collapse (count) nfirms = firm_year_tag (mean) mean_avgsalary = avgsalary (p90) p90avgsalary = avgsalary (p50) p50avgsalary = avgsalary (p25) p25avgsalary = avgsalary (p10) p10avgsalary = avgsalary if (firm_year_tag == 1 & section_fallback != . & pl_y_incometaxturnover > 0 & pl_y_incometaxturnover != .), by(financial_year section_fallback) cw
export excel averagewagepercentiles_A21_cleaned, firstrow(variables) replace

*Without zero/negative profit firms.
preserve
collapse (count) nfirms = firm_year_tag (mean) mean_avgsalary = avgsalary (p90) p90avgsalary = avgsalary (p50) p50avgsalary = avgsalary (p25) p25avgsalary = avgsalary (p10) p10avgsalary = avgsalary if (firm_year_tag == 1 & section_fallback != . & pl_grossprofit > 0 & pl_grossprofit != .), by(financial_year section_fallback) cw
export excel averagewagepercentiles_A21_cleaned_prof_NEW, firstrow(variables) replace