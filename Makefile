
FILES_SOURCE_MD := $(shell ls -1 *.md)
HTML_VOLVO_FILES = html/note.footer.html html/note.css
HTML_TARGET := $(patsubst %.md,%.html,$(FILES_SOURCE_MD))
HTML_SELF_CONTAINED := $(patsubst %.md,%.self_contained.html,$(FILES_SOURCE_MD))
PDF_TARGET := $(patsubst %.md,%.pdf,$(FILES_SOURCE_MD))
EPUB_TARGET := $(patsubst %.md,%.epub,$(FILES_SOURCE_MD))

THEME_NAME := default
FILES += $(PDF_TARGET) $(EPUB_TARGET) $(HTML_SELF_CONTAINED)

OPT_PANDOC_HTML := --listings -t html --template html/template.html -s -S --toc --toc-depth 3 --section-divs -H html/$(THEME_NAME).css -N -A html/note.footer.html
OPT_PANDOC_PDF := --listings -t latex -V fontsize=12pt --template pdf/template.tex -s -S --toc --toc-depth 3 -N --listings --highlight-style=kate
OPT_PANDOC_EPUB := -t epub --epub-cover-image=img/cover.png
FOLDER_OUT := out/

EXEC_PANDOC := $(shell which pandoc)


ifeq ($(EXEC_PANDOC),)
    $(error "missing Pandoc executable, Stop.")
endif

all: html pdf epub Makefile

deploy: meeting.deploy.tar.gz

meeting.deploy.tar.gz: pdf html-deployable epub
	@tar -czf $@ $(FILES)
	@echo " [ TAR.GZ ] ==> $@"
	
html-deployable: $(HTML_SELF_CONTAINED)

html: $(HTML_TARGET)
	
epub: $(EPUB_TARGET)

pdf: $(PDF_TARGET)
	
%.self_contained.html: %.md
	@$(EXEC_PANDOC) --self-contained -f markdown $(OPT_PANDOC_HTML) $< -o $@
	@echo " [   HTML ] $< ==> $@"

%.html: %.md
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_HTML) $< -o $@
	@echo " [   HTML ] $< ==> $@"

%.epub: %.md
	@echo " [   EPUB ] $< ==> $@"
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_EPUB) $< -o $@   

%.pdf: %.md
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_PDF) $< -o $@
	@echo " [    PDF ] $< ==> $@"

.PHONY: clean
clean:
	rm -f $(HTML_TARGET)
	rm -f .done
	rm -f *.pdf
	rm -f *.html
	rm -f *.epub
	rm -f *.tar.gz
	
