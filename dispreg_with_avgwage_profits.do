*The code for the dispersion regressions.

*First using the single month method estimates.
import excel averagewagepercentiles_A21_cleaned_prof_NEW, firstrow clear
merge m:1 financial_year using CPI, nogenerate

*Encode time and sector variables.
encode financial_year, generate(fy)
encode section_fallback, generate(A21)

*Generate the wage percentiles in real terms.
generate rep90_basicsalary = p90avgsalary / (CPI_UBOS/100)
generate rep50_basicsalary = p50avgsalary / (CPI_UBOS/100)
generate rep25_basicsalary = p25avgsalary / (CPI_UBOS/100)
generate rep10_basicsalary = p10avgsalary / (CPI_UBOS/100)

*Create the log wage differences.
generate diff_p90_p50_basicsalary = log(rep90_basicsalary) - log(rep50_basicsalary)
generate diff_p90_p25_basicsalary = log(rep90_basicsalary) - log(rep25_basicsalary)
generate diff_p90_p10_basicsalary = log(rep90_basicsalary) - log(rep10_basicsalary)
generate diff_p50_p25_basicsalary = log(rep50_basicsalary) - log(rep25_basicsalary)
generate diff_p50_p10_basicsalary = log(rep50_basicsalary) - log(rep10_basicsalary)


*Merge with the productivity data.
merge 1:1 section_fallback financial_year using profitpercentiles_A21_cleaned, nogenerate

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
log using dispersionregressions_avgwage_cleaned_prof_NEW
*First with the number of firms from proddata as weights.
regress diff_p90_p10_basicsalary_INDI diff9010profits i.A21 i.fy ib3.A21 if A21 != 16 [aweight = avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

wildbootstrap regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 [aweight = nfirms], cluster(A21) rseed(12345)
display `e(r2_a)'

scatter diff_p90_p10_basicsalary diff9010profits, xtitle("Log 90/10 ratio of labour productivity") ytitle("Log 90/10 ratio of firm wage")

scatter diff_p90_p10_basicsalary diff9010profits

regress diff_p90_p10_basicsalary_INDI diff9010profits i.A21 i.fy ib3.A21 [aweight = avg_sectorsize]
boottest diff9010profits, boottype(wild) cluster(A21) level(95)

wildbootstrap regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 [aweight = nfirms], cluster(A21) rseed(12345)
display `e(r2_a)'

wildbootstrap regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 [aweight = nfirms], cluster(A21) rseed(12345)
display `e(r2_a)'

regress diff_p90_p50_basicsalary_INDI diff9050profits i.A21 i.fy ib3.A21 if A21 != 16 [aweight = avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary_INDI diff5010profits i.A21 i.fy ib3.A21 [aweight= avg_sectorsize], vce(cluster A21)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#########
*POOLED REGRESSIONS.
xtset A21 fy
xtreg diff_p90_p10_basicsalary diff9010profits, re vce(cluster A21)
estimates store fixed
hausman fixed ., sigmamore
regress diff_p90_p10_basicsalary diff9010profits i.A21, vce(cluster A21)

wildbootstrap regress diff_p90_p10_basicsalary diff9010profits i.fy [aweight = nfirms], cluster(A21)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.fy if A21 != 19 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

wildbootstrap regress diff_p90_p50_basicsalary diff9050profits i.fy [aweight = nfirms], cluster(A21)
display `e(r2_a)'


regress diff_p50_p10_basicsalary diff5010profits i.fy if A21 != 16 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010profits i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010profits i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*###########################
*Then with the number of firms in wagedata  as weights.
regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 if A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010profits i.A21 i.fy ib3.A21 if A21 < 15 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.A21 i.fy ib3.A21 if A21 < 15 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.A21 i.fy ib3.A21 if A21 < 15 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*#########
*POOLED REGRESSIONS.
regress diff_p90_p10_basicsalary diff9010profits i.fy if A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.fy if A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.fy if A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff_p90_p10_basicsalary diff9010profits i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff_p90_p10_basicsalary diff9010profits i.fy if A21 < 15 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p50_basicsalary diff9050profits i.fy if A21 < 15 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary diff5010profits i.fy if A21 < 15 [aweight = wagenfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'


log close