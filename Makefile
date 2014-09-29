# Name of your emacs binary
EMACS = emacs

BATCH = $(EMACS) --batch -Q --eval '(require (quote org))'			\
	--eval '(org-babel-do-load-languages (quote org-babel-load-languages)   \
		(quote((sh . t))))'						\
	--eval '(setq org-confirm-babel-evaluate nil)'                          \
	--eval "(setq org-babel-use-quick-and-dirty-noweb-expansion t)"

FILES  = $(wildcard *.org)
FILESO = $(FILES:%.org=.%.tangle)

all: org

org: $(FILESO)

.%.tangle: %.org
	@echo "NOTICE: Tangling $< file..."
	@$(BATCH) --eval '(org-babel-tangle-file "$<")' > /dev/null 2>&1
	@if [ -x latex-templates.sh ]; then ./latex-templates.sh; fi
	@touch $@

clean:
	@if [ -x latex-templates.sh ]; then ./latex-templates.sh clean; fi
	@rm -f .*.tangle *.tar.gz *.conf *.aux *.tex *.fls *fdb_latexmk *.log *.pdf doc/*html *~
	@rm -f *.sty *.sh
	@rm -rf doc
