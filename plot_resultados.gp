# Gera, a partir do arquivo de resultados produzido pelo run_experiments.sh:
#   - um grafico por algoritmo (page_faults e pages_written vs numero de frames)
#   - um grafico comparativo de page_faults entre todos os algoritmos
#
# Uso:
#   gnuplot -e "datafile='resultados_trace1.txt'" plot_resultados.gp
#
# Caso nao seja passado um datafile via -e, usa "resultados.txt" como padrao.

if (!exists("datafile")) datafile = "resultados.txt"

set terminal pngcairo size 800,600 enhanced font "Arial,11"
set datafile separator " "
set grid
set xlabel "Numero de frames"
set logscale x 2
set xtics (2,4,8,16,32,64)
set xrange [1.7:90]
set key outside right top

algoritmos = "random fifo lru sc lfu mfu"

# ---------------------------------------------------------
# Um grafico por algoritmo: page_faults e pages_written
# ---------------------------------------------------------
do for [alg in algoritmos] {
    set output sprintf("graf_%s.png", alg)
    set title sprintf("%s: page faults e pages written vs frames", alg)
    set ylabel "Quantidade (escala log)"
    set logscale y

    plot \
        datafile every ::1 using 2:(stringcolumn(1) eq alg ? column(3) : NaN) \
            with linespoints lw 2 pt 7 title "page faults", \
        datafile every ::1 using 2:(stringcolumn(1) eq alg ? column(4) : NaN) \
            with linespoints lw 2 pt 9 title "pages written"

    unset logscale y
}

# ---------------------------------------------------------
# Grafico comparativo: page_faults de todos os algoritmos
# ---------------------------------------------------------
set output "graf_comparativo_page_faults.png"
set title "Comparativo de page faults entre algoritmos"
set ylabel "Numero de page faults (escala log)"
set logscale y

plot for [alg in algoritmos] \
    datafile every ::1 using 2:(stringcolumn(1) eq alg ? column(3) : NaN) \
        with linespoints lw 2 pt 7 title alg

unset logscale y
