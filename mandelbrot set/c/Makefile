macos:
	mkdir -p bin && gcc main.c -O3 -std=c11 -framework IOKit -framework Cocoa -framework OpenGL `pkg-config --libs --cflags raylib` -o bin/mandelbrot

linux:
	mkdir -p bin && gcc main.c -O3 -std=c11 -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 -o bin/mandelbrot

run:
	./bin/mandelbrot

clean:
	rm bin/mandelbrot



