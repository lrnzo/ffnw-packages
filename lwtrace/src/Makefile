STRIP=strip

CFLAGS  = -Wall -O2 -g0 -DNDEBUG -DENV_LINUX -D_REENTRANT -I$(STAGING_DIR)/usr/include/

LDFLAGS  = -L$(STAGING_DIR)/usr/lib -lwlocate -lm

PNAME=lwtrace

OBJ = trace.o
SRC = trace.c

all: $(OBJ)
	$(CC) $(CFLAGS) -o $(PNAME) $(OBJ) $(LDFLAGS)
	$(STRIP) $(PNAME)

clean:
	rm -f *.o
	rm -f $(PNAME)
