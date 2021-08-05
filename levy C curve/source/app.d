import raylib;

// point struct
struct Point {
	int x = 0;					// x pos
	int y = 0;					// y pos
	int length = 0;				// length of a line
	int defaultLength = 0;		// default length of a line
	
	// initialization
	this(int x, int y, int length) {
		this.x = x;
		this.y = y;
		this.length = length;
		this.defaultLength = length;
	}
}

void levyC_curve(float x, float y, float length, int limit) {
	
}

void main() {
    immutable int screenWidth = 640;
    immutable int screenHeight = 640;

    // init
    InitWindow(screenWidth, screenHeight, "Dlang Levy C curve");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        // process events

        // update

        // render
        BeginDrawing();

        ClearBackground(RAYWHITE);
        DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);

        EndDrawing();
    }

    // free memory

    // quit
    CloseWindow();
}

