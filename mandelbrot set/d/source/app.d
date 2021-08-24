module app;

import std;
import raylib;

immutable windowWidth = 1080;
immutable windowHeight = 720;
immutable windowFPS = 60;

void main() {
	InitWindow(windowWidth, windowHeight, "Mandelbrot Fractal");
	
	writeln("hello, world.");

	CloseWindow();
}
