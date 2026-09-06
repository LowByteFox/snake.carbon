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

var fruit: Types.Food;
var snake: array(Types.Snake, Cpp.SNAKE_LEN);
var snake_position: array(Types.Vec2, Cpp.SNAKE_LEN);

var allow_move: bool = false;
var offset: Types.Vec2;
var tail_counter: i32 = 1;

fn init_game();
fn update_game();
fn draw_game();
fn unload_game();
fn update_and_draw_game();

fn Run() { 
    Cpp.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, Cpp.std.data("Snake\0"));
    init_game();

    Cpp.SetTargetFPS(60);

    while (not Cpp.WindowShouldClose()) {
        Cpp.BeginDrawing();
        draw_game();
        Cpp.EndDrawing();
    }

    Cpp.CloseWindow();
}

var bg_color: Cpp.Color;
var grid_color: Cpp.Color;

fn draw_game()
{
    Cpp.ClearBackground(bg_color);

    if (not game_over) {
        // draw grid
        for (i: i32 in Core.Range(SCREEN_WIDTH / Cpp.SQUARE_SZ + 1)) {
            var start: Cpp.Vector2;
            var end: Cpp.Vector2;

            start.x = (Cpp.SQUARE_SZ * i + offset.x / 2) as f32;
            start.y = (offset.y / 2) as f32;
            end.x = (Cpp.SQUARE_SZ * i + offset.x / 2) as f32;
            end.y = (SCREEN_HEIGHT - offset.y / 2) as f32;
            Cpp.DrawLineV(start, end, grid_color);
        }

        for (i: i32 in Core.Range(SCREEN_HEIGHT / Cpp.SQUARE_SZ + 1)) {
            var start: Cpp.Vector2;
            var end: Cpp.Vector2;

            start.x = (offset.x / 2) as f32;
            start.y = (Cpp.SQUARE_SZ * i + offset.y / 2) as f32;
            end.x = (SCREEN_WIDTH - offset.x / 2) as f32;
            end.y = (Cpp.SQUARE_SZ * i + offset.y / 2) as f32;
            Cpp.DrawLineV(start, end, grid_color);
        }
    } else {
    }
}

fn init_game()
{
    bg_color.r = 245;
    bg_color.g = 245;
    bg_color.b = 245;
    bg_color.a = 255;

    grid_color.r = 200;
    grid_color.g = 200;
    grid_color.b = 200;
    grid_color.a = 255;

    offset.x = SCREEN_WIDTH % Cpp.SQUARE_SZ;
    offset.y = SCREEN_HEIGHT % Cpp.SQUARE_SZ;

    for (i: i32 in Core.Range(Cpp.SNAKE_LEN)) {
        snake[i].position = { .x = offset.x / 2, .y = offset.y / 2 };
        snake[i].speed = { .x = Cpp.SQUARE_SZ, .y = 0 };

        if (i == 0) {
            snake[i].color = { .r = 137, .g = 224, .b = 81, .a = 255 };
        } else {
            snake[i].color = { .r = 34, .g = 34, .b = 34, .a = 255 };
        }
    }

    for (i: i32 in Core.Range(Cpp.SNAKE_LEN)) {
        var blank: Types.Vec2;
        snake_position[i] = blank;
    }

    fruit.color = { .r = 243, .g = 75, .b = 125, .a = 255 };
    fruit.active = false;
}
