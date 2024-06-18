*This is the code for the variance decomposition.
drop if firm_year_tag == 0
drop if section_fallback == . | section_fallback == 20 | section_fallback == 21
merge m:1 financial_year using CPI_nostring, nogenerate
merge m:1 section_fallback financial_year using GDP_deflators_nostring, nogenerate

egen wsampletag = tag(c_firm_id) if section_fallback != . & section_fallback != 20 & section_fallback != 21

egen psampletag = tag(c_firm_id) if section_fallback != . & section_fallback != 20 & section_fallback != 21 & pl_y_incometaxturnover > 0 & sales_per_worker != .

*Tag sector-financial year combination.
egen sector_year_tag = tag(section_fallback financial_year) if _merge == 3 & pl_y_incometaxturnover > 0 & sales_per_worker != .

*Calculate labour share for each sector and the total number of labour.
egen L_st = total(firmsize_estimate), by(section_fallback financial_year)
egen L_t = total(firmsize_estimate), by(financial_year)

*Calculate sector share of labour and the total number of labour for only firms with positive turnover.
egen L_st_sales = total(firmsize_estimate) if (pl_y_incometaxturnover > 0 & sales_per_worker != .), by(section_fallback financial_year)
egen L_t_sales = total(firmsize_estimate) if (pl_y_incometaxturnover > 0 & sales_per_worker != .), by(financial_year)

*Calculate sector share of labour and the total number of labour for only firms with positive gross profit.
egen L_st_prof = total(firmsize_estimate) if (pl_grossprofit > 0 & profits_per_worker != .), by(section_fallback financial_year)
egen L_t_prof = total(firmsize_estimate) if (pl_grossprofit > 0 & profits_per_worker != .), by(financial_year)


*################################################
*For productivity as sales.
*Create the firm level labour productivity in real terms.
generate LP_S_jt = sales_per_worker / (sector_deflator/100)
generate LP_S_jt_log = log(LP_S_jt)
*Create the average labour productivity within A21-level sectors and the average productivity within years. 
egen LP_S_st = wtmean(LP_S_jt) if (pl_y_incometaxturnover > 0 & sales_per_worker != .), by(section_fallback financial_year) weight(firmsize_estimate)

egen LP_S_t = wtmean(LP_S_jt) if (pl_y_incometaxturnover > 0 & sales_per_worker != .), by(financial_year) weight(firmsize_estimate)

*Calculate the within-sector component.
generate within_LP_S_var = (LP_S_jt - LP_S_st)^2 if (pl_y_incometaxturnover > 0 & sales_per_worker != .) 
egen within_LP_S_var_sum = total((firmsize_estimate/L_st_sales)*within_LP_S_var) if (pl_y_incometaxturnover > 0 & sales_per_worker != .), by(section_fallback financial_year) missing
egen within_LP_S_var_totsum = total((L_st_sales/L_t_sales)*within_LP_S_var_sum) if (sector_year_tag == 1 & pl_y_incometaxturnover > 0 & sales_per_worker != .), by(financial_year) missing

*Calculate the between-sector component.
generate between_LP_S_var = (LP_S_st - LP_S_t)^2 if (pl_y_incometaxturnover > 0 & sales_per_worker != .)
egen between_LP_S_var_sum = total((L_st_sales/L_t_sales)*between_LP_S_var) if (sector_year_tag == 1 & pl_y_incometaxturnover > 0 & sales_per_worker != .), by(financial_year) missing

*Calculate total variance of labour productivity.
bysort financial_year: generate Var_LP_S_t = within_LP_S_var_totsum + between_LP_S_var_sum

generate withinshare_sales = within_LP_S_var_totsum / Var_LP_S_t

*#####################
*For productivity as profits.
generate LP_P_jt = profits_per_worker / (sector_deflator/100)
generate LP_P_jt_log = log(LP_P_jt)
*Create the average labour productivity within A21-level sectors and the average productivity within years. 
egen LP_S_st = wtmean(LP_jt) if (pl_y_incometaxturnover > 0 & sales_per_worker != .), by(section_fallback financial_year) weight(firmsize_estimate)

egen LP_t = wtmean(LP_jt) if (pl_y_incometaxturnover > 0 & sales_per_worker != .), by(financial_year) weight(firmsize_estimate)

*Calculate the within-sector component.
generate within_LP_P_var = (LP_P_jt - LP_P_st)^2 if (pl_grossprofit > 0 & profits_per_worker != .) 
egen within_LP_P_var_sum = total((firmsize_estimate/L_st_prof)*within_LP_P_var) if (pl_grossprofit > 0 & profits_per_worker != .), by(section_fallback financial_year) missing
egen within_LP_P_var_totsum = total((L_st_prof/L_t_prof)*within_LP_P_var_sum) if (sector_year_tag == 1 & pl_grossprofit > 0 & profits_per_worker != .), by(financial_year) missing

*Calculate the between-sector component.
generate between_LP_P_var = (LP_P_st - LP_P_t)^2 if (pl_grossprofit > 0 & profits_per_worker != .)
egen between_LP_P_var_sum = total((L_st_prof/L_t_prof)*between_LP_P_var) if (sector_year_tag == 1 & pl_grossprofit > 0 & profits_per_worker != .), by(financial_year) missing

*Calculate total variance of labour productivity.
bysort financial_year: generate Var_LP_P_t = within_LP_P_var_totsum + between_LP_P_var_sum

generate withinshare_prof = within_LP_P_var_totsum / Var_LP_P_t


*###################################################
*For firm average wage.
*Create the average firm wage in real terms.
generate real_avgsalary = avgsalary / (CPI_UBOS/100)
generate W_jt = log(real_avgsalary)
*Create the average firm wage within A21-level sectors and the average wage within years.
egen W_st = wtmean(W_jt), by(section_fallback financial_year) weight(firmsize_estimate)

egen W_t = wtmean(W_jt), by(financial_year) weight(firmsize_estimate)


*Calculate the within-sector component.
generate within_W_var = (W_jt - W_st)^2
egen within_W_var_sum = total((firmsize_estimate/L_st)*within_W_var), by(section_fallback financial_year) missing
egen within_W_var_totsum = total((L_st/L_t)*within_W_var_sum) if sector_year_tag == 1, by(financial_year)

*Calculate the between-sector component.
generate between_W_var = (W_st - W_t)^2
egen between_W_var_sum = total((L_st/L_t)*between_W_var) if sector_year_tag == 1, by(financial_year) missing

*Calculate the total variance of firm average wage.
generate Var_W_t = within_W_var_totsum + between_W_var_sum if sector_year_tag == 1

generate withinshare_wage = within_W_var_totsum / Var_W_t
