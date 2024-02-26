# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

IMAGES := $(filter-out $(wildcard $(SOURCEDIR)/_images/*.thumb.jpg),$(wildcard $(SOURCEDIR)/_images/*.jpg))
THUMBS := $(patsubst %.jpg,%.thumb.jpg,$(IMAGES))

$(SOURCEDIR)/_images/%.jpg:

.SECONDARY: $(THUMBS)

$(SOURCEDIR)/_images/%.thumb.jpg: $(SOURCEDIR)/_images/%.jpg
	convert $< -scale 12.5% $@

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile $(THUMBS)
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	cp $(IMAGES) "$(BUILDDIR)/html/_images/"
