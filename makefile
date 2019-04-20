CC=gcc
CXX=g++

SRCDIR=src
INCDIR=include
OBJDIR=obj
BINDIR=bin
LIBDIR=lib
TARGET=$(shell basename $(CURDIR))

#general compiler flags
CFLAGS=-Wall -Wextra -std=c11
CPPFLAGS=-Wall -Wextra -std=c++17

#debug compiler flags
CDFLAGS=-g -O0 -ggdb
CPPDFLAGS=-g -O0 -ggdb

#release compiler flags
CRFLAGS=-O3 -march=native -DNDEBUG
CPPRFLAGS=-O3 -march=native -DNDEBUG

#aditional libs
#example: LIB=-ldl -L/path/to/more/libs -lmy_lib
LIB=-lpthread
#aditional include paths
INC=-I$(INCDIR) -I/usr/local/include

#general linker flags
LINKFLAGS=-L$(LIBDIR) $(LIB)
#debug linker flags
LINKDFLAGS=
#release linker flags
LINKRFLAGS=-s


SOURCES=$(shell find $(SRCDIR) -type f)
D_OBJECTS=$(patsubst $(SRCDIR)/%,$(OBJDIR)/debug/%.o,$(SOURCES))
R_OBJECTS=$(patsubst $(SRCDIR)/%,$(OBJDIR)/release/%.o,$(SOURCES))

release: $(BINDIR)/release/$(TARGET)

debug: $(BINDIR)/debug/$(TARGET)

$(BINDIR)/release/$(TARGET): $(R_OBJECTS)
	@mkdir -pv $(dir $@)
	$(CXX) -o $@ $^ $(LINKFLAGS) $(LINKRFLAGS)

$(BINDIR)/debug/$(TARGET): $(D_OBJECTS)
	@mkdir -pv $(dir $@)
	$(CXX) -o $@ $^ $(LINKFLAGS) $(LINKDLAGS)

$(OBJDIR)/debug/%.c.o: $(SRCDIR)/%.c
	@mkdir -pv $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS) $(CDFLAGS) $(INC)

$(OBJDIR)/debug/%.cpp.o: $(SRCDIR)/%.cpp
	@mkdir -pv $(dir $@)
	$(CXX) -c -o $@ $< $(CPPFLAGS) $(CPPDFLAGS) $(INC)

$(OBJDIR)/release/%.c.o: $(SRCDIR)/%.c
	@mkdir -pv $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS) $(CRFLAGS) $(INC)

$(OBJDIR)/release/%.cpp.o: $(SRCDIR)/%.cpp
	@mkdir -pv $(dir $@)
	$(CXX) -c -o $@ $< $(CPPFLAGS) $(CPPRFLAGS) $(INC)

clean:
	@rm -rfv $(BINDIR) $(OBJDIR)
