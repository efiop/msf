#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

#include "lib.h"

int main(int argc, char *argv[])
{
	lib_func_t f;
	void *h;
	int r;

	h = dlopen("lib.so", RTLD_LAZY);
	if (h == NULL) {
		printf("Unable to load lib.so: %s", dlerror());
		return -1;
	}

	f = dlsym(h, "lib_func");
	if (f)
		r = f();
	else
		r = -1;
	dlclose(h);

	return r;
}
