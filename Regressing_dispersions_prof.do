*The code for the dispersion regressions.

*######################################################
*Using the averaged percentiles method.

*Import the wage percentile data. 
import excel wagepercentiles_A21_cleaned_prof_NEW, firstrow clear
*Merge with the CPI data.
merge m:1 financial_year using CPI, nogenerate

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
merge 1:1 section_fallback financial_year using profitpercentiles_A21_cleaned_NEW, nogenerate

*Merge with the sector deflator data.
merge m:1 section_fallback financial_year using GDP_deflators, nogenerate

*Generate the labour productivity percentiles in real terms.
generate rep90_profits = p90_profits / (sector_deflator/100)
generate rep50_profits = p50_profits / (sector_deflator/100)
generate rep25_profits = p25_profits / (sector_deflator/100)
generate rep10_profits = p10_profits / (sector_deflator/100)

*Generate the log productivity differences.
generate diff9050profits = log(rep90_profits) - log(rep50_profits)
generate diff9025profits = log(rep90_profits) - log(rep25_profits)
generate diff9010profits = log(rep90_profits) - log(rep10_profits)
generate diff5025profits= log(rep50_profits) - log(rep25_profits)
generate diff5010profits = log(rep50_profits) - log(rep10_profits)

*Regressions.
*Regress the wage dispersion on productivity dispersion with time and sector controls. 2013/14 is the base year and C-Manufacturing is the base sector. Sectors T and U are excluded.
log using dispersionreg_averagemeth_cleaned_prof_NEW

regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

*###############
*Without weights.
regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21, vce(cluster A21)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21, vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21, vce(cluster A21)
display `e(r2_a)'


*#########
*POOLED REGRESSIONS.
regress diff_p90_p10_basicsalary diff9010profits i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21))
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.fy if A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

log close

wildbootstrap regress diff_p90_p10_basicsalary_INDI diff9010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21, cluster(A21) rseed(12345)
display `e(r2_a)'

wildbootstrap regress diff_p90_p50_basicsalary_INDI diff9050profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21, cluster(A21) rseed(12345)
display `e(r2_a)'

wildbootstrap regress diff_p50_p10_basicsalary_INDI diff5010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21, cluster(A21) rseed(12345)
display `e(r2_a)'

