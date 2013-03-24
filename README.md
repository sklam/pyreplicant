# README

Replicant is a threadlocalized version of Python2.7.3.  It means that I applied 
some black magic to Python2.7.3 source to make all globals become threadlocal.
As a result, one can launch multiple interpretter threads in a single proccess.

## Get Started

You will need clang and llvmpy.  I have only tested this on OSX10.8.

```bash
cd Python2.7.3
make -f custom.make all
# run threadlocalized version of python
./test-tl
```

`./test-tl` runs two Python interpretters with the `testme.py`.  It just
prints some big prime numbers.

## How it works?

To understand how it works, you must read all the books listed in 
Index Librorum Prohibitorum; or, have played around with LLVM.

Replicant compiles the Python source code into LLVM IR and link all of them 
together into a big LLVM module.  Then, it runs a few python scripts to turn
all the global variables into threadlocal and add a function to initialize
these threadlocals in each thread. Finally, it write the modified Python into
an native object file and compile it into `libpython2.7-tl.so` That's all.

## FAQ

### Is it useful?

No, it is a big hack for experimentation purpose only.  It DOES NOT work with
any of your C-extensions unless you apply the same hack to all of them.


