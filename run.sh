#!/bin/bash
#
# Script de automacao da Atividade 3.1 - Simulador de Memoria Virtual
#
# Executa o simulador para um unico arquivo de trace, variando:
#   - o algoritmo de substituicao de paginas (random, fifo, lru, sc, lfu, mfu)
#   - o numero de frames disponiveis (2, 4, 8, 16, 32, 64)
#
# Uso:
#   ./run_experiments.sh <traceFile> <executavel> <arquivo_saida.txt>
#
# Exemplo:
#   ./run_experiments.sh trace1.trace ./simulador resultados_trace1.txt

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <traceFile> <executavel> <arquivo_saida>"
    exit 1
fi

TRACE="$1"
SIMULADOR="$2"
SAIDA="$3"

if [ ! -f "$TRACE" ]; then
    echo "Erro: arquivo de trace '$TRACE' nao encontrado."
    exit 1
fi

if [ ! -x "$SIMULADOR" ]; then
    echo "Erro: executavel '$SIMULADOR' nao encontrado ou sem permissao de execucao."
    exit 1
fi

ALGORITMOS=(random fifo lru sc lfu mfu)
FRAMES=(2 4 8 16 32 64)

# cabecalho do arquivo de saida (separado por espaco, facil de ler com
# pandas.read_csv(sep=" ") ou numpy.loadtxt(skiprows=1) depois, por exemplo)
echo "algoritmo frames page_faults pages_written" > "$SAIDA"

for alg in "${ALGORITMOS[@]}"; do
    for f in "${FRAMES[@]}"; do
        echo "Executando: trace=$TRACE algoritmo=$alg frames=$f"

        resultado=$("$SIMULADOR" "$TRACE" "$f" "$alg")

        faults=$(echo "$resultado" | grep "page faults" | grep -o '[0-9]\+')
        written=$(echo "$resultado" | grep "pages written" | grep -o '[0-9]\+')

        echo "$alg $f $faults $written" >> "$SAIDA"
    done
done

echo ""
echo "Concluido. Resultados salvos em: $SAIDA"