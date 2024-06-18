graph set window fontface "Times New Roman"

twoway (line meanchange9010_sing fy, lcolor("balck") lpattern("dash")) (line meanchange9050_sing fy, lcolor("balck") lpattern("solid")), title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend nogrid) ytitle(" ") xtitle(" ") ylabel(, nogrid) legend(label(1 "Single month estimates") label(2 "Averaged estimates"))

encode financial_year, generate(fy)
twoway (line meanchange9010_avgwage fy) (line meanchange9050_avgwage fy) (line meanchange5010_avgwage fy), title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend) ytitle(" ") xtitle(" ") ylabel(, gextend) legend(label(1 "90/10 ratio") label(2 "90/50 ratio") label(3 "50/10 ratio")) ylabel(-0.12(0.02)0.1, gmin gmax)

twoway (line meanchange9010_sales fy) (line meanchange9050_sales fy) (line meanchange5010_sales fy), title(" ") xtick(1/9 2) xlabel(1 " " 2 "2014-2015" 3 " " 4 "2016-2017" 5 " " 6 "2018-2019" 7 " " 8 "2020-2021" 9 " ", gextend) ytitle(" ") xtitle(" ") ylabel(, gextend) legend(label(1 "90/10 ratio") label(2 "90/50 ratio") label(3 "50/10 ratio")) ylabel(-0.08(0.02)0.14, gmin gmax)