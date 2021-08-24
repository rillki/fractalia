#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "raylib.h"

const int windowWidth = 1080;
const int windowHeight = 720;
const int windowFPS = 60;

const int renderWidth = windowWidth*4;
const int renderHeight = windowWidth*4;

const float boundMin = -8.0;
const float boundMax = 8.0;
const float boundScalingFactor = 1.05;

const int iterMax = 100;
const int iterDelta = 5;
const int offsetFactor = 30;

// complex number
typedef struct cldouble {
	long double re;
	long double im;
} cldouble;

inline long double map(long double x, long double xRangeMin, long double xRangeMax, long double outRangeMin, long double outRangeMax);
inline Color calc_color(int seed);

int main(void) {
	float boundMinSlider = boundMin;
	float boundMaxSlider = boundMax;
	int iterSlider = iterMax;
	int offsetX = -renderWidth/3;
	int offsetY = -renderHeight/2.4;

	// window init
	InitWindow(windowWidth, windowHeight, "Mandelbrot Set");
	SetTargetFPS(windowFPS);

	// main loop
	while(!WindowShouldClose()) {
		// process events
		if(IsKeyDown(KEY_Q)) {
			// increase min bound
			boundMinSlider *= boundScalingFactor;
		} else if(IsKeyDown(KEY_A)) {
			// decrease min bound
			boundMinSlider /= boundScalingFactor;
		} else if(IsKeyDown(KEY_W)) {
			// increase max bound
			boundMaxSlider *= boundScalingFactor;
		} else if(IsKeyDown(KEY_S)) {
			// increase max bound
			boundMaxSlider /= boundScalingFactor;
		} else if(IsKeyDown(KEY_E)) {
			// increase iterSlider (iterations)
			iterSlider += iterDelta;
		} else if(IsKeyDown(KEY_D)) {
			// decrease iterSlider (iterations)
			iterSlider -= iterDelta;
		}

		if(IsKeyDown(KEY_UP)) {
			// change Y offset (move up)
			offsetY += offsetFactor;
		} else if(IsKeyDown(KEY_DOWN)) {
			// change Y offset (move down)
			offsetY -= offsetFactor;
		} else if(IsKeyDown(KEY_LEFT)) {
			// change X offset (move left)
			offsetX += offsetFactor;
		} else if(IsKeyDown(KEY_RIGHT)) {
			// change X offset (move right)
			offsetX -= offsetFactor;
		} else if(IsKeyDown(KEY_R)) {
			// reset to defaults
			boundMinSlider = boundMin;
			boundMaxSlider = boundMax;
			iterSlider = iterMax;
			offsetX = -renderWidth/3;
			offsetY = -renderHeight/2.4;
		}

		// render
		BeginDrawing();
		ClearBackground(BLACK);

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
				cldouble z = {
					.re = map(x, 0, renderWidth, boundMinSlider, boundMaxSlider),
					.im = map(y, 0, renderHeight, boundMinSlider, boundMaxSlider),
				};

				// save the initial z value
				cldouble zi = z;
				
				int n = 0;
				for(; n < iterSlider; n++) {
					// calculate new z
					z = (cldouble) {
						.re = z.re * z.re - z.im * z.im + zi.re,
						.im = 2 * z.re * z.im + zi.im,
					};
					
					if(fabsl(z.re + z.im) > boundMaxSlider) {
						break;
					}
				}

				DrawPixel(x + offsetX, y + offsetY, calc_color(n == iterSlider ? 0 : map(n, 0, iterSlider, 0, 255)));
			}
		}

		DrawFPS(10, 10);
		{
			char str[100];
			snprintf(str, sizeof(str), "boundMinSlider:  %.3f", boundMinSlider);
			DrawText(str, 10, 60, 21, WHITE);

			snprintf(str, sizeof(str), "boundMaxSlider: %.3f", boundMaxSlider);
			DrawText(str, 10, 90, 21, WHITE);

			snprintf(str, sizeof(str), "iterSlider: %i", iterSlider);
			DrawText(str, 10, 120, 21, WHITE);
		}
		EndDrawing();
	}

	return 0;
}

inline long double map(long double x, long double xRangeMin, long double xRangeMax, long double outRangeMin, long double outRangeMax) {
	return ((x - xRangeMin) * (outRangeMax - outRangeMin) / (xRangeMax - xRangeMin) + outRangeMin);
}

inline Color calc_color(int seed) {
	return (Color) {
		.r = map(sqrt(seed), 0, sqrt(255), 0, 255),
		.g = map(seed*seed, 0, 255*255, 0, 255),
		.b = map(seed*0.5, 0, 255*0.5, 0, 255),
		.a = 255
	};
}


























