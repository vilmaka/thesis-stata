*Import desired excel.
import excel profitpercentiles_A21_cleaned_NEW, firstrow clear

*Merge with the deflator data.
merge m:1 financial_year section_fallback using GDP_deflators

encode financial_year, generate(fy)
encode section_fallback, generate(A21)

*Generate the labour productivity in real terms.
generate rep90_profits = p90_profits / (sector_deflator/100)
generate rep50_profits = p50_profits / (sector_deflator/100)
generate rep10_profits = p10_profits / (sector_deflator/100)

*Generate the log differences.
generate diff9050profits = log(rep90_profits) - log(rep50_profits)
generate diff9010profits = log(rep90_profits) - log(rep10_profits)
generate diff5010profits = log(rep50_profits) - log(rep10_profits)


log using producitivty_cleaned_NEW_profits, replace
*#####################################################
*MAIN REGRESSIONS
regress diff9050profits i.fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010profits i.fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010profits i.fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Again on a time trend.
regress diff9050profits fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff9010profits fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff5010profits fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

*######
*Without O-Public admin.
regress diff9050profits i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010profits i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010profits i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Again on a time trend.
regress diff9050profits fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff9010profits fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff5010profits fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

*######
*Without non-market services.
regress diff9050profits i.fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010profits i.fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010profits i.fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Again on a time trend.
regress diff9050profits fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff9010profits fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff5010profits fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'


*######
*POOLED REGRESSIONS
*All sectors.
regress diff9050profits i.fy if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010profits i.fy if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010profits i.fy if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff9050profits i.fy if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010profits i.fy if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010profits i.fy if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff9050profits i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010profits i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010profits i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

log close