.DELETE_ON_ERROR:

assets_src := $(shell find assets -type f)
assets_dest := $(patsubst assets/%,dest/%,$(assets_src))

files_src := $(shell find files -type f)
files_dest := $(patsubst files/%,dest/files/%,$(files_src))

bbcode_src := $(shell find content -iname '*.bb' -type f)
html_body_build := $(patsubst content/%.bb,build/%.body.html,$(bbcode_src))
html_dest := $(patsubst build/%.body.html,dest/%.html,$(html_body_build)) dest/index.html

updates_src := $(wildcard content/en/updates/*.bb)

all: debug assets files html

debug:

clean:
	rm -rf dest/*
	rm -rf build/*

# Assets

.PHONY: assets
assets: $(assets_dest)

dest/%: assets/%
	mkdir -p $(dir $@)
	cp $^ $@

# Files

.PHONY: files
files: $(files_dest)

dest/files/%: files/%
	mkdir -p $(dir $@)
	cp $^ $@

# Content

.PHONY: html
html: $(html_dest)

dest/index.html: build/index.body.html content/en/index.meta.json en-default-meta.json template.xq
	mkdir -p $(dir $@)
	basex -i $(word 1,$^) \
		-bmeta-file-path=$(word 2,$^) \
		-bdefault-meta-file-path=$(word 3,$^) \
		-broot-path=. \
		-bdoc-path=index.html \
		template.xq > $@

dest/en/%.html: build/en/%.body.html content/en/%.meta.json en-default-meta.json template.xq
	mkdir -p $(dir $@)
	basex -i $(word 1,$^) \
		-bmeta-file-path=$(word 2,$^) \
		-bdefault-meta-file-path=$(word 3,$^) \
		-broot-path=$(shell realpath -m --relative-to $(dir $@) dest/) \
		-bdoc-path=$(shell realpath -m --relative-to dest/en/ $@) \
		template.xq > $@

dest/no/%.html: build/no/%.body.html content/no/%.meta.json no-default-meta.json template.xq
	mkdir -p $(dir $@)
	basex -i $(word 1,$^) \
		-bmeta-file-path=$(word 2,$^) \
		-bdefault-meta-file-path=$(word 3,$^) \
		-broot-path=$(shell realpath -m --relative-to $(dir $@) dest/) \
		-bdoc-path=$(shell realpath -m --relative-to dest/no/ $@) \
		template.xq > $@

# Intermediate build files

.PHONY: html-body
html-body: $(html_body_build)

build/index.body.html: content/en/index.bb
	mkdir -p $(dir $(word 1,$@))
	echo '<?xml version="1.0"?>' > $@
	echo '<body xml:space="preserve">' >> $@
	bbcode --root-path $(shell realpath -m --relative-to $(dir $@) build/) $(word 1,$^) >> $@
	echo '</body>' >> $@

build/%.body.html: content/%.bb
	mkdir -p $(dir $(word 1,$@))
	echo '<?xml version="1.0"?>' > $@
	echo '<body xml:space="preserve">' >> $@
	bbcode --root-path $(shell realpath -m --relative-to $(dir $@) build/) $(word 1,$^) >> $@
	echo '</body>' >> $@

build/en/updates.json: $(updates_src)
	mkdir -p $(dir $@)
	rm -f $@
	for src in $^; do \
		jq -n '{title: ($$date + " update"), path: $$path, published: ($$date + "T12:00:00+01:00"), content: $$content}' \
			--arg date "$$(echo $$src | sed -E -e 's/.+\/([0-9]{4}-[0-9]{2}-[0-9]{2})\.bb/\1/')" \
			--arg path "$$(echo $$src | sed -E -e 's/^content\///' -e 's/\.bb$$/.html/')" \
			--arg content "$$(bbcode < $$src)" ; \
	done | jq -s . > $@

dest/en/atom.xml: build/en/updates.json atom.xq
	basex -bupdates-file=$(word 1,$^) $(word 2,$^) > $@
	jing -c atom.rng $@

