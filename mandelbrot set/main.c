#include <stdio.h>
#include <stdlib.h>

#include "raylib.h"

// NOTE: make render dimensions larger that window dimensions, then draw the pixels within the window only

#define WIDTH 720
#define HEIGHT 720
#define FPS 60

#define MIN_BOUND -2
#define MAX_BOUND 2
#define MAX_ITERS 100
#define ITER_FACTOR 5
#define SCALE_FACTOR 1.5
#define OFFSET_FACTOR 30

long double map(long double x, long double inMin, long double inMax, long double outMin, long double outMax);

int main(void) {
    // variables for zooming in/out of mandelbrot set (perspective)
    double minBound = MIN_BOUND;
    double maxBound = MAX_BOUND;
    int maxIters = MAX_ITERS;
    int offsetX = 0;
    int offsetY= 0;

    InitWindow(WIDTH, HEIGHT, "Mandelbrot Set");
    SetTargetFPS(FPS);

    while(!WindowShouldClose()) {
        // event processing
        if(IsKeyPressed(KEY_Z)) { // zoom in
            minBound *= SCALE_FACTOR;
            maxBound *= SCALE_FACTOR;
            maxIters += ITER_FACTOR;
        } else if(IsKeyPressed(KEY_X)) { // zoom out
            minBound /= SCALE_FACTOR;
            maxBound /= SCALE_FACTOR;
            maxIters -= ITER_FACTOR;
        } else if(IsKeyPressed(KEY_W) || IsKeyPressed(KEY_UP)) { // move up
            offsetY -= OFFSET_FACTOR;
        } else if(IsKeyPressed(KEY_S) || IsKeyPressed(KEY_DOWN)) { // move down
            offsetY += OFFSET_FACTOR;
        } else if(IsKeyPressed(KEY_A) || IsKeyPressed(KEY_LEFT)) { // move left
            offsetX -= OFFSET_FACTOR;
        } else if(IsKeyPressed(KEY_D) || IsKeyPressed(KEY_RIGHT)) { // move right
            offsetX += OFFSET_FACTOR;
        } else if(IsKeyPressed(KEY_R)) { // reset
            minBound = MIN_BOUND;
            maxBound = MAX_BOUND;
            maxIters = MAX_ITERS;
            offsetX = offsetY = 0;
        }
        
        
        // rendering
        BeginDrawing();
        ClearBackground(BLACK);
        
        for(int x = 0; x < WIDTH; x++) {
            for(int y = 0; y < HEIGHT; y++) {
                long double xc = map(x, 0, WIDTH, minBound, maxBound);
                long double yc = map(y, 0, HEIGHT, minBound, maxBound);
                
                long double xi = xc;
                long double yi = yc;
                
                int iters = 0;
                for(int i = 0; i < maxIters; i++) {
                    long double x2 = xc * xc - yc * yc;
                    long double y2 = 2 * xc * yc;
                    
                    xc = x2 + xi;
                    yc = y2 + yi;
                    
                    if(xc + yc > maxBound) {
                        break;
                    }
                    
                    iters++;
                }
                
                int pixelColor = map(iters, 0, maxIters, 0, 255);
                if(iters == maxIters) {
                    pixelColor = 0;
                }
                
                int r = pixelColor;
                int g = map(pixelColor*pixelColor, 0, 255*255, 0, 255);
                int b = map(pixelColor*0.5, 0, 255*0.5, 0, 255);
                
                DrawPixel(x + offsetX, y + offsetY, (Color) { r, g, b, 255 });
            }
        }
        
        DrawFPS(0.01 * WIDTH, 0.01 * WIDTH);
        EndDrawing();
    }

    CloseWindow();

    return 0;
}

long double map(long double x, long double inMin, long double inMax, long double outMin, long double outMax) {
    return ((x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin);
}
