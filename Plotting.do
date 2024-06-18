graph set window fontface "Times New Roman"

twoway (line S9010_ratio fy, lcolor("balck") lpattern("dash")) (line A9010_ratio fy, lcolor("balck") lpattern("solid")), title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(, nogrid) legend(label(1 "Single month estimates") label(2 "Averaged estimates"))

twoway (line S9050_ratio fy, lcolor("balck") lpattern("longdash")) (line A9050_ratio fy, lcolor("balck") lpattern("solid")) , title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(, nogrid) legend(label(1 "Single month estimates 90/50") label(2 "Averaged estimates 90/50") label(3 "Single month estimates 50/10") label(4 "Averaged estimates 50/10"))



(line S5010_ratio fy, lcolor("balck") lpattern("dot")) (line A5010_ratio fy, lcolor("balck") lpattern("shortdash"))



generate base9010 = diff_p90_p10_basicsalary if fy == 1
sort A21 fy
replace base9010 = base9010[_n-1] if missing(base9010) & A21[_n-1] == A21[_n]

generate base9050 = diff_p90_p50_basicsalary if fy == 1
sort A21 fy
replace base9050 = base9050[_n-1] if missing(base9050) & A21[_n-1] == A21[_n]

generate base5010 = diff_p50_p10_basicsalary if fy == 1
sort A21 fy
replace base5010 = base5010[_n-1] if missing(base5010) & A21[_n-1] == A21[_n]

generate change9010 = diff_p90_p10_basicsalary/base9010 - 1

generate change9050 = diff_p90_p50_basicsalary/base9050 - 1

generate change5010 = diff_p50_p10_basicsalary/base5010 - 1


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


collapse (mean) avg_sectorsize rep90_basicsalary rep50_basicsalary rep10_basicsalary [aweight = nemployees], by(financial_year section_fallback)

encode financial_year, generate(fy)
encode section_fallback, generate(A21)

generate diff_p90_p50_basicsalary = log(rep90_basicsalary) - log(rep50_basicsalary)
generate diff_p90_p10_basicsalary = log(rep90_basicsalary) - log(rep10_basicsalary)
generate diff_p50_p10_basicsalary = log(rep50_basicsalary) - log(rep10_basicsalary)


generate base9010 = diff_p90_p10_basicsalary if fy == 1
sort A21 fy
replace base9010 = base9010[_n-1] if missing(base9010) & A21[_n-1] == A21[_n]

generate base9050 = diff_p90_p50_basicsalary if fy == 1
sort A21 fy
replace base9050 = base9050[_n-1] if missing(base9050) & A21[_n-1] == A21[_n]

generate base5010 = diff_p50_p10_basicsalary if fy == 1
sort A21 fy
replace base5010 = base5010[_n-1] if missing(base5010) & A21[_n-1] == A21[_n]

generate change9010 = diff_p90_p10_basicsalary/base9010 - 1

generate change9050 = diff_p90_p50_basicsalary/base9050 - 1

generate change5010 = diff_p50_p10_basicsalary/base5010 - 1
graph set window fontface "Times New Roman"
graph set window textstylesize "small"

