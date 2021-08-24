macos:
	mkdir -p bin && gcc main.c -framework IOKit -framework Cocoa -framework OpenGL `pkg-config --libs --cflags raylib` -o bin/mandelbrot

linux:
	mkdir -p bin && gcc main.c `pkg-config --libs --cflags raylib` -o bin/mandelbrot

run:
	./bin/mandelbrot

clean:
	rm bin/mandelbrot



