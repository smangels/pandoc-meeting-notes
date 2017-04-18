
FILES_SOURCE_MD := $(shell ls -1 *.md)
PLUGIN_DIR ?= .

ifeq ($(MAKECMDGOALS),book)
	FILES_BOOK_MD = $(shell ls -1 book_*.md | sort)
endif

HTML_VOLVO_FILES = $(PLUGIN_DIR)/html/note.footer.html $(PLUGIN_DIR)/html/note.css
HTML_TARGET := $(patsubst %.md,%.html,$(FILES_SOURCE_MD))
HTML_SELF_CONTAINED := $(patsubst %.md,%.self_contained.html,$(FILES_SOURCE_MD))
PDF_TARGET := $(patsubst %.md,%.pdf,$(FILES_SOURCE_MD))
EPUB_TARGET := $(patsubst %.md,%.epub,$(FILES_SOURCE_MD))
PDF_MARGINS := -V geometry:"top=2cm, bottom=2.5cm, left=3cm, right=2cm, footskip = 17mm"
PDF_FONT_SIZE := -V fontsize=12pt

#
# will be evaluated once the command is applied
#
OPT_PANDOC_HTML = --listings -t html --template $(PLUGIN_DIR)/html/$(THEME_NAME).template.html -s -S --toc --toc-depth 3 --section-divs -H html/$(THEME_NAME).css -N -A html/note.footer.html
OPT_PANDOC_PDF = --listings -t latex $(PDF_MARGINS) $(PDF_FONT_SIZE) --template $(PLUGIN_DIR)/pdf/$(THEME_NAME).template.tex -s -S --toc --toc-depth 3 -N --listings --highlight-style=kate
OPT_PANDOC_BOOK = --listings -t latex $(PDF_MARGINS) $(PDF_FONT_SIZE) --template $(PLUGIN_DIR)/pdf/book.template.latex -s -S --toc --toc-depth 3 -N --highlight-style=kate
OPT_PANDOC_EPUB = -t epub --epub-cover-image=img/cover.png

FOLDER_OUT := out/
FILES += $(PDF_TARGET) $(EPUB_TARGET) $(HTML_SELF_CONTAINED)
EXEC_PANDOC := $(shell which pandoc)


ifneq ($(THEME),)
	THEME_NAME := $(THEME)
else
	THEME_NAME := default
endif


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

book: book.pdf

book.pdf: $(FILES_BOOK_MD) Makefile
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_BOOK) $(filter %.md,$(FILES_BOOK_MD)) -o $@
	@echo " [   BOOK ] $(filter %.md,$^) ==> $@"

%.self_contained.html: %.md Makefile
	@$(EXEC_PANDOC) --self-contained -f markdown $(OPT_PANDOC_HTML) $(filter %.md,$^) -o $@
	@echo " [   HTML ] $(filter %.md,$^) ==> $@"

%.html: %.md Makefile
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_HTML) $(filter %.md,$^) -o $@
	@echo " [   HTML ] $(filter %.md,$^) ==> $@"

%.epub: %.md Makefile
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_EPUB) $(filter %.md,$^) -o $@   
	@echo " [   EPUB ] $(filter %.md,$^) ==> $@"

%.pdf: %.md Makefile
	@$(EXEC_PANDOC) -f markdown $(OPT_PANDOC_PDF) $(filter %.md,$^) -o $@
	@echo " [    PDF ] $(filter %.md,$^) ==> $@"

.PHONY: clean
clean:
	rm -f $(HTML_TARGET)
	rm -f .done
	rm -f *.pdf
	rm -f *.html
	rm -f *.epub
	rm -f *.tar.gz
	
