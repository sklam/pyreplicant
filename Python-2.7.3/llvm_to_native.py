import sys
from llvm.core import *

outfile = sys.argv[1]
infile = sys.argv[2]

with open(infile, 'rb') as fin:
    m = Module.from_bitcode(fin)

with open(outfile, 'wb') as fout:
    m.to_native_object(fout)
