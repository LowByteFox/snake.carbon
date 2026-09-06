// SPDX-License-Identifier: MIT
// Adapted from https://github.com/raysan5/raylib-games/blob/master/classics/src/snake.c
import Core library "io";
import Types library "types";

import Cpp library "<string_view>";
import Cpp library "raylib/include/raylib.h";

import Cpp inline '''
#define SNAKE_LEN 256
#define SQUARE_SZ 31
''';


let SCREEN_WIDTH: i32 = 800;
let SCREEN_HEIGHT: i32 = 450;

var frames_counter: i32 = 0;
var game_over: bool = false;
var pause: bool = false;

var fruid: Types.Food;
var snake: array(Types.Snake, Cpp.SNAKE_LEN);
var snake_position: array(Types.Vec2, Cpp.SNAKE_LEN);

var allow_move: bool = false;
var offset: Types.Vec2;
var tail_counter: i32 = 0;

fn init_game();
fn update_game();
fn draw_game();
fn unload_game();
fn update_and_draw_game();

fn Run() {
    // Need manual initialization, Carbon needs helping hand
    for (i: i32 in Core.Range(Cpp.SNAKE_LEN)) {
        var blank: Types.Snake;
        snake[i] = blank;
    }

    for (i: i32 in Core.Range(Cpp.SNAKE_LEN)) {
        var blank: Types.Vec2;
        snake_position[i] = blank;
    }

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
