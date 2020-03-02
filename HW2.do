





*HW 2


use "\\files\users\rchicola\Desktop\ECON 758\taxEducSample.dta" 
     
drop if grossincr1000 ==.
drop if persno ==.
drop if year ==.
drop if nchild ==.
drop if married==.
drop if selfemp ==.
drop if mtr ==.
drop if mtr_02 ==.
*drop if entrepreneur ==.




*Part B
sum  


tabstat nchild married grossincr1000 mtr mtr_02 entrepreneur, stat(n mean sd) save
*Look at size of matrix in r environment
return list
*List the values of the matrix 
matrix list r(StatTotal)
*Convert "special" matrix to a "typical" matrix
matrix stats = r(StatTotal)
*Convert scalar (like the mean) into a macro
local avg= nchild_avg = [2,1]



eststo summary:  estpost summarize nchild married grossincr1000 mtr mtr_02 entrepreneur

esttab summary using SumTable1.rtf, rtf cell(mean sd) title("Sum Stats")replace
 


xtset persno year, delta(5)


gen ID =_n

bysort year: egen GIR1 = grossincr1000/l.grossincr1000 

gen GIR = (grossincr1000/l.grossincr1000)
 


gen MTR_ratio = (mtr/l.mtr)


*NO LOGS
xtreg GIR  MTR_ratio l.grossincr1000 married nchild




gen Lag_GI = L1.grossincr1000 
gen GIR = grossincr1000/L1.grossincr1000 

gen Lag_MTR =L1.mtr
gen MIR =  mtr/L1.mtr


xtreg GIR MIR L1.grossincr1000  married nchild
eststo nolog_OLS

esttab  using nolog_OLS.rtf, rtf se  star(* 0.10 ** 0.05 *** 0.01) title("OLS without Logs") mtitle("nolog_OLS") scalars(r2 F) replace
 
*Ask FOssen about xtreg vs regular reg 
*reg GIR MIR L1.grossincr1000  married nchild

**

xtreg GIR mtr L1.grossincr1000  married nchild

gen log_mtr = ln(mtr)
gen log_lagged_mtr = ln(L1.mtr)

gen LOG_MIR = ln(MIR)

gen log_lag_GI = ln(L1.grossincr1000)

gen log_GIR = ln(GIR)

xtreg log_GIR LOG_MIR  L1.grossincr1000  married nchild

***with log mtr

xtreg GIR LOG_MIR  L1.grossincr1000  married nchild
*xtreg grossincr1000 MIR L1.grossincr1000  married nchild

*xtreg grossincr1000 mtr L1.grossincr1000  married nchild


xtreg grossincr1000 LOG_MIR L1.grossincr1000  married nchild






