pics_ext = jpg png
assets_ext = css $(pics_ext)
tpl_ext = $(patsubst tpl/%.tpl,%,$(wildcard tpl/*.tpl))

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

# TODO: be more specific regarding dependencies
dest/no/%.html: $(no_tpl_src)
	mkdir -p $(dir $@)
	tpl -T tpl/no -T tpl -D doc-path=$(patsubst dest/no/%,%,$@) $(filter $(patsubst dest/%.html,%,$@).%,$(no_tpl_src)) > $@

dest/en/%.html: $(en_tpl_src)
	mkdir -p $(dir $@)
	tpl -T tpl -D doc-path=$(patsubst dest/en/%,%,$@) $(filter $(patsubst dest/%.html,%,$@).%,$(en_tpl_src)) > $@

assets: $(assets_dest)

dest/%.css: tpl/%.css
	mkdir -p $(dir $@)
	cp $^ $@

dest/pics/%: pics/%
	mkdir -p $(dir $@)
	cp $^ $@

dest/index.html: dest/en/index.html
	cp $^ $@

pics: $(pics_dest)
