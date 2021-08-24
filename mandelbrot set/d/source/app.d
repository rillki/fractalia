module app;

import std.conv: to;
import std.string: toStringz;
import std.complex: complex, Complex;
import core.stdc.math: fabs, sqrt;

import raylib;

immutable windowWidth = 1080;
immutable windowHeight = 720;
immutable windowFPS = 60;

immutable renderWidth = windowWidth*4;
immutable renderHeight = windowWidth*4;

immutable boundMin = -8.0;
immutable boundMax = 8.0;
immutable boundScalingFactor = 1.05;

immutable iterMax = 100;
immutable iterDelta = 5;
immutable offsetFactor = 30;

void main() {
	float boundMinSlider = boundMin;
	float boundMaxSlider = boundMax;
	int iterSlider = iterMax;
	int offsetX = (-renderWidth/3).to!int;
	int offsetY = (-renderHeight/2.4).to!int;

	// window init
	InitWindow(windowWidth, windowHeight, "Mandelbrot Fractal");
	SetTargetFPS(windowFPS);

	// main loop
	while(!WindowShouldClose()) {
		// process events
		if(IsKeyDown(KeyboardKey.KEY_Q)) {
			// increase min bound
			boundMinSlider *= boundScalingFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_A)) {
			// decrease min bound
			boundMinSlider /= boundScalingFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_W)) {
			// increase max bound
			boundMaxSlider *= boundScalingFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_S)) {
			// increase max bound
			boundMaxSlider /= boundScalingFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_E)) {
			// increase iterSlider (iterations)
			iterSlider += iterDelta;
		} else if(IsKeyDown(KeyboardKey.KEY_D)) {
			// decrease iterSlider (iterations)
			iterSlider -= iterDelta;
		}

		if(IsKeyDown(KeyboardKey.KEY_UP)) {
			// change Y offset (move up)
			offsetY += offsetFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_DOWN)) {
			// change Y offset (move down)
			offsetY -= offsetFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_LEFT)) {
			// change X offset (move left)
			offsetX += offsetFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_RIGHT)) {
			// change X offset (move right)
			offsetX -= offsetFactor;
		} else if(IsKeyDown(KeyboardKey.KEY_R)) {
			// reset to defaults
			boundMinSlider = boundMin;
			boundMaxSlider = boundMax;
			iterSlider = iterMax;
			offsetX = (-renderWidth/3).to!int;
			offsetY = (-renderHeight/2.4).to!int;
		}

		// render
		BeginDrawing();
		ClearBackground(Colors.BLACK);

		// iterate through each pixel
		for(int x = 0; x < renderWidth; x++) {
			// if pixel is not within the window dimensions, skip the iteration
			if(x + offsetX < 0 || x + offsetX > windowWidth) {
				continue;
			}

			for(int y = 0; y < renderHeight; y++) {
				// if pixel is not within the window dimensions, skip the iteration
				if(y + offsetY < 0 || y + offsetY > windowHeight) {
					continue;
				}

				// mapping x and y coord to complex plane coord in range(boundMinSlider, boundMaxSlider)
				auto z = complex(
					map(x, 0, renderWidth, boundMinSlider, boundMaxSlider),
					map(y, 0, renderHeight, boundMinSlider, boundMaxSlider)
				);

				// save the initial z value
				auto zi = z;
				
				int n = 0;
				for(; n < iterSlider; n++) {
					// calculate new z
					z = complex(
						z.re * z.re - z.im * z.im + zi.re,
						2 * z.re * z.im + zi.im
					);
					
					if(fabs(z.re + z.im) > boundMaxSlider) {
						break;
					}
				}

				DrawPixel(x + offsetX, y + offsetY, calc_color((n == iterSlider ? 0 : map(n, 0, iterSlider, 0, 255)).to!int));
			}
		}

		DrawFPS(10, 10);
		{
			DrawText(("boundMinSlider:  " ~ boundMinSlider.to!string).toStringz, 10, 60, 21, Colors.WHITE);
			DrawText(("boundMaxSlider:  " ~ boundMaxSlider.to!string).toStringz, 10, 90, 21, Colors.WHITE);
			DrawText(("iterSlider: " ~ iterSlider.to!string).toStringz, 10, 120, 21, Colors.WHITE);
		}
		EndDrawing();
	}
}

double map(const double x, const double xRangeMin, const double xRangeMax, const double outRangeMin, const double outRangeMax) {
	return ((x - xRangeMin) * (outRangeMax - outRangeMin) / (xRangeMax - xRangeMin) + outRangeMin);
}

Color calc_color(const int seed) {
	return Color(
		map(sqrt(seed), 0, sqrt(255), 0, 255).to!ubyte,
		map(seed*seed, 0, 255*255, 0, 255).to!ubyte,
		map(seed*0.5, 0, 255*0.5, 0, 255).to!ubyte,
		255
	);
}














