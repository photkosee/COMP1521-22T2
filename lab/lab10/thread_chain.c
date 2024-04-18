// Phot Koseekrainiramon (z5387411)
// on 08/08/2022

#include <pthread.h>
#include "thread_chain.h"

void *my_thread(void *data) {
    thread_hello();
    
    return NULL;
}

void my_main(void) {
    pthread_t thread_handle;
    pthread_create(&thread_handle, NULL, my_thread, NULL);

    pthread_join(thread_handle, NULL);
}
