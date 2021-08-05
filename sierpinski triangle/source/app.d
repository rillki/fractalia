import raylib;

void main() {
    immutable int screenWidth = 640;
    immutable int screenHeight = 480;

    InitWindow(screenWidth, screenHeight, "Dlang Sierpinski Triangle");

    // set fps = 5 when calling sierpinskiTriangleAnimation function
    SetTargetFPS(30);

    int limit = 0;
    while (!WindowShouldClose()) {
		// process events

		// update

		// draw
		BeginDrawing();
        ClearBackground(RAYWHITE);

        //sierpinskiTriangleAnimation(Vector2(screenWidth/2, 0), Vector2(0, screenHeight), Vector2(screenWidth, screenHeight), limit);
        sierpinskiTriangle(Vector2(screenWidth/2, 0), Vector2(0, screenHeight), Vector2(screenWidth, screenHeight), 6);

        EndDrawing();
    }

	CloseWindow();
}

// set low fps when calling this function, otherwise you won't see anything
void sierpinskiTriangleAnimation(Vector2 p0, Vector2 p1, Vector2 p2, ref int limit) {
	// it makes no difference to make limit greater than 13
	if(limit++ > 13) {
		limit = 13;
	}

	sierpinskiTriangle(p0, p1, p2, limit);
}

void sierpinskiTriangle(Vector2 p0, Vector2 p1, Vector2 p2, int limit) {
	// when the limit of iterations is <= 0, draw the triangle using current points
	if(limit-- <= 0) {
		DrawTriangle(p0, p1, p2, BLACK);
		return;
	}

	// calculating new points
	Vector2 a = Vector2((p0.x + p1.x)/2, (p0.y + p1.y)/2);
	Vector2 b = Vector2((p1.x + p2.x)/2, (p1.y + p2.y)/2);
	Vector2 c = Vector2((p2.x + p0.x)/2, (p2.y + p0.y)/2);

	sierpinskiTriangle(p0, a, c, limit-1);
	sierpinskiTriangle(a, p1, b, limit-1);
	sierpinskiTriangle(c, b, p2, limit-1);
}
