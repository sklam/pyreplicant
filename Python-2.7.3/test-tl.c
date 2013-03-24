#include "pthread.h"
#include <stdio.h>

// declare our own prototypes
void PyTLS_init(void);
void Py_Initialize(void);
int Py_IsInitialized(void);
void Py_Finalize(void);
int PyRun_SimpleFile(FILE*, const char*);
int PyRun_SimpleString(const char *);
//extern __thread int Py_NoSiteFlag;            // thread local
extern int Py_NoSiteFlag;
//
//int
//main(int argc, char *argv[])
//{
//    PyTLS_init();
//    Py_NoSiteFlag = 1;
//    Py_Initialize();
//    PyRun_SimpleString("print 'Hello world'");
//    Py_Finalize();
//    return 0;
//}

void* worker(void* arg){
    PyTLS_init(); // initialize thread local storage
    Py_NoSiteFlag = 1;
    fprintf(stderr, "%p: Py_IsInitialized() %d\n", (void*)pthread_self(), Py_IsInitialized());
    Py_Initialize();
    FILE * file = fopen("testme.py", "r");
    PyRun_SimpleFile(file, "testme.py");
    Py_Finalize();
    fclose(file);
    return NULL;
}

int main(int argc, char **argv)
{
    pthread_t thread;
    pthread_create(&thread, NULL, worker, NULL);
    worker(NULL);
    pthread_join(thread, NULL);
    return 0;
}

