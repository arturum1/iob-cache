#include <stdarg.h>
#include <stdlib.h>

#include "iob_cache_swreg.h"

#define CACHEFUNC(cache_base, func)                                            \
  (*((volatile int *)(cache_base + (func * sizeof(int)))))

// Cache Controllers's functions
void cache_init(int ext_mem,
                int cache_addr); // initialized the cache_base static integer
int cache_invalidate();
int cache_wtb_empty();
int cache_wtb_full();
int cache_hit();
int cache_miss();
int cache_read_hit();
int cache_read_miss();
int cache_write_hit();
int cache_write_miss();
int cache_counter_reset();
int cache_version();
