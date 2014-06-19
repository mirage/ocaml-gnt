all: build

TESTS_FLAG=--enable-tests

NAME=xen-gnt
J=4

include config.mk
config.mk: configure
	        ./configure

configure: configure.ml
	        ocamlfind ocamlopt -package "cmdliner" -linkpkg $< -o $@
		rm -f configure.c* configure.o

LIBDIR=_build/lib

setup.ml: _oasis
	oasis setup

setup.data: setup.ml
	ocaml setup.ml -configure $(TESTS_FLAG) $(ENABLE_XENCTRL)

build: setup.data setup.ml
	ocaml setup.ml -build -j $(J)

doc: setup.data setup.ml
	ocaml setup.ml -doc -j $(J)

install: setup.data setup.ml
	ocaml setup.ml -install

uninstall:
	ocamlfind remove $(NAME)

test: setup.ml build
	ocaml setup.ml -test

reinstall: setup.ml
	ocamlfind remove $(NAME) || true
	ocaml setup.ml -reinstall

clean:
	ocamlbuild -clean
	rm -f setup.data setup.log config.mk
