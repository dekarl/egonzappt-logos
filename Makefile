# Generate files in build/, build/44x44, build/16x16 for each
# file in vector/
# based on https://github.com/jnylen/nonametv-logos/blob/master/Makefile

CONVERT  := convert
INKSCAPE := inkscape

FILES256 := $(patsubst vector/%.svg,build/%.png,$(wildcard vector/*.svg))
FILES44  := $(patsubst vector/%.svg,build/44x44/%.png,$(wildcard vector/*.svg))
FILES16  := $(patsubst vector/%.svg,build/16x16/%.png,$(wildcard vector/*.svg))

all: dobuild

# do not clean upload, we use it to quickly perform checksums locally before uploading
clean:
	rm -rf build

dobuild: build buildfiles

build:
	mkdir -p build build/44x44 build/16x16

buildfiles: $(FILES256) $(FILES44) $(FILES16)

build/%.png: vector/%.svg
	${INKSCAPE} $< --export-png $@ --export-area-page --export-width 256 --export-height 256

build/44x44/%.png: vector/%.svg
	${INKSCAPE} $< --export-png $@ --export-area-page --export-width 44 --export-height 44

build/16x16/%.png: vector/%.svg
	${INKSCAPE} $< --export-png $@ --export-area-page --export-width 16 --export-height 16

doupload:
	mkdir -p upload
	rsync --checksum --delete -r build/ upload/
	rsync --rsh="ssh -l nonametv" --archive --verbose upload/ ole.spaetfruehstuecken.org:/home/ispman/spaetfruehstuecken.org/vhosts/xmltv/htdocs/chanlogos/
