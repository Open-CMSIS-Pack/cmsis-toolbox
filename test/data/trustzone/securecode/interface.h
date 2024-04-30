// function pointer
typedef int(*funcptr)(int,int);

/* Non-secure callable functions */
extern int function_1(int x);
extern int function_2(funcptr callback, int x, int y);
