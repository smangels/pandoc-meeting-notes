
FILES_SOURCE_MD := $(shell ls -1 *.md)
HTML_VOLVO_FILES = html/note.footer.html html/note.css
HTML_TARGET := $(patsubst %.md,%.html,$(FILES_SOURCE_MD))
PDF_TARGET := $(patsubst %.md,%.pdf,$(FILES_SOURCE_MD))
OPT_PANDOC_HTML := --listings -t html -s -S --toc --toc-depth 3 --section-divs -H html/note.css -N -A html/note.footer.html
OPT_PANDOC_PDF := --listings -t latex -V fontsize=12pt -s -S --toc --toc-depth 4 -N --listings --highlight-style=kate
FOLDER_OUT := out/

EXEC_PANDOC := $(shell which pandoc)


ifeq ($(EXEC_PANDOC),)
    $(error "missing Pandoc executable, Stop.")
endif

all: html pdf Makefile

%.html: %.md $(HTML_VOLVO_FILES)
	@echo " [   HTML ] $< ==> $@"
	$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_HTML) $< -o $@

html: $(HTML_TARGET)
	@echo " [   DONE ] generating HTML"

%.pdf: %.md
	@echo " [    PDF ] $< ==> $@"
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_PDF) $< -o $@

pdf: $(PDF_TARGET)
	@echo " [   DONE ] generating PDF"

.PHONY: clean
clean:
	rm -f $(HTML_TARGET)
	rm -f .done
	rm -f *.pdf
	rm -f *.html