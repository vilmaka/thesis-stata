*########################################################
*Create a categorical variable that groups firms based on how their observations are matched.
egen firm_merge1_count1 = total(_merge == 1), by(c_firm_id)
egen firm_merge2_count1 = total(_merge == 2), by(c_firm_id)
egen firm_merge3_count1 = total(_merge == 3), by(c_firm_id)

generate match1 = .

*Firms with only matched observations:
replace match1 = 1 if firm_merge1_count1 == 0 & firm_merge2_count1 == 0 & firm_merge3_count1 > 0

*Firms with all CIT observations matched but some unmathed PAYE observations:
replace match1 = 2 if firm_merge1_count1 > 0 & firm_merge2_count1 == 0 & firm_merge3_count1 > 0

*Firms with only unmatched PAYE observations:
replace match1 = 3  if  firm_merge1_count1 > 0 & firm_merge2_count1 == 0 & firm_merge3_count1 == 0

*Firms with only unmatched CIT observations:
replace match1 = 4 if firm_merge1_count1 == 0 & firm_merge2_count1 > 0 & firm_merge3_count1 == 0 

*Firms with all PAYE observations matched but some unmatched CIT observations:
replace match1 = 5 if firm_merge1_count1 == 0 & firm_merge2_count1 > 0 & firm_merge3_count1 > 0

*Firms with some matched observations and both some unmatched PAYE and CIT observations:
replace match1 = 6 if firm_merge1_count1 > 0 & firm_merge2_count1 > 0 & firm_merge3_count1 > 0

*Firms with both PAYE and CIT observations but from different years i.e. no matching observations/years.
replace match1 = 7 if firm_merge1_count1 > 0 & firm_merge2_count1 > 0 & firm_merge3_count1 == 0

label define match_labels 1 "Only matches" 2 "Full CIT Partial PAYE" 3 "Only in PAYE" 4 "Only in CIT" 5 "Full PAYE Partial CIT" 6 "Partial CIT Partial PAYE" 7 "In both No matches"
label values match1 match_labels

*Count if there are observations that do not belong to any group.
count if missing(match1)

*Check the number of firms in each group.
forvalues i = 1/7 {
	distinct c_firm_id if match1 == `i'
	display "There are " r(ndistinct) " firms in group " `i' "."
}