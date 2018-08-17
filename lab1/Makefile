

all: main

main: main.o
	$(LD) -o $@ $+
main.o: main.s
	$(AS) -o $@ $<

clean:
	rm -vf main *.o
