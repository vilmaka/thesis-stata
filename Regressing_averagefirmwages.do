*This code is for the averagewage regressions.
*Import the desired excel.
import excel averagewagepercentiles_A21_cleaned_NEW, firstrow clear
encode financial_year, generate(fy)
encode section_fallback, generate(A21)
*###########################################################
*Create the percentiles in real terms.
*Start with merging the consumer price index data.
merge m:1 financial_year using CPI

*Deflate the percentiles.
generate rep90_basicsalary = p90avgsalary / (CPI_UBOS/100)
generate rep50_basicsalary = p50avgsalary / (CPI_UBOS/100)
generate rep10_basicsalary = p10avgsalary / (CPI_UBOS/100)
generate remean_basicsalary = mean_avgsalary / (CPI_UBOS/100)

*Create the log differences.
generate diff_p90_p50_basicsalary = log(rep90_basicsalary) - log(rep50_basicsalary)
generate diff_p90_p10_basicsalary = log(rep90_basicsalary) - log(rep10_basicsalary)
generate diff_p50_p10_basicsalary = log(rep50_basicsalary) - log(rep10_basicsalary)

log using averagewageregressions_A21_cleaned_NEW
*Regressing log average firm wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of firms. All 19 sectors included.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Regressing log wage ratios on time trend. All 19 sectors included.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

*#############################################
*Without O-Public admin.
*Regressing log average firm wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of firms.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Regressing log wage ratios on time trend.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

*#############################################
*Without non-market services.
*Regressing log average firm wage ratios on time dummies with sector controls. All sector year pairs are weighted with the number of firms.
regress diff_p90_p50_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy i.A21 ib3.A21 if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Regressing log wage ratios on time trend.
regress diff_p90_p50_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p90_p10_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'

regress diff_p50_p10_basicsalary fy i.A21 ib3.A21 if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
display `e(r2_a)'


*#POOLED REGRESSIONS
regress diff_p90_p50_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without O
regress diff_p90_p50_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

*Without non-market
regress diff_p90_p50_basicsalary i.fy if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.fy if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.fy if A21 < 15 [aweight=nfirms], vce(cluster A21) baselevels
est table, star(0.1 0.05 0.01) keep(i.fy)
display `e(r2_a)'

log close