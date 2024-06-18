*############################################################
*Generate date variable for possible graphs.
generate year = substr(financial_year, 1, 4) if PAYE_return_month >= 7 & PAYE_return_month <= 12
replace year = substr(financial_year, 6, 4) if PAYE_return_month >= 1 & PAYE_return_month <= 6
destring(year), replace
generate date = ym(year, PAYE_return_month)
format %tm date

encode financial_year, generate(fy)
encode section_fallback, generate(A21)

*###########################################################
*Create the percentiles in real terms.
*Start with merging the consumer price index data.
merge m:1 financial_year using CPI

*Deflate the percentiles.
generate rep90_basicsalary = p90_sch1_basic_salary / (CPI_UBOS/100)
generate rep50_basicsalary = p50_sch1_basic_salary / (CPI_UBOS/100)
generate rep10_basicsalary = p10_sch1_basic_salary / (CPI_UBOS/100)

*Create the log differences.
generate diff_p90_p50_basicsalary = log(rep90_basicsalary) - log(rep50_basicsalary)
generate diff_p90_p10_basicsalary = log(rep90_basicsalary) - log(rep10_basicsalary)
generate diff_p50_p10_basicsalary = log(rep50_basicsalary) - log(rep10_basicsalary)

log using monthly_cleaned, replace
*Regressing log wage ratios on month dummies with sector controls. All sector year pairs are weighted with the number of employees which is the sector yearly average. All 19 sectors included. Manufacturing is the base sector and July 2013 is the base period.
regress diff_p90_p50_basicsalary i.date i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.date i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.date i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

*Regressing log wage ratios on a time trend. All 19 sectors included. Manufacturing is the base sector.
regress diff_p90_p50_basicsalary date i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

regress diff_p90_p10_basicsalary date i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary date i.A21 ib3.A21 if A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

*##########################################
*Without O-Public admin.
regress diff_p90_p50_basicsalary i.date i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.date i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.date i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

*Regressing log wage ratios on a time trend.
regress diff_p90_p50_basicsalary date i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

regress diff_p90_p10_basicsalary date i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary date i.A21 ib3.A21 if A21 != 15 & A21 != 20 & A21 != 21 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

*##########################################
*Without non-market services.
regress diff_p90_p50_basicsalary i.date i.A21 ib3.A21 if A21 < 15 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

regress diff_p90_p10_basicsalary i.date i.A21 ib3.A21 if A21 < 15 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

regress diff_p50_p10_basicsalary i.date i.A21 ib3.A21 if A21 < 15 [aweight=nemployees], vce(cluster A21)
est table, star(0.1 0.05 0.01) keep(i.date)
display `e(r2_a)'

*Regressing log wage ratios on a time trend.
regress diff_p90_p50_basicsalary date i.A21 ib3.A21 if A21 < 15 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

regress diff_p90_p10_basicsalary date i.A21 ib3.A21 if A21 < 15 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'

regress diff_p50_p10_basicsalary date i.A21 ib3.A21 if A21 < 15 [aweight=nemployees], vce(cluster A21)
display `e(r2_a)'


log close



bysort A21: generate basediff_p90_p50_basicsalary = diff_p90_p50_basicsalary if date == 642
sort A21 date
replace basediff_p90_p50_basicsalary = basediff_p90_p50_basicsalary[_n-1] if missing(basediff_p90_p50_basicsalary) & A21[_n-1] == A21[_n] 

bysort A21: generate basediff_p90_p25_basicsalary = diff_p90_p25_basicsalary if date == 642
sort A21 date
replace basediff_p90_p25_basicsalary = basediff_p90_p25_basicsalary[_n-1] if missing(basediff_p90_p25_basicsalary) & A21[_n-1] == A21[_n]

bysort A21: generate basediff_p90_p10_basicsalary = diff_p90_p10_basicsalary if date == 642
sort A21 date
replace basediff_p90_p10_basicsalary = basediff_p90_p10_basicsalary[_n-1] if missing(basediff_p90_p10_basicsalary) & A21[_n-1] == A21[_n]

bysort A21: generate basediff_p50_p25_basicsalary = diff_p50_p25_basicsalary if date == 642
sort A21 date
replace basediff_p50_p25_basicsalary = basediff_p50_p25_basicsalary[_n-1] if missing(basediff_p50_p25_basicsalary) & A21[_n-1] == A21[_n]

bysort A21: generate basediff_p50_p10_basicsalary = diff_p50_p10_basicsalary if date == 642
sort A21 date
replace basediff_p50_p10_basicsalary = basediff_p50_p10_basicsalary[_n-1] if missing(basediff_p50_p10_basicsalary) & A21[_n-1] == A21[_n]

replace change9050 = diff_p90_p50_basicsalary/basediff_p90_p50_basicsalary -1
replace change9025 = diff_p90_p25_basicsalary/basediff_p90_p25_basicsalary -1
replace change9010 = diff_p90_p10_basicsalary/basediff_p90_p10_basicsalary -1
replace change5025 = diff_p50_p25_basicsalary/basediff_p50_p25_basicsalary -1
replace change5010 = diff_p50_p10_basicsalary/basediff_p50_p10_basicsalary -1


generate meanchange9010 = 