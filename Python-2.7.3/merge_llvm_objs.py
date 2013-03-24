import sys
from llvm.core import *

outfile = sys.argv[1]
infiles = sys.argv[2:]

def read_bc(ifile):
    with open(ifile, 'rb') as fin:
        return Module.from_bitcode(fin)

with open(outfile, 'wb') as fout:
    main = read_bc(infiles[0])
    for ifile in infiles[1:]:
        unit = read_bc(ifile)
        main.link_in(unit)
    main.verify()
    main.to_bitcode(fout)
