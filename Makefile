# Name of your emacs binary
EMACS = emacs

BATCH = $(EMACS) --batch -Q --eval '(require (quote org))'			\
	--eval '(org-babel-do-load-languages (quote org-babel-load-languages)   \
		(quote((sh . t))))'						\
	--eval '(setq org-confirm-babel-evaluate nil)'

FILES  = $(wildcard *.org)
FILESO = $(FILES:%.org=.%.tangle)

all: org

org: $(FILESO)

.%.tangle: %.org
	@echo "Tangling $< file"
	@$(BATCH) --eval '(org-babel-tangle-file "$<")'
	@if [ -x latex-templates.sh ]; then ./latex-templates.sh; fi
	@touch $@

doc: doc/index.html

doc/index.html:
	mkdir -p doc
	$(EMACS) --batch -Q --eval '(org-babel-load-file "starter-kit-publish.org")'
	rm starter-kit-publish.el
	cp doc/starter-kit.html doc/index.html
	echo "Documentation published to doc/"

clean: org
	@if [ -x latex-templates.sh ]; then ./latex-templates.sh clean; fi
	@rm -f .*.tangle *.tar.gz *.conf *.aux *.tex *.fls *fdb_latexmk *.log *.pdf doc/*html *~
	@rm -f *.sty *.sh
	@rm -rf doc current $(GIT_BRANCH)
