STRIP=strip

CC      = $(CC)
CFLAGS  = -Wall -O2 -g0 -DNDEBUG -DENV_LINUX -D_REENTRANT -DNDEBUG -L/usr/lib -L/usr/local/lib/ -I.

LDFLAGS  = -L. -lwlocate -lm

PNAME=lwtrace

OBJ = trace.o
SRC = trace.c

all: $(OBJ)
	$(CC) $(CFLAGS) -o $(PNAME) $(OBJ) $(LDFLAGS)
	$(STRIP) $(PNAME)

clean:
	rm -f *.o
	rm -f $(PNAME)
