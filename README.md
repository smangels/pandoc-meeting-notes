---
title: Readme for Pandoc Meeting notes project
author: 
- Sebastian K. Mangelsen
- Stefan
date: 2015-12-20
version: 1.0
...

# pandoc-meeting-notes
This repository contains a simple template for meeting notes handled by PANDOC.

## Supported Themes

* Default
* Volvo
    - HTML: Document Header is added
    - Volvos color theme is applied
    - HTML: Source Code is framed
* Vetekornet

## Software Requirements
* make
* Pandoc (version 1.15.2)
* latex (TeX  Live 2015)

# Command Line Examples

## Generate an _ePub_ Document

### Provide a Title Page
Within an epub the title page can be set. In order to do so, place a file called `cover.jpg` or `cover.png` in the folder img. The script will pick them up when building an epub document.

Usually the format should be 150dpi and the longest side should not increase 
1000px.

~~~~{.bash}
make epub
~~~~

## Generate an HTML page
The following command generates a self-contained HTML document for each _markdown_ document that is found on in the root folder. Self contained means that the images are included as binary data.

Note that this _Make_ target does support themes. Ensure that for each theme name used the _Makefile_ expects the files `html/<theme>.css` and `html/<theme>.template.html` in the HTML folder.

~~~~{.bash}
make html THEME=volvo
~~~~

### Generate an PDF document
The following command generates an PDF document for each _markdown_ document found at root level.

~~~~{.bash}
make pdf
~~~~