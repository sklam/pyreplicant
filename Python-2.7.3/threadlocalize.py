import sys, re
from llvm.core import *
import llvm.core as lc

re_gv_string = re.compile(r'.*\.str\d*$')
re_doc_string = re.compile('.*__doc__\d*$')
re_doc_string2 = re.compile('.*_doc\d*$')
outfile = sys.argv[1]
infile = sys.argv[2]

with open(infile, 'rb') as fin:
    mod = Module.from_bitcode(fin)

candidates = []

for gv in mod.global_variables:
    if gv.name in ['_DefaultRuneLocale', 'environ']:
        continue
    if (re_gv_string.match(gv.name) or re_doc_string.match(gv.name) or
        re_doc_string2.match(gv.name) or gv.name.startswith('__') or
        gv.name.startswith('doc_') or gv.name.endswith('_type') or
        gv.name.endswith('__doc__') or gv.name.endswith('_doc') or
        gv.global_constant):
        continue
    if gv.linkage in [LINKAGE_COMMON]:
        continue
    candidates.append(gv)

# Extract GV that needs initialization
need_init_list = []
for gv in candidates:
    gv.thread_local = True
    if gv.initializer:
        need_init_list.append(gv)

# TLS initiailizer
fnty = Type.function(Type.void(), [])
tls_init_fn = mod.add_function(fnty, 'PyTLS_init')

builder = Builder.new(tls_init_fn.append_basic_block(''))

for gv in need_init_list:
    init = gv.initializer
    gv.initializer = Constant.null(init.type)
    builder.store(init, gv)
builder.ret_void()

mod.verify()

with open(outfile, 'wb') as fout:
    mod.to_bitcode(fout)

