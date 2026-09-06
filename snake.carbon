// SPDX-License-Identifier: MIT
// Adapted from https://github.com/raysan5/raylib-games/blob/master/classics/src/snake.c
import Core library "io";
import Types library "types";

import Cpp library "<string_view>";
import Cpp library "raylib/include/raylib.h";

import Cpp inline '''
/* Carbon doesn't handle enums yet? */
#define RL_KEY_ENTER 257
#define RL_KEY_RIGHT 262
#define RL_KEY_LEFT 263
#define RL_KEY_DOWN 264
#define RL_KEY_UP 265

#define SNAKE_LEN 256
#define SQUARE_SZ 31
''';

impl Types.Vec2 as Core.As(Cpp.Vector2) {
    fn Convert(self) -> Cpp.Vector2
    {
        var vec: Cpp.Vector2;
        vec.x = self.x as f32;
        vec.y = self.y as f32;

        return vec;
    }
}

impl Types.Color as Core.As(Cpp.Color) {
    fn Convert(self) -> Cpp.Color
    {
        var color: Cpp.Color;
        color.r = self.r;
        color.g = self.g;
        color.b = self.b;
        color.a = self.a;

        return color;
    }
}

let SCREEN_WIDTH: i32 = 800;
let SCREEN_HEIGHT: i32 = 450;

var frame_counter: i32 = 0;
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

fn Run() { 
    Cpp.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, Cpp.std.data("Snake\0"));
    init_game();

    Cpp.SetTargetFPS(60);

    while (not Cpp.WindowShouldClose()) {
        update_game();
        Cpp.BeginDrawing();
        draw_game();
        Cpp.EndDrawing();
    }

    Cpp.CloseWindow();
}

fn get_random_pos() -> Types.Vec2;

fn update_game()
{
    if (game_over) {
        if (Cpp.IsKeyPressed(Cpp.RL_KEY_ENTER)) {
            game_over = false;
            init_game();
        }
        return;
    }

    if (Cpp.IsKeyPressed('P' as i32)) {
        pause = not pause;
    }

    if (pause) {
        return;
    }

    if (Cpp.IsKeyPressed(Cpp.RL_KEY_RIGHT) and (snake[0].speed.x == 0) and 
        allow_move) {
        snake[0].speed = { .x = Cpp.SQUARE_SZ, .y = 0 };
        allow_move = false;
    }

    if (Cpp.IsKeyPressed(Cpp.RL_KEY_LEFT) and (snake[0].speed.x == 0) and 
        allow_move) {
        snake[0].speed = { .x = -Cpp.SQUARE_SZ, .y = 0 };
        allow_move = false;
    }

    if (Cpp.IsKeyPressed(Cpp.RL_KEY_UP) and (snake[0].speed.y == 0) and 
        allow_move) {
        snake[0].speed = { .x = 0, .y = -Cpp.SQUARE_SZ };
        allow_move = false;
    }

    if (Cpp.IsKeyPressed(Cpp.RL_KEY_DOWN) and (snake[0].speed.y == 0) and 
        allow_move) {
        snake[0].speed = { .x = 0, .y = Cpp.SQUARE_SZ };
        allow_move = false;
    }

    for (i: i32 in Core.Range(Cpp.SNAKE_LEN)) {
        snake_position[i] = snake[i].position;
    }

    if (frame_counter % 5 == 0) {
        for (i: i32 in Core.Range(tail_counter)) {
            if (i == 0) {
                snake[0].position.x += snake[0].speed.x;
                snake[0].position.y += snake[0].speed.y;
                allow_move = true;
            } else {
                snake[i].position = snake_position[i - 1];
            }
        }
    }

    if (snake[0].position.x > SCREEN_WIDTH - offset.x or
        snake[0].position.y > SCREEN_HEIGHT - offset.y or
        snake[0].position.x < 0 or snake[0].position.y < 0) {
        game_over = true;
        return;
    }

    for (i: i32 in Core.InclusiveRange(1, tail_counter - 1)) {
        if (snake[0].position.x == snake[i].position.x and
            snake[0].position.y == snake[i].position.y) {
            game_over = true;
            return;
        }
    }

    if (not fruit.active) {
        fruit.active = true;
        fruit.position = get_random_pos();

        var i: i32 = 0;
        while (i < tail_counter) {
            while (fruit.position.x == snake[i].position.x and
                fruit.position.y == snake[i].position.y)
            {
                fruit.position = get_random_pos();
                i = 0;
            }
            ++i;
        }
    }

    if (snake[0].position.x < fruit.position.x + Cpp.SQUARE_SZ and
        snake[0].position.x + Cpp.SQUARE_SZ > fruit.position.x and
        snake[0].position.y < fruit.position.y + Cpp.SQUARE_SZ and
        snake[0].position.y + Cpp.SQUARE_SZ > fruit.position.y) {
        snake[tail_counter].position = snake_position[tail_counter - 1];
        ++tail_counter;
        fruit.active = false;
    }

    ++frame_counter;
}

fn get_random_pos() -> Types.Vec2
{
    return {
        .x = Cpp.GetRandomValue(0, SCREEN_WIDTH / Cpp.SQUARE_SZ - 1) *
            Cpp.SQUARE_SZ + offset.x / 2,
        .y = Cpp.GetRandomValue(0, SCREEN_HEIGHT / Cpp.SQUARE_SZ - 1) *
            Cpp.SQUARE_SZ + offset.y / 2
    };
}

var item_size: Types.Vec2 = { .x = Cpp.SQUARE_SZ, .y = Cpp.SQUARE_SZ };
var bg_color: Cpp.Color;
var fg_color: Cpp.Color;
var grid_color: Cpp.Color;

fn draw_game()
{
    Cpp.ClearBackground(bg_color);

    if (game_over) {
        Cpp.DrawText(Cpp.std.data("PRESS [ENTER] TO PLAY AGAIN"),
            SCREEN_WIDTH / 2 -
                Cpp.MeasureText(Cpp.std.data("PRESS [ENTER] TO PLAY AGAIN"),
                20) / 2,
            SCREEN_HEIGHT / 2 - 20, 20, fg_color
        );

        return;
    }

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

    for (i: i32 in Core.Range(tail_counter)) {
        var snek: Types.Snake = snake[i];
        Cpp.DrawRectangleV(snek.position as Cpp.Vector2, item_size as
            Cpp.Vector2, snek.color as Cpp.Color);
    }

    Cpp.DrawRectangleV(fruit.position as Cpp.Vector2, item_size as
        Cpp.Vector2, fruit.color as Cpp.Color);

    if (pause) {
        Cpp.DrawText(Cpp.std.data("GAME PAUSED"),
            SCREEN_WIDTH / 2 -
                Cpp.MeasureText(Cpp.std.data("GAME PAUSED"), 40) / 2,
            SCREEN_HEIGHT / 2 - 40, 40, fg_color
        );
    }
}

fn init_game()
{
    bg_color.r = 245;
    bg_color.g = 245;
    bg_color.b = 245;
    bg_color.a = 255;

    fg_color.r = 130;
    fg_color.g = 130;
    fg_color.b = 130;
    fg_color.a = 255;

    grid_color.r = 200;
    grid_color.g = 200;
    grid_color.b = 200;
    grid_color.a = 255;

    frame_counter = 0;
    game_over = false;
    pause = false;

    tail_counter = 1;
    allow_move = true;

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
