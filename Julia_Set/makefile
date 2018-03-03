CC=g++
CFLAGS=-Wall
all: main.o func.o
	$(CC) $(CFLAGS) main.o -lSDL2 func.o -o juliaset.o
main.o: main.cpp
	$(CC) main.cpp -lSDL2 -c -o main.o
func.o: func.s
	nasm -f elf64 -o func.o func.s
clean:
	rm -f *.o

