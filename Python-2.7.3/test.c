#include "pthread.h"
#include <stdio.h>

// declare our own prototypes
void PyTLS_init(void);
void Py_Initialize(void);
void Py_Finalize(void);
int PyRun_SimpleFile(FILE*, const char*);
int PyRun_SimpleString(const char *);
//extern __thread int Py_NoSiteFlag;            // thread local
extern int Py_NoSiteFlag;

int
main(int argc, char *argv[])
{
    Py_NoSiteFlag = 1;
    Py_Initialize();
    PyRun_SimpleString("print 'Hello world'");
    Py_Finalize();
    return 0;
}