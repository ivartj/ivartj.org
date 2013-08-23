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

all: dest/index.html en-tpl no-tpl assets pics

no-tpl: $(no_tpl_dest)

en-tpl: $(en_tpl_dest)

dest/no/%.html: no/%.* ${tpl} ${tpl_no}
	mkdir -p $(dir $@)
	tpl -T tpl/no -T tpl -D doc-path=$(patsubst dest/no/%,%,$@) $< > $@

dest/en/%.html: en/%.* ${tpl}
	mkdir -p $(dir $@)
	tpl -T tpl -D doc-path=$(patsubst dest/en/%,%,$@) $< > $@

assets: $(assets_dest)

dest/%: tpl/%
	mkdir -p $(dir $@)
	cp $^ $@

dest/pics/%: pics/%
	mkdir -p $(dir $@)
	cp $^ $@

dest/index.html: dest/en/index.html
	cp $^ $@

pics: $(pics_dest)
