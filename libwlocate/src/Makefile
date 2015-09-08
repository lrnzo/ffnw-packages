CCOMPILER=$(CC) -Wall -fPIC -shared -Wno-unused -O2 -g0 -DNDEBUG -D_REENTRANT -DENV_LINUX -I. -I..

SYSLIBRARIES= -lm

LIBS = $(SYSLIBRARIES) -liw

EXECUTABLE=libwlocate.so

LINK=$(CC) -shared -Wl,--no-as-needed

OBJECTS = connect.o wlan.o libwlocate.o iwlist.o

default: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK) $(SYSLDFLAGS) $(LDFLAGS) -o $(EXECUTABLE) $(OBJECTS) $(LIBS) 

%.o: %.c
	$(CCOMPILER) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)

