// SPDX-License-Identifier: MIT
// Adapted from https://github.com/raysan5/raylib-games/blob/master/classics/src/snake.c
package Types library "types";

import Cpp library "raylib/include/raylib.h";

class Vec2 {
    var x: f32;
    var y: f32;
}

impl Vec2 as Core.Default {
    fn Op() -> Self
    {
        return { .x = 0, .y = 0 };
    }
}

impl Vec2 as Core.Copy {
    fn Op(self) -> Self
    {
        return { .x = self.x, .y = self.y };
    }
}

impl Vec2 as Core.UnformedInit {}

class Color {
    var r: u8;
    var g: u8;
    var b: u8;
    var a: u8;
}

impl Color as Core.Copy {
    fn Op(self) -> Self
    {
        return {
            .r = self.r,
            .g = self.g,
            .b = self.b,
            .a = self.a,
        };
    }
}

class Snake {
    var position: Vec2;
    var size: Vec2;
    var speed: Vec2;
    var color: Color;
}

impl Snake as Core.Default {
    fn Op() -> Self 
    {
        return {
            .position = { .x = 0, .y = 0 },
            .size = { .x = 0, .y = 0 },
            .speed = { .x = 0, .y = 0 },
            .color = { .r = 0, .g = 0, .b = 0, .a = 0 },
        };
    }
}

impl Snake as Core.Copy {
    fn Op(self) -> Self
    {
        return {
            .position = self.position,
            .size = self.size,
            .speed = self.speed,
            .color = self.color
        };
    }
}

impl Snake as Core.UnformedInit {}

class Food {
    var position: Vec2;
    var size: Vec2;
    var active: bool;
    var color: Color;
}

impl Food as Core.Default {
    fn Op() -> Self
    {
        return {
            .position = { .x = 0, .y = 0 },
            .size = { .x = 0, .y = 0 },
            .active = false,
            .color = { .r = 0, .g = 0, .b = 0, .a = 0 },
        };
    }
}