twoway (line change9010 fy if A21 == 1) (line change9010 fy if A21 == 2) (line change9010 fy if A21 == 3) (line change9010 fy if A21 == 4) (line change9010 fy if A21 == 5) (line change9010 fy if A21 == 6) (line change9010 fy if A21 == 7) (line change9010 fy if A21 == 8) (line change9010 fy if A21 == 9) (line change9010 fy if A21 == 10) (line change9010 fy if A21 == 11) (line change9010 fy if A21 == 12) (line change9010 fy if A21 == 13) (line change9010 fy if A21 == 14) (line change9010 fy if A21 == 15) (line change9010 fy if A21 == 16) (line change9010 fy if A21 == 17) (line change9010 fy if A21 == 18) (line change9010 fy if A21 == 19), legend(cols(2) position(6) label(1 "A-Agricult...") label(2 "B-Mining...") label(3 "C-Manufact.") label(4 "D-Electricity...") label(5 "E-Water supply...") label(6 "F-Construction") label(7 "G-Wholesale...") label(8 "H-Transport...") label(9 "I-Accommodation...") label(10 "J-Information...") label(11 "K-Financial...") label(12 "L-Real est...") label(13 "M-Professional...") label(14 "N-Administrative...") label(15 "O-Public admin...") label(16 "P-Education") label(17 "Q-Human health...") label(18 "R-Arts, entert...") label(19 "S-Other serv...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(, nogrid)
graph set window fontface "Times New Roman"
twoway (line change9010 fy if A21 == 1) (line change9010 fy if A21 == 2) (line change9010 fy if A21 == 3) (line change9010 fy if A21 == 4) (line change9010 fy if A21 == 5) (line change9010 fy if A21 == 6) (line change9010 fy if A21 == 7) (line change9010 fy if A21 == 8) (line change9010 fy if A21 == 9) (line change9010 fy if A21 == 10) (line change9010 fy if A21 == 11) (line change9010 fy if A21 == 12) (line change9010 fy if A21 == 13) (line change9010 fy if A21 == 14), legend(label(1 "A-Agricult...") label(2 "B-Mining...") label(3 "C-Manufact.") label(4 "D-Electricity...") label(5 "E-Water supply...") label(6 "F-Construction") label(7 "G-Wholesale...") label(8 "H-Transport...") label(9 "I-Accommodation...") label(10 "J-Information...") label(11 "K-Financial...") label(12 "L-Real est...") label(13 "M-Professional...") label(14 "N-Administrative...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(, nogrid) ytick(-0.5(0.1)0.5)

twoway (line change9010 fy if A21 == 15) (line change9010 fy if A21 == 16) (line change9010 fy if A21 == 17) (line change9010 fy if A21 == 18) (line change9010 fy if A21 == 19), legend(label(1 "O-Public admin...") label(2 "P-Education") label(3 "Q-Human health...") label(4 "R-Arts, entert...") label(5 "S-Other serv...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(, nogrid) yscale(range(-0.40 0.40)) ytick(-0.5(0.1)0.5)




*#######################
twoway (line change9010 fy if A21 == 1) (line change9010 fy if A21 == 2) (line change9010 fy if A21 == 3) (line change9010 fy if A21 == 4) (line change9010 fy if A21 == 5) (line change9010 fy if A21 == 6) (line change9010 fy if A21 == 7) (line change9010 fy if A21 == 8) (line change9010 fy if A21 == 9) (line change9010 fy if A21 == 10) (line change9010 fy if A21 == 11) (line change9010 fy if A21 == 12) (line change9010 fy if A21 == 13) (line change9010 fy if A21 == 14), legend(label(1 "A-Agricult...") label(2 "B-Mining...") label(3 "C-Manufact...") label(4 "D-Electricity...") label(5 "E-Water supply...") label(6 "F-Construction") label(7 "G-Wholesale...") label(8 "H-Transport...") label(9 "I-Accommodation...") label(10 "J-Information...") label(11 "K-Financial...") label(12 "L-Real est...") label(13 "M-Professional...") label(14 "N-Administrative...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(-0.5(0.1)1.4, gmin)

twoway (line change9010 fy if A21 == 15) (line change9010 fy if A21 == 16) (line change9010 fy if A21 == 17) (line change9010 fy if A21 == 18) (line change9010 fy if A21 == 19), legend(label(1 "O-Public admin...") label(2 "P-Education") label(3 "Q-Human health...") label(4 "R-Arts, entert...") label(5 "S-Other serv...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(-0.5(0.1)1.4, gmin)




twoway (line change9050 fy if A21 == 1) (line change9050 fy if A21 == 2) (line change9050 fy if A21 == 3) (line change9050 fy if A21 == 4) (line change9050 fy if A21 == 5) (line change9050 fy if A21 == 6) (line change9050 fy if A21 == 7) (line change9050 fy if A21 == 8) (line change9050 fy if A21 == 9) (line change9050 fy if A21 == 10) (line change9050 fy if A21 == 11) (line change9050 fy if A21 == 12) (line change9050 fy if A21 == 13) (line change9050 fy if A21 == 14), legend(label(1 "A-Agricult...") label(2 "B-Mining...") label(3 "C-Manufact...") label(4 "D-Electricity...") label(5 "E-Water supply...") label(6 "F-Construction") label(7 "G-Wholesale...") label(8 "H-Transport...") label(9 "I-Accommodation...") label(10 "J-Information...") label(11 "K-Financial...") label(12 "L-Real est...") label(13 "M-Professional...") label(14 "N-Administrative...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(-0.5(0.1)0.5, gmin)

twoway (line change9050 fy if A21 == 15) (line change9050 fy if A21 == 16) (line change9050 fy if A21 == 17) (line change9050 fy if A21 == 18) (line change9050 fy if A21 == 19), legend(label(1 "O-Public admin...") label(2 "P-Education") label(3 "Q-Human health...") label(4 "R-Arts, entert...") label(5 "S-Other serv...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(-0.5(0.1)0.5, gmin)


twoway (line change5010 fy if A21 == 1) (line change5010 fy if A21 == 2) (line change5010 fy if A21 == 3) (line change5010 fy if A21 == 4) (line change5010 fy if A21 == 5) (line change5010 fy if A21 == 6) (line change5010 fy if A21 == 7) (line change5010 fy if A21 == 8) (line change5010 fy if A21 == 9) (line change5010 fy if A21 == 10) (line change5010 fy if A21 == 11) (line change5010 fy if A21 == 12) (line change5010 fy if A21 == 13) (line change5010 fy if A21 == 14), legend(label(1 "A-Agricult...") label(2 "B-Mining...") label(3 "C-Manufact...") label(4 "D-Electricity...") label(5 "E-Water supply...") label(6 "F-Construction") label(7 "G-Wholesale...") label(8 "H-Transport...") label(9 "I-Accommodation...") label(10 "J-Information...") label(11 "K-Financial...") label(12 "L-Real est...") label(13 "M-Professional...") label(14 "N-Administrative...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(-0.4(0.1)0.6, gmin)

twoway (line change5010 fy if A21 == 15) (line change5010 fy if A21 == 16) (line change5010 fy if A21 == 17) (line change5010 fy if A21 == 18) (line change5010 fy if A21 == 19), legend(label(1 "O-Public admin...") label(2 "P-Education") label(3 "Q-Human health...") label(4 "R-Arts, entert...") label(5 "S-Other serv...")) title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(-0.4(0.2)2.9, gmin)






destring change9010, generate(change)
encode section_fallback, generate(A21)

encode financial_year, generate(fy)
destring avg_sectorsize, generate(size)
destring nfirms, generate(firms)
sort A21 financial_year
sort financial_year
by financial_year: egen meanchange2 = wtmean(change) if A21 >= 2 & A21 <= 5, weight(firms)

by financial_year: egen meanchange4 = wtmean(change) if A21 >= 7 & A21 <= 9, weight(firms)

by financial_year: egen meanchange8 = wtmean(change) if A21 >= 13 & A21 <= 14, weight(firms)

by financial_year: egen meanchange9 = wtmean(change) if A21 >= 15 & A21 <= 17, weight(firms)

by financial_year: egen meanchange10 = wtmean(change) if A21 >= 18 & A21 <= 19, weight(firms)


line change1 change2 change3 change4 change5 change6 change7 chnage8 change9 change10 fy, title(" ") xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") legend(label(1 "A") label(2 "B-E") label(3 "F") label(4 "G-I") label(5 "J") label(6 "K") label(7 "L") label(8 "M-N") label(9 "O-Q") label(10 "R-S"))