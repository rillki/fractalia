import raylib;

import std.math: sqrt, sin, cos, PI;

immutable scalingFactor = sqrt(2.0f); // scaling factor of line length

// camera struct
struct Camera {
	int x = 0;			// x pos
	int y = 0;			// y pos
	int length = 0;			// length of a line

	int defaultX = 0;
	int defaultY = 0;
	int defaultLength = 0;		// default length of a line
	
	// initialization
	this(int x, int y, int length) {
		this.defaultX = this.x = x;
		this.defaultY = this.y = y;
		this.defaultLength = this.length = length;
	}

	// reset camera view
	void reset() {
		length = defaultLength;
		x = defaultX;
		y = defaultY;
	}
}

void dragonCurve(float x, float y, float length, float angle, int limit) {
	// if limit is <= 0, draw the line to the screen
	if(limit <= 0) {
		DrawLineEx(Vector2(x, y), Vector2(x+length*cos(angle), y+length*sin(angle)), 1, WHITE);
		return;
	}
	
	// divide the length by scalingFactor and rotate the line by PI/4
	dragonCurve(x, y, length/scalingFactor, angle-PI/4, limit-1);
	
	// divide the length by scalingFactor and rotate the line by 5*PI/4
	dragonCurve(x+length*cos(angle), y+length*sin(angle), length/scalingFactor, angle+5*PI/4, limit-1);
}

void main() {
    immutable int screenWidth = 640;
    immutable int screenHeight = 640;

    // init
    InitWindow(screenWidth, screenHeight, "Dlang Dragon Curve");
	scope(exit) CloseWindow();
    SetTargetFPS(60);
	
    // create a random camera with line length
    Camera camera = Camera(200, 150, 400);

    while (!WindowShouldClose()) {
        // process events -> moving the dragon curve (up, down, left, right) + zooming in and zooming out
		if(IsKeyDown(KeyboardKey.KEY_UP)) {
			camera.y += 10;
		} else if(IsKeyDown(KeyboardKey.KEY_DOWN)) {
			camera.y -= 10;
		} else if(IsKeyDown(KeyboardKey.KEY_LEFT)) {
			camera.x += 10;
		} else if(IsKeyDown(KeyboardKey.KEY_RIGHT)) {
			camera.x -= 10;
		} else if(IsKeyDown(KeyboardKey.KEY_Z)) {
			camera.length += 10;
		} else if(IsKeyDown(KeyboardKey.KEY_X)) {
			camera.length -= 10;
		} else if(IsKeyPressed(KeyboardKey.KEY_C)) {
			camera.reset(); // reset camera view
		}

        // update

        // render
        BeginDrawing();
        ClearBackground(GRAY);
		
	// draw the dragon curve
	dragonCurve(camera.x, camera.y, camera.length, PI/2, 12);
		
	DrawFPS(10, 10);
        EndDrawing();
    }
}

