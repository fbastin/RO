set terminal table; set output "IFT1575.pgf-plot.table"; set format "%.5f"
set samples 25; plot [x=0:2.1] 6-x*(1+x)
