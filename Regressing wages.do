*This code is for the yearl-level wage regressions.
*Import the desired excel with the monthly percentiles.
import excel wagepercentiles_A21_cleaned_NEW, firstrow clear

*###########################################################
*Create the percentiles in real terms.
*Start with merging the consumer price index data.
merge m:1 financial_year using CPI

*Deflate the percentiles.
generate rep90_basicsalary = p90_sch1_basic_salary / (CPI_UBOS/100)
generate rep50_basicsalary = p50_sch1_basic_salary / (CPI_UBOS/100)
generate rep10_basicsalary = p10_sch1_basic_salary / (CPI_UBOS/100)

*Create annual average sector size for the weighting.
egen avg_sectorsize = mean(nemployees), by(section_fallback financial_year)

*Encode variables.
encode financial_year, generate(fy)
encode section_fallback, generate(A21)

*#############################################################
*Single month method code.
preserve

*Create the log differences.
generate diff_p90_p50_basicsalary = log(rep90_basicsalary) - log(rep50_basicsalary)
generate diff_p90_p25_basicsalary = log(rep90_basicsalary) - log(rep25_basicsalary)
generate diff_p90_p10_basicsalary = log(rep90_basicsalary) - log(rep10_basicsalary)
generate diff_p50_p25_basicsalary = log(rep50_basicsalary) - log(rep25_basicsalary)
generate diff_p50_p10_basicsalary = log(rep50_basicsalary) - log(rep10_basicsalary)

*Keep only the selected month for each sector.
generate keep = 0
replace keep = 1 if A21 == 1 & PAYE_return_month == 8
replace keep = 1 if A21 == 2 & PAYE_return_month == 12
replace keep = 1 if A21 == 3 & PAYE_return_month == 2
replace keep = 1 if A21 == 4 & PAYE_return_month == 11
replace keep = 1 if A21 == 5 & PAYE_return_month == 12
replace keep = 1 if A21 == 6 & PAYE_return_month == 3
replace keep = 1 if A21 == 7 & PAYE_return_month == 9
replace keep = 1 if A21 == 8 & PAYE_return_month == 1
replace keep = 1 if A21 == 9 & PAYE_return_month == 11
replace keep = 1 if A21 == 10 & PAYE_return_month == 11
replace keep = 1 if A21 == 11 & PAYE_return_month == 5
replace keep = 1 if A21 == 12 & PAYE_return_month == 2
replace keep = 1 if A21 == 13 & PAYE_return_month == 2
replace keep = 1 if A21 == 14 & PAYE_return_month == 2
replace keep = 1 if A21 == 15 & PAYE_return_month == 1
replace keep = 1 if A21 == 16 & PAYE_return_month == 2
replace keep = 1 if A21 == 17 & PAYE_return_month == 11
replace keep = 1 if A21 == 18 & PAYE_return_month == 1
replace keep = 1 if A21 == 19 & PAYE_return_month == 9
replace keep = 1 if A21 == 20 & PAYE_return_month == 11
replace keep = 1 if A21 == 21 & PAYE_return_month == 5

drop if keep != 1

log using singlemonthmethod_cleaned, replace
*Single month method.
*############################################
*Regressions without sector controls with robust errors. All 19 sectors.
regress diff_p90_p50_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public administration.
regress diff_p90_p50_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p50_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*##################################################
*Regressions with sector controls with robust errors. All 19 sectors.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public administration.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#####################################################
*POOLED REGRESSIONS
regress diff_p90_p50_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public administration.
regress diff_p90_p50_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p50_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*###############################################
*MAIN REGRESSIONS
*Regressing log wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of employees which is the sector yearly average. All 19 sectors included. Manufacturing is the base sector and 2013-2014 is the base year.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Regressing log wage ratios on a time trend. All 19 sectors included. Manufacturing is the base sector.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

*Without O-Public administration.
*Regressing log wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of employees which is the sector yearly average. O, T and U sectors excluded. Manufacturing is the base sector and 2013-2014 is the base year.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*On a time trend.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

*Without non-market services.
*Regressing log wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of employees which is the sector yearly average. O, P, Q, R, S T and U sectors excluded. Manufacturing is the base sector and 2013-2014 is the base year.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*On a time trend.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

log close
restore
*#########################################################
*Average method code.
preserve
*Collapse the monthly percentiles to annual weighted averages.
collapse (mean) avg_sectorsize rep90_basicsalary rep50_basicsalary rep10_basicsalary [aweight = nemployees], by(financial_year section_fallback)

encode financial_year, generate(fy)
encode section_fallback, generate(A21)

generate diff_p90_p50_basicsalary = log(rep90_basicsalary) - log(rep50_basicsalary)
generate diff_p90_p10_basicsalary = log(rep90_basicsalary) - log(rep10_basicsalary)
generate diff_p50_p10_basicsalary = log(rep50_basicsalary) - log(rep10_basicsalary)

log using averagemethod_cleaned, replace
*Average method.
*############################################
*Regressions without sector controls with robust errors. All 19 sectors.
regress diff_p90_p50_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public administration.
regress diff_p90_p50_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p50_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*##################################################
*Regressions with sector controls with robust errors. All 19 sectors.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public administration.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(robust)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#####################################################
*Regressions without sector controls with clustered errors. All 19 sectors.
regress diff_p90_p50_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public administration.
regress diff_p90_p50_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p50_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*###############################################
*MAIN REGRESSIONS
*Regressing log wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of employees which is the sector yearly average. All 19 sectors included. Manufacturing is the base sector and 2013-2014 is the base year.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Regressing log wage ratios on a time trend. All 19 sectors included. Manufacturing is the base sector.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

*Without O-Public administration.
*Regressing log wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of employees which is the sector yearly average. O, T and U sectors excluded. Manufacturing is the base sector and 2013-2014 is the base year.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*On a time trend.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=avg_sectorsize], vce(cluster A21) baselevels
display `e(r2_a)'

*Without non-market services.
*Regressing log wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of employees which is the sector yearly average. O, P, Q, R, S T and U sectors excluded. Manufacturing is the base sector and 2013-2014 is the base year.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*On a time trend.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

log close
restore
