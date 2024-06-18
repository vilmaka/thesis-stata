*The code for the dispersion regressions.

*First using the single month method estimates.
import excel wagepercentiles_A21, firstrow clear
merge m:1 financial_year using CPI, nogenerate

*Encode time and sector variables.
encode financial_year, generate(fy)
encode section_fallback, generate(A21)

*Create annual average sector size for the weighting.
egen avg_sectorsize = mean(nemployees), by(section_fallback financial_year)

*Generate the wage percentiles in real terms.
generate rep90_basicsalary = p90_sch1_basic_salary / (CPI_UBOS/100)
generate rep50_basicsalary = p50_sch1_basic_salary / (CPI_UBOS/100)
generate rep25_basicsalary = p25_sch1_basic_salary / (CPI_UBOS/100)
generate rep10_basicsalary = p10_sch1_basic_salary / (CPI_UBOS/100)

*Create the log wage differences.
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
replace keep = 1 if A21 == 18 & PAYE_return_month == 3
replace keep = 1 if A21 == 19 & PAYE_return_month == 9
replace keep = 1 if A21 == 20 & PAYE_return_month == 11
replace keep = 1 if A21 == 21 & PAYE_return_month == 5

drop if keep != 1

*Merge with the productivity data.
merge 1:1 section_fallback financial_year using productivitypercentiles_A21_cleaned, nogenerate

*Merge with the sector deflator data.
merge m:1 section_fallback financial_year using GDP_deflators, nogenerate

*Generate the labour productivity percentiles in real terms.
generate rep90_sales = p90_sales / (sector_deflator/100)
generate rep50_sales = p50_sales / (sector_deflator/100)
generate rep25_sales = p25_sales / (sector_deflator/100)
generate rep10_sales = p10_sales / (sector_deflator/100)

*Generate the log productivity differences.
generate diff9050sales = log(rep90_sales) - log(rep50_sales)
generate diff9025sales = log(rep90_sales) - log(rep25_sales)
generate diff9010sales = log(rep90_sales) - log(rep10_sales)
generate diff5025sales= log(rep50_sales) - log(rep25_sales)
generate diff5010sales = log(rep50_sales) - log(rep10_sales)

*Regressions.
*Regress the wage dispersion on productivity dispersion with time and sector controls. 2013/14 is the base year and C-Manufacturing is the base sector. Sectors T and U are excluded.
log using dispersionregressions_singlemonthmethod
*First with the number of firms as weights.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#########
*POOLED REGRESSIONS.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*###########
*FIRST DIFFERENCES
generate WD9010fy1 = diff_p90_p10_basicsalary if fy == 1
generate WD9010fy5 = diff_p90_p10_basicsalary if fy == 5
generate WD9010fy9 = diff_p90_p10_basicsalary if fy == 9

generate PD9010fy1 = diff9010sales if fy == 1
generate PD9010fy5 = diff9010sales if fy == 5
generate PD9010fy9 = diff9010sales if fy == 9

generate deltaWD9010fy1to5 = WD9010fy5 - WD9010fy1
generate deltaWD9010fy5to9 = WD9010fy9 - WD9010fy5
generate deltaWD9010fy1to9 = WD9010fy9 - WD9010fy1

generate deltaPD9010fy1to5 = PD9010fy5 - PD9010fy1
generate deltaPD9010fy5to9 = PD9010fy9 - PD9010fy5
generate deltaPD9010fy1to9 = PD9010fy9 - PD9010fy1

regress deltaWD9010fy1to5 deltaPD9010fy1to5, vce(cluster A21)

*#########################################
*Then with the number of employees as weights.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#########
*POOLED REGRESSIONS.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'


log close

*######################################################
*Then using the averaged percentiles method.

*Import the wage percentile data. 
import excel wagepercentiles_A21, firstrow clear
*Merge with the CPI data.
merge m:1 financial_year using CPI

*Create annual average sector size for the weighting.
egen avg_sectorsize = mean(nemployees), by(section_fallback financial_year)

*Generate the wage percentiles in real terms.
generate rep90_basicsalary = p90_sch1_basic_salary / (CPI_UBOS/100)
generate rep50_basicsalary = p50_sch1_basic_salary / (CPI_UBOS/100)
generate rep25_basicsalary = p25_sch1_basic_salary / (CPI_UBOS/100)
generate rep10_basicsalary = p10_sch1_basic_salary / (CPI_UBOS/100)

*Collapse the monthly percentiles to annual weighted (by employees) averages.
collapse (mean) avg_sectorsize rep90_basicsalary rep50_basicsalary rep25_basicsalary rep10_basicsalary [aweight = nemployees], by(financial_year section_fallback)

*Enocde time and sector variables.
encode financial_year, generate(fy)
encode section_fallback, generate(A21)

*Generate the log wage differences.
generate diff_p90_p50_basicsalary = log(rep90_basicsalary) - log(rep50_basicsalary)
generate diff_p90_p25_basicsalary = log(rep90_basicsalary) - log(rep25_basicsalary)
generate diff_p90_p10_basicsalary = log(rep90_basicsalary) - log(rep10_basicsalary)
generate diff_p50_p25_basicsalary = log(rep50_basicsalary) - log(rep25_basicsalary)
generate diff_p50_p10_basicsalary = log(rep50_basicsalary) - log(rep10_basicsalary)

*Again, merge with the productivity data.
merge 1:1 section_fallback financial_year using productivitypercentiles_A21_cleaned

*Merge with the sector deflator data.
merge m:1 section_fallback financial_year using GDP_deflators

*Generate the labour productivity percentiles in real terms.
generate rep90_sales = p90_sales / (sector_deflator/100)
generate rep50_sales = p50_sales / (sector_deflator/100)
generate rep25_sales = p25_sales / (sector_deflator/100)
generate rep10_sales = p10_sales / (sector_deflator/100)

*Generate the log productivity differences.
generate diff9050sales = log(rep90_sales) - log(rep50_sales)
generate diff9025sales = log(rep90_sales) - log(rep25_sales)
generate diff9010sales = log(rep90_sales) - log(rep10_sales)
generate diff5025sales= log(rep50_sales) - log(rep25_sales)
generate diff5010sales = log(rep50_sales) - log(rep10_sales)

*Regressions.
*Regress the wage dispersion on productivity dispersion with time and sector controls. 2013/14 is the base year and C-Manufacturing is the base sector. Sectors T and U are excluded.
log using dispersionregressions_averagemethod_cleaned_prof_NEW

regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#########
*POOLED REGRESSIONS.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*###########
*Then with the number of employees as weights.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.A21 i.fy ib3.A21 if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#########
*POOLED REGRESSIONS.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010sales i.fy if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050sales i.fy if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010sales i.fy if A21 < 15 [aweight = avg_sectorsize], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

log close