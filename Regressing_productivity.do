*Import desired excel.
import excel productivitypercentiles_A21_cleaned_NEW, firstrow clear

*Merge with the deflator data.
merge m:1 financial_year section_fallback using GDP_deflators

encode financial_year, generate(fy)
encode section_fallback, generate(A21)

*Generate the labour productivity in real terms.
generate rep90_sales = p90_sales / (sector_deflator/100)
generate rep50_sales = p50_sales / (sector_deflator/100)
generate rep10_sales = p10_sales / (sector_deflator/100)

*Generate the log differences.
generate diff9050sales = log(rep90_sales) - log(rep50_sales)
generate diff9010sales = log(rep90_sales) - log(rep10_sales)
generate diff5010sales = log(rep50_sales) - log(rep10_sales)


log using producitivty_cleaned_NEW, replace
*#####################################################
*MAIN REGRESSIONS
regress diff9050sales i.fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010sales i.fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010 i.fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Again on a time trend.
regress diff9050sales fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff9010sales fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff5010 fy i.A21 ib3.A21 if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

*######
*Without O-Public admin.
regress diff9050sales i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010sales i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010 i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Again on a time trend.
regress diff9050sales fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff9010sales fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff5010 fy i.A21 ib3.A21 if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

*######
*Without non-market services.
regress diff9050sales i.fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010sales i.fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010 i.fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Again on a time trend.
regress diff9050sales fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff9010sales fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'

regress diff5010 fy i.A21 ib3.A21 if A21 < 15 [aweight = nfirms], vce(cluster A21)
display `e(r2_a)'


*######
*POOLED REGRESSIONS
*All sectors.
regress diff9050sales i.fy if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010sales i.fy if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010 i.fy if A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O-Public admin.
regress diff9050sales i.fy if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010sales i.fy if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010 i.fy if A21 != 15 & A21 != 21 & A21 != 20 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market services.
regress diff9050sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff9010sales i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff5010 i.fy if A21 < 15 [aweight = nfirms], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

log close