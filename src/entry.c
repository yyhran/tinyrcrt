
#include "../include/rcrt.h"

extern int main(int, char**);
void exit(int);

#ifdef WIN32
#include <Windows.h>
#endif

static void crt_fatal_error(const char* msg)
{
    printf("fatal error: %s.\n", msg);
    exit(1);
}

void rcrt_entry(void)
{
    int ret = 0;
#ifdef WIN32
    int flag = 0;
    int argc = 0;
    char* argv[16];
    char* cl = GetCommandLineA();

    argv[0] = cl;
    argc++;
    while(*cl)
    {
        if(*cl == '\"')
        {
            if(flag == 0)
            {
                flag = 1;
            }
            else
            {
                flag = 0;
            }
        }
        else if(*cl == ' ' && flag == 0)
        {
            if(*(cl + 1))
            {
                argv[argc] = cl + 1;
                argc++;
            }
            *cl = '\0';
        }
        cl++;
    }
#else
    int argc = 0;
    char** argv = NULL;
    // char* ebp_reg = NULL;
    register char* ebp_reg asm("ebp");

    // asm("movl %%ebp, %0 \n":"=r"(ebp_reg));
    argc = *(int*)(ebp_reg + sizeof(ebp_reg));
    argv = (char**)(ebp_reg + sizeof(ebp_reg) * 2);
#endif

    if(!rcrt_init_heap())
    {
        crt_fatal_error("heap initialize failed!");
    }

    if(!rcrt_init_io())
    {
        crt_fatal_error("IO initialize failed!");
    }

    ret = main(argc, argv);

    exit(ret);
}

void exit(int exitCode)
{
#ifdef WIN32
    ExitProcess(exitCode);
#else
    asm("movl %0, %%ebx \n\t"
        "movl $1, %%eax \n\t"
        "int $0x80      \n\t"
        "hlt            \n\t"
        :: "m"(exitCode)
        );
#endif
}
