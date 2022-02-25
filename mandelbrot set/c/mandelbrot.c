#include <math.h>
#include "raylib.h"

// window
#define FPS 60
#define WIDTH 1080
#define HEIGHT 720

// mandelbrot set range
#define mMIN -2
#define mMAX 2

// mandelbrot z_i+1 = f(z_i) iterations
#define ITERATIONS 100

typedef struct { double re, im; } complex_t;
double map_to(const double x, const double xMin, const double xMax, const double outMin, const double outMax);
Color calc_color(const int brightness);

int main(void) {
    // window init
    InitWindow(WIDTH, HEIGHT, "Mandelbrot");
    SetTargetFPS(FPS);

    // main loop
    while(!WindowShouldClose()) {
	// process events
	// update
	// render
	BeginDrawing();
	ClearBackground(BLACK);

	for(int i = 0; i < WIDTH; i++) {
	    for(int j = 0; j < HEIGHT; j++) {
		// f(z_0 = 0)
                complex_t z = (complex_t) {
                    map_to(i, 0, WIDTH, mMIN, mMAX),
                    map_to(j, 0, HEIGHT, mMIN, mMAX)
                };

                // save the initial value of z
                complex_t zi = z;

                int iter = 0;
                for(; iter < ITERATIONS; iter++) {
                    // z_next = f(z_previous)
                    // f(z_next) = f(f(z_previous))
                    complex_t zn = (complex_t) {
                        z.re * z.re - z.im * z.im,
                        2 * z.re * z.im
                    };

                    // update z
                    z = (complex_t) {
                        zn.re + zi.re,
                        zn.im + zi.im
                    };

                    // check: does it diverge to infinity? (that is, escapes the [mMIN, mMAX] interval)
                    if((z.re + z.im) > mMAX) {
                        break;
                    }
                }

                // draw the pixel if the value has diverged at mMAX iterations
                int brightness = map_to(iter, 0, ITERATIONS, 0, 255);
                if(iter == ITERATIONS) {
                    brightness = 0;
                } else {
                    DrawPixel(i, j, calc_color(brightness));
                }
            }
        }

	    DrawFPS(10, 10);
	    EndDrawing();
	}

    return 0;
}

// linear mapping: x in [xMin, xMax] -> y in [outMin, outMax]
double map_to(const double x, const double xMin, const double xMax, const double outMin, const double outMax) {
    return (x - xMin) * (outMax - outMin) / (xMax - xMin) + outMin;
}

Color calc_color(const int brightness) {
    return (Color) {
        map_to(sqrt(brightness), 0, sqrt(255), 0, 255),
        map_to(brightness * brightness + 100, 0, 255 * 255 + 100, 0, 255),
        map_to(sqrt(log(brightness)), 0, sqrt(log(255)), 0, 255),
        255
    };
}
