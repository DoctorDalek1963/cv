#!/bin/bash

clean_aux_files() {
	rm -f *.log
	rm -f *.aux
	rm -f *.dvi
	rm -f *.lof
	rm -f *.lot
	rm -f *.bit
	rm -f *.idx
	rm -f *.glo
	rm -f *.bbl
	rm -f *.bcf
	rm -f *.ilg
	rm -f *.toc
	rm -f *.ind
	rm -f *.out
	rm -f *.blg
	rm -f *.fdb_latexmk
	rm -f *.fls
	rm -f *.run.xml
	rm -f *.synctex.gz

	rm -rf _minted-main/

	echo "Cleaned"
}

[ -d "/home/dyson/.texlive/2021/bin/x86_64-linux" ] && PATH="/home/dyson/.texlive/2021/bin/x86_64-linux:$PATH"

rm -f main.pdf

[ "$1" == "clean" ] && clean_aux_files

latexmk -lualatex -file-line-error -halt-on-error -interaction=nonstopmode -shell-escape -synctex=1 -cd main

clean_aux_files
