CLANG = clang
OBJS = Modules/getbuildinfo.o Parser/acceler.o Parser/grammar1.o Parser/listnode.o Parser/node.o Parser/parser.o Parser/parsetok.o Parser/bitset.o Parser/metagrammar.o Parser/firstsets.o Parser/grammar.o Parser/pgen.o Parser/myreadline.o Parser/tokenizer.o Objects/abstract.o Objects/boolobject.o Objects/bufferobject.o Objects/bytes_methods.o Objects/bytearrayobject.o Objects/capsule.o Objects/cellobject.o Objects/classobject.o Objects/cobject.o Objects/codeobject.o Objects/complexobject.o Objects/descrobject.o Objects/enumobject.o Objects/exceptions.o Objects/genobject.o Objects/fileobject.o Objects/floatobject.o Objects/frameobject.o Objects/funcobject.o Objects/intobject.o Objects/iterobject.o Objects/listobject.o Objects/longobject.o Objects/dictobject.o Objects/memoryobject.o Objects/methodobject.o Objects/moduleobject.o Objects/object.o Objects/obmalloc.o Objects/rangeobject.o Objects/setobject.o Objects/sliceobject.o Objects/stringobject.o Objects/structseq.o Objects/tupleobject.o Objects/typeobject.o Objects/weakrefobject.o Objects/unicodeobject.o Objects/unicodectype.o Python/_warnings.o Python/Python-ast.o Python/asdl.o Python/ast.o Python/bltinmodule.o Python/ceval.o Python/compile.o Python/codecs.o Python/errors.o Python/frozen.o Python/frozenmain.o Python/future.o Python/getargs.o Python/getcompiler.o Python/getcopyright.o Python/getplatform.o Python/getversion.o Python/graminit.o Python/import.o Python/importdl.o Python/marshal.o Python/modsupport.o Python/mystrtoul.o Python/mysnprintf.o Python/peephole.o Python/pyarena.o Python/pyctype.o Python/pyfpe.o Python/pymath.o Python/pystate.o Python/pythonrun.o Python/random.o Python/structmember.o Python/symtable.o Python/sysmodule.o Python/traceback.o Python/getopt.o Python/pystrcmp.o Python/pystrtod.o Python/dtoa.o Python/formatter_unicode.o Python/formatter_string.o Python/dynload_shlib.o  Python/mactoolboxglue.o Python/thread.o Modules/config.o Modules/getpath.o Modules/main.o Modules/gcmodule.o  Modules/threadmodule.o  Modules/signalmodule.o  Modules/posixmodule.o  Modules/errnomodule.o  Modules/pwdmodule.o  Modules/_sre.o  Modules/_codecsmodule.o  Modules/_weakref.o  Modules/zipimport.o  Modules/symtablemodule.o  Modules/xxsubtype.o

all: libpython2.7.so libpython2.7-tl.so test test-tl

%.o: %.c
	$(CLANG) -emit-llvm -c -fno-strict-aliasing -g -O0 -DNDEBUG -g -fwrapv -O0 -Wall -Wstrict-prototypes  -I. -IInclude -I./Include   -DPy_BUILD_CORE -o $@ $+

Modules/getbuildinfo.o: Modules/getbuildinfo.c
	$(CLANG) -emit-llvm -c -fno-strict-aliasing -g -O0 -DNDEBUG -g -fwrapv -O0 -Wall -Wstrict-prototypes  -I. -IInclude -I./Include   -DPy_BUILD_CORE \
	      -DSVNVERSION="\"`LC_ALL=C svnversion .`\"" \
	      -DHGVERSION="\"`LC_ALL=C `\"" \
	      -DHGTAG="\"`LC_ALL=C `\"" \
	      -DHGBRANCH="\"`LC_ALL=C `\"" \
	      -o Modules/getbuildinfo.o ./Modules/getbuildinfo.c

libpython2.7.bc: $(OBJS)
	python merge_llvm_objs.py $@ $+

libpython2.7-tl.bc: libpython2.7.bc
	python threadlocalize.py $@ $+

%.o: %.bc
	python llvm_to_native.py $@ $+

libpython2.7.so: libpython2.7.o
	$(CLANG) -shared -undefined dynamic_lookup -o $@ $+ -ldl -framework CoreFoundation

libpython2.7-tl.so: libpython2.7-tl.o
	$(CLANG) -shared -undefined dynamic_lookup -o $@ $+ -ldl -framework CoreFoundation

test: test.c libpython2.7.so
	$(CLANG) -o $@ $+ -L. -lpython2.7

test-tl: test-tl.c libpython2.7-tl.so
	$(CLANG) -o $@ $+ -L. -lpython2.7-tl

clean:
	rm -f $(OBJS) *.so *.bc *.ll *.o test test-tl
	