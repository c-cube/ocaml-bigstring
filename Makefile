
OPTS=-use-ocamlfind
FLAGS= -w +a-4-44 -safe-string
TARGETS = bigstring.cma bigstring.cmxa bigstring.cmxs
TO_INSTALL = $(addprefix _build/src/, $(TARGETS) bigstring.cmi bigstring.cmx bigstring.a *.mli) \
	     $(wildcard _build/src/*.cmt{,i})

all:
	ocamlbuild $(OPTS) $(TARGETS)

clean:
	ocamlbuild -clean

install: all
	ocamlfind install bigstring META $(TO_INSTALL)

uninstall:
	ocamlfind remove bigstring

doc:
	ocamlbuild $(OPTS) src/bigstring.docdir/index.html

upload-doc: doc
	git checkout gh-pages && \
	  rm -rf dev/ && \
	  mkdir -p dev && \
	  cp -r bigstring.docdir/* dev/ && \
	  git add --all dev

QTEST_PREAMBLE=""
QTESTABLE=$(filter-out $(DONTTEST), \
	$(wildcard src/*.ml) \
	$(wildcard src/*.mli) \
	)

qtest-clean:
	@rm -rf qtest/

qtest-gen:
	@mkdir -p qtest
	@if which qtest > /dev/null ; then \
		qtest extract --preamble $(QTEST_PREAMBLE) \
			-o qtest/run_qtest.ml \
			$(QTESTABLE) 2> /dev/null ; \
	else touch qtest/run_qtest.ml ; \
	fi

test: qtest-gen
	ocamlbuild $(OPTS) -package QTest2Lib -package bigarray -I src qtest/run_qtest.native
	./run_qtest.native
