module app;

import raylib;
import std.complex: complex;
import core.stdc.math: fabs, sqrt, log;

// window
enum fps = 60;
enum width = 720;
enum height = 640;

// mandelbrot set range
enum mMin = -2;
enum mMax = 2;

// mandelbrot z_i+1 = f(z_i) iterations
enum iterations = 100;

void main() {
	// window init
	InitWindow(width, height, "Mandelbrot");
	SetTargetFPS(fps);

    // sliders
	double mMinSlider = mMin;
    double mMaxSlider = mMax;
    double iterSlider = iterations;
    int offsetX = 0;
    int offsetY = 0;

    // main loop
	while(!WindowShouldClose()) {
		// process events
        // zoom out
        if(IsKeyPressed(KeyboardKey.KEY_Q)) {
            mMinSlider -= 0.5;
        } else if(IsKeyPressed(KeyboardKey.KEY_W)) {
            mMaxSlider += 0.5;
        }
    
        // zoom in
        if(IsKeyPressed(KeyboardKey.KEY_A)) {
            mMaxSlider -= 0.5;
        } else if(IsKeyPressed(KeyboardKey.KEY_S)) {
            mMinSlider += 0.5;
        }

        // control iterations
        if(IsKeyDown(KeyboardKey.KEY_E)) {
            iterSlider -= 5;
        } else if(IsKeyDown(KeyboardKey.KEY_D)) {
            iterSlider += 5;
        }

        // move around
        if(IsKeyDown(KeyboardKey.KEY_UP)) {
            offsetY -= 10;
        } else if(IsKeyDown(KeyboardKey.KEY_DOWN)) {
            offsetY += 10;
        } else if(IsKeyDown(KeyboardKey.KEY_LEFT)) {
            offsetX -= 10;
        } else if(IsKeyDown(KeyboardKey.KEY_RIGHT)) {
            offsetX += 10;
        }
        
        // reset to defaults
        if(IsKeyPressed(KeyboardKey.KEY_R)) {
            mMinSlider = mMin;
            mMaxSlider = mMax;
            iterSlider = iterations;
            offsetX = 0;
            offsetY = 0;
        }

        // update
		// render
		BeginDrawing();
		ClearBackground(Colors.BLACK);

        foreach(i; 0..width) {
            foreach(j; 0..height) {
                // f(z_0 = 0)
                auto z = complex(
                    i.mapTo(0, width, mMinSlider, mMaxSlider),
                    j.mapTo(0, height, mMinSlider, mMaxSlider)
                );

                // save the initial value of z
                auto zi = z;

                int iter = 0;
                for(; iter < iterSlider; iter++) {
                    // z_next = f(z_previous)
                    // f(z_next) = f(f(z_previous))
                    auto zn = z * z;
                    /*auto zn = complex(
                        z.re * z.re - z.im * z.im,
                        2 * z.re * z.im
                    );*/

                    // update z
                    z = zn + zi;
                    /*z = complex(
                        z1.re + zi.re,
                        z1.im + zi.im
                    );*/

                    // check: does it diverge to infinity? (that is, escapes the [mMin, mMax] interval)
                    if((z.re + z.im) > mMaxSlider) {
                        break;
                    }
                }

                // draw the pixel if the value has diverged at mMax iterations
                ubyte brightness = cast(ubyte)(iter.mapTo(0, iterSlider, 0, 255));
                if(iter == iterSlider) {
                    brightness = 0;
                } else if(i + offsetX >= 0 || j + offsetY >= 0) {
                    DrawPixel(i + offsetX, j + offsetY, brightness.calcColor());
                }
            }
        }

		DrawFPS(10, 10);
		EndDrawing();
	}
}

// linear mapping: x in [xMin, xMax] -> y in [outMin, outMax]
double mapTo(const double x, const double xMin, const double xMax, const double outMin, const double outMax) {
    return (x - xMin) * (outMax - outMin) / (xMax - xMin) + outMin;
}

Color calcColor(const ubyte brightness) {
    return Color(
        cast(ubyte)(mapTo(sqrt(brightness), 0, sqrt(255), 0, 255)),
        cast(ubyte)(mapTo(brightness * brightness, 0, 255 * 255, 0, 255)),
        cast(ubyte)(mapTo(log(brightness), 0, log(255), 0, 255)),
        255
    );
}
