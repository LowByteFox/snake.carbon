// SPDX-License-Identifier: MIT
// Adapted from https://github.com/raysan5/raylib-games/blob/master/classics/src/snake.c
import Core library "io";

import Cpp library "<string_view>";
import Cpp library "raylib/include/raylib.h";

fn Run() {
    var screenWidth: i32 = 800;
    var screenHeight: i32 = 450;
    var bgColor: Cpp.Color;
    var textColor: Cpp.Color;
    bgColor.r = 245;
    bgColor.g = 245;
    bgColor.b = 245;
    bgColor.a = 0xFF;
    textColor.r = 200;
    textColor.g = 200;
    textColor.b = 200;
    textColor.a = 0xFF;
    
    Cpp.InitWindow(screenWidth, screenHeight, Cpp.std.data("raylib [core] example - basic window\0"));
    Cpp.SetTargetFPS(60);

    while (not Cpp.WindowShouldClose()) {
        Cpp.BeginDrawing();
            Cpp.ClearBackground(bgColor);

            Cpp.DrawText(Cpp.std.data("Congrats! You created your first window!\0"),
                190, 200, 20, textColor);
        Cpp.EndDrawing();
    }

    Cpp.CloseWindow();
}
