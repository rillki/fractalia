import std.math: sin, cos, PI, sqrt, atan2;

import raylib;

void main() {
    immutable int screenWidth = 640;
    immutable int screenHeight = 480;

    InitWindow(screenWidth, screenHeight, "Dlang Koch Curve");
    SetTargetFPS(30);

    // Koch Snowflake points
    Vector2 p0 = Vector2(130, screenHeight-130);
    Vector2 p1 = Vector2(screenWidth/2, 30);
    Vector2 p2 = Vector2(screenWidth-130, screenHeight-130);

    int limit = 0;
    while (!WindowShouldClose()) {
	// process events

	// update

	// draw
	BeginDrawing();
        ClearBackground(RAYWHITE);

	kochCurve(Vector2(10, screenHeight/2), Vector2(screenWidth-10, screenHeight/2), 6);

	// Koch Snowflake
	/*kochCurve(p0, p1, 6);
	kochCurve(p1, p2, 6);
	kochCurve(p2, p0, 6);*/

        EndDrawing();
    }

	CloseWindow();
}

void kochCurveAnimation(Vector2 p0, Vector2 p1, ref int limit) { 
	if(limit++ > 8) {
		limit = 8;
	}

	kochCurve(p0, p1, limit);
}

void kochCurve(Vector2 p0, Vector2 p1, int limit) {
	Vector2 dist = Vector2(p1.x - p0.x, p1.y - p0.y);	// distance between the points p0 and p1

	float length = sqrt(dist.x*dist.x + dist.y*dist.y)/3;	// length from p0 to p1 => a^2 + b^2 = c^2
	float angle = atan2(dist.y, dist.x) - PI/3; 		// = 60*PI/180  |  change the PI/3 to PI/1.6 for wave like pattern

	Vector2 a = Vector2(p0.x + dist.x/3, p0.y + dist.y/3);
	Vector2 c = Vector2(p1.x - dist.x/3, p1.y - dist.y/3);
	Vector2 b = Vector2(a.x + cos(angle)*length, a.y + sin(angle)*length);

	if(limit < 1) {
		DrawLineEx(p0, a, 1.5, BLACK);
		DrawLineEx(a, b, 1.5, BLACK);
		DrawLineEx(b, c, 1.5, BLACK);
		DrawLineEx(c, p1, 1.5, BLACK);

		return;
	}

	kochCurve(p0, a, limit-1);
	kochCurve(a, b, limit-1);
	kochCurve(b, c, limit-1);
	kochCurve(c, p1, limit-1);
}















