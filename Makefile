pics_ext = jpg png
assets_ext = css $(pics_ext)
tpl_ext = $(patsubst tpl/%.tpl,%,$(wildcard tpl/*.tpl))

tpl = $(wildcard tpl/*.tpl)
tpl_no = $(wildcard tpl/no/*.tpl)

pics_src = $(shell find pics -name '' $(patsubst %,-or -name *.%,$(pics_ext)))
pics_dest = $(patsubst %,dest/%,$(pics_src))

en_tpl_src = $(shell find en -name '' $(patsubst %,-or -name *.%,$(tpl_ext)))
no_tpl_src = $(shell find no -name '' $(patsubst %,-or -name *.%,$(tpl_ext)))

no_tpl_dest = $(foreach ext,${tpl_ext},$(patsubst no/%.${ext},dest/no/%.html,${no_tpl_src}))
en_tpl_dest = $(foreach ext,${tpl_ext},$(patsubst en/%.${ext},dest/en/%.html,${en_tpl_src}))

assets_src = $(shell find tpl -name '' $(patsubst %,-or -name *.%,$(assets_ext)))
assets_dest = $(patsubst tpl/%,dest/%,$(assets_src))

files_dest = $(patsubst files/%,dest/files/%,$(wildcard files/*))

all: debug dest/index.html en-tpl no-tpl assets pics files

debug:
	@echo en_tpl_src=${en_tpl_src}
	@echo no_tpl_src=${no_tpl_src}

clean:
	rm -rf dest/*

no-tpl: $(no_tpl_dest)

en-tpl: $(en_tpl_dest)

dest/no/%.html: no/%.bb ${tpl} ${tpl_no}
	mkdir -p $(dir $@)
	tpl -T tpl/no -T tpl -D doc-path=$(patsubst dest/no/%,%,$@) $(patsubst dest/no/%.html,no/%.*,$@) -o $@

dest/no/%.html: no/%.md ${tpl} ${tpl_no}
	mkdir -p $(dir $@)
	tpl -T tpl/no -T tpl -D doc-path=$(patsubst dest/no/%,%,$@) $(patsubst dest/no/%.html,no/%.*,$@) -o $@

dest/no/%.html: no/%.body.html ${tpl} ${tpl_no}
	mkdir -p $(dir $@)
	tpl -T tpl/no -T tpl -D doc-path=$(patsubst dest/no/%,%,$@) $(patsubst dest/no/%.html,no/%.*,$@) -o $@

dest/en/%.html: en/%.bb ${tpl}
	mkdir -p $(dir $@)
	tpl -T tpl -D doc-path=$(patsubst dest/en/%,%,$@) $(patsubst dest/en/%.html,en/%.*,$@) -o $@

dest/en/%.html: en/%.md ${tpl}
	mkdir -p $(dir $@)
	tpl -T tpl -D doc-path=$(patsubst dest/en/%,%,$@) $(patsubst dest/en/%.html,en/%.*,$@) -o $@

dest/en/%.html: en/%.body.html ${tpl}
	mkdir -p $(dir $@)
	tpl -T tpl -D doc-path=$(patsubst dest/en/%,%,$@) $(patsubst dest/en/%.html,en/%.*,$@) -o $@

assets: $(assets_dest)

files: $(files_dest)

dest/files/%: files/%
	mkdir -p $(dir $@)
	cp $^ $@

dest/%: tpl/%
	mkdir -p $(dir $@)
	cp $^ $@

pics: $(pics_dest)

dest/pics/%: pics/%
	mkdir -p $(dir $@)
	cp $^ $@

dest/index.html: dest/en/index.html
	cp $^ $@
