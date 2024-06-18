///Install: ssc inst _gwtmean
*This the code for how to find the best month for each A21 level sector.
*Tag each sector-month combination.
egen sector_month_tag = tag(section_fallback PAYE_return_month)

generate outliercount = 0

*Generate annual weighted averages of the percentiles for each sector-year.
egen p90meansalary = wtmean(p90_sch1_basic_salary), weight(nemployees) by(section_fallback financial_year)
egen p50meansalary = wtmean(p50_sch1_basic_salary), weight(nemployees) by(section_fallback financial_year)
egen p10meansalary = wtmean(p10_sch1_basic_salary), weight(nemployees) by(section_fallback financial_year)

*Generate differences from the averages for each row i.e. sector-month-year.
generate difp90meansalary = p90_sch1_basic_salary - p90meansalary
generate absdifp90meansalary = abs(p90_sch1_basic_salary - p90meansalary)
generate difp50meansalary = p50_sch1_basic_salary - p50meansalary
generate absdifp50meansalary = abs(p50_sch1_basic_salary - p50meansalary)
generate difp10meansalary = p10_sch1_basic_salary - p10meansalary
generate absdifp10meansalary = abs(p10_sch1_basic_salary - p10meansalary)

*Generate minimum and maximum of differences for each sector-year and find the minimum distance from the weighted average for each percentile. 
egen mindifp90meansalary = min(difp90meansalary), by(section_fallback financial_year)
egen maxdifp90meansalary = max(difp90meansalary), by(section_fallback financial_year)
egen closedifp90meansalary = min(absdifp90meansalary), by(section_fallback financial_year)

egen mindifp50meansalary = min(difp50meansalary), by(section_fallback financial_year)
egen maxdifp50meansalary = max(difp50meansalary), by(section_fallback financial_year)
egen closedifp50meansalary = min(absdifp50meansalary), by(section_fallback financial_year)

egen mindifp10meansalary = min(difp10meansalary), by(section_fallback financial_year)
egen maxdifp10meansalary = max(difp10meansalary), by(section_fallback financial_year)
egen closedifp10meansalary = min(absdifp10meansalary), by(section_fallback financial_year)

*Grow the outlier count for each sector-month-year row by 1 if the month is either the minimum or maximum value month but not at the same time closest to to the average. 
replace outliercount = outliercount + 1 if (difp90meansalary == mindifp90meansalary | maxdifp90meansalary ==  difp90meansalary) & absdifp90meansalary != closedifp90meansalary
replace outliercount = outliercount + 1 if (difp50meansalary == mindifp50meansalary | maxdifp50meansalary ==  difp50meansalary) & absdifp50meansalary != closedifp50meansalary
replace outliercount = outliercount + 1 if (difp10meansalary == mindifp10meansalary | maxdifp10meansalary ==  difp10meansalary) & absdifp10meansalary != closedifp10meansalary

*For each sector-month pair create the total number of outliers.
egen sectoroutliercount = total(outliercount), by(section_fallback PAYE_return_month)

*Generate the sum of proportional deviations for each sector-month-year.
generate deviation = absdifp10meansalary/p10_sch1_basic_salary + absdifp50meansalary/p50_sch1_basic_salary + absdifp90meansalary/p90_sch1_basic_salary
*If there was one or more zero percentiles for sector-year-month replace the missing deviation variable with 100 to easily recognize these months. 
replace deviation = 100 if missing(deviation)
*For each sector-month pair create the total sum of deviations.
egen deviationsum = total(deviation), by(section_fallback PAYE_return_month)

*Organize the data for easier investigation.
order PAYE_return_month section_fallback, last
order sector_month_tag
gsort -sector_month_tag section_fallback deviationsum sectoroutliercount 

*Check how the months rank.
egen outliers_per_month = total(outliercount), by(PAYE_return_month)
gsort -sector_month_tag outliers_per_month
egen deviation_per_month = total(deviation), by(PAYE_return_month)
gsort -sector_month_tag deviation_per_month