
FILES_SOURCE_MD := $(shell ls -1 *.md)
HTML_VOLVO_FILES = html/note.footer.html html/note.css
HTML_TARGET := $(patsubst %.md,%.html,$(FILES_SOURCE_MD))
HTML_SELF_CONTAINED := $(patsubst %.md,%.self_contained.html,$(FILES_SOURCE_MD))
PDF_TARGET := $(patsubst %.md,%.pdf,$(FILES_SOURCE_MD))
EPUB_TARGET := $(patsubst %.md,%.epub,$(FILES_SOURCE_MD))
OPT_PANDOC_HTML := --listings -t html -s -S --toc --toc-depth 3 --section-divs -H html/note.css -N -A html/note.footer.html
OPT_PANDOC_PDF := --listings -t latex -V fontsize=12pt -s -S --toc --toc-depth 3 -N --listings --highlight-style=kate
OPT_PANDOC_EPUB := -t epub --epub-cover-image=img/cover.png
FOLDER_OUT := out/

EXEC_PANDOC := $(shell which pandoc)


ifeq ($(EXEC_PANDOC),)
    $(error "missing Pandoc executable, Stop.")
endif

all: html pdf epub Makefile

deploy: pdf epub html-deployable
	
html-deployable: $(HTML_SELF_CONTAINED)
	
%.self_contained.html: %.md	
	@$(EXEC_PANDOC) --self-contained -f markdown $(OPT_PANDOC_HTML) $< -o $@
	@echo " [   HTML ]: deployable"

%.html: %.md $(HTML_VOLVO_FILES)
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_HTML) $< -o $@
	@echo " [   HTML ] $< ==> $@"

html: $(HTML_TARGET)
	
epub: $(EPUB_TARGET) img/cover.png

%.epub: %.md
	@echo " [   EPUB ] $< ==> $@"
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_EPUB) $< -o $@   

%.pdf: %.md
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_PDF) $< -o $@
	@echo " [    PDF ] $< ==> $@"

pdf: $(PDF_TARGET)

.PHONY: clean
clean:
	rm -f $(HTML_TARGET)
	rm -f .done
	rm -f *.pdf
	rm -f *.html
	rm -f *.epub
	
