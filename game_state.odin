package main

import rl "vendor:raylib"

import "core:math/rand"
import "core:strings"
import "core:strconv"
import "core:fmt"

GameState :: struct{
    color_on: rl.Color,
    color_off: rl.Color,

    selected_square: int,
    next_node: int,
    square_size: i32,
    empty_void: i32,

    seconds: int,
    miliseconds: int,
    score: int,
    lives: int,

    square_correct: rl.Sound,
    sound_incorrect: rl.Sound,

    show_timer: bool,
    show_next_node: bool,
}

game_state_update :: proc(gstate: GameState) -> GameState{
    gstate := gstate

        //-------UPDATING-----------
        if rl.IsKeyPressed(.D) && gstate.selected_square == 0{
            gstate.selected_square = gstate.next_node
            gstate.next_node = int(rand.int31_max(4))
            gstate.score += 1

            rl.PlaySound(gstate.square_correct)
        }
        else if rl.IsKeyPressed(.D) && gstate.selected_square != 0{
            rl.PlaySound(gstate.sound_incorrect)
            gstate.lives -= 1
        }

        if rl.IsKeyPressed(.F) && gstate.selected_square == 1{
            gstate.selected_square = gstate.next_node
            gstate.next_node = int(rand.int31_max(4))
            gstate.score += 1

            rl.PlaySound(gstate.square_correct)
        }
        else if rl.IsKeyPressed(.F) && gstate.selected_square != 1{
            rl.PlaySound(gstate.sound_incorrect)
            gstate.lives -= 1
        }

        if rl.IsKeyPressed(.J) && gstate.selected_square == 2{
            gstate.selected_square = gstate.next_node
            gstate.next_node = int(rand.int31_max(4))
            gstate.score += 1

            rl.PlaySound(gstate.square_correct)
        }
        else if rl.IsKeyPressed(.J) && gstate.selected_square != 2{
            rl.PlaySound(gstate.sound_incorrect)
            gstate.lives -= 1
        }

        if rl.IsKeyPressed(.K) && gstate.selected_square == 3{
            gstate.selected_square = gstate.next_node
            gstate.next_node = int(rand.int31_max(4))
            gstate.score += 1

            rl.PlaySound(gstate.square_correct)
        }
        else if rl.IsKeyPressed(.K) && gstate.selected_square != 3{
            rl.PlaySound(gstate.sound_incorrect)
            gstate.lives -= 1
        }

        gstate.miliseconds -= 1
        if gstate.miliseconds == 0{
            gstate.miliseconds = 60
            gstate.seconds -= 1 
        }

    return gstate
}

game_state_render :: proc(gstate: GameState){
        score_text := strings.builder_make()
        strings.write_string(&score_text, "score: ")

	    buf: [4]byte
	    strconv.itoa(buf[:], gstate.score)
        strings.write_bytes(&score_text, buf[:])

        time := strings.builder_make()
	    strconv.itoa(buf[:], gstate.seconds)
        if gstate.seconds < 10{
            strings.write_rune(&time, '0')
            strings.write_bytes(&time, buf[0:1])
        }
        else{
            strings.write_bytes(&time, buf[0:2])
        }
        strings.write_rune(&time, ':')

	    strconv.itoa(buf[:], gstate.miliseconds)
        if gstate.seconds < 10{
            strings.write_rune(&time, '0')
            strings.write_bytes(&time, buf[0:1])
        }
        else{
            strings.write_bytes(&time, buf[0:2])
        }

	    buf2: [4]byte
        lives := strings.builder_make()
        strings.write_string(&lives, "lives: ")
        strconv.itoa(buf2[:], gstate.lives)
        strings.write_bytes(&lives, buf2[:])

        if gstate.show_timer{
            rl.DrawText(strings.clone_to_cstring(strings.to_string(time)), WIDTH / 2 - 100, HEIGHT / 2 - 300, 80, rl.BLACK)
        }
        rl.DrawText(strings.clone_to_cstring(strings.to_string(score_text)),WIDTH / 2 - 80, HEIGHT / 2 - 220, 40, rl.BLACK)
        rl.DrawText(strings.clone_to_cstring(strings.to_string(lives)),WIDTH / 2 - 70, HEIGHT / 2 - 170, 40, rl.BLACK)

        empty_void := gstate.empty_void
        square_size := gstate.square_size

        for i in 0..<4{
            color: rl.Color
            if gstate.selected_square == i{
                rl.DrawRectangle(i32(i + 1) * empty_void + i32(i) * square_size, HEIGHT - 250, square_size, square_size, gstate.color_on)
                color = rl.WHITE
            }
            else if gstate.next_node == i{
                rl.DrawRectangle(i32(i + 1) * empty_void + i32(i) * square_size, HEIGHT - 250, square_size, square_size, {gstate.color_on.r, gstate.color_on.g, gstate.color_on.b, 50})   
                color = rl.BLACK
            }
            else{
                rl.DrawRectangle(i32(i + 1) * empty_void + i32(i) * square_size, HEIGHT - 250, square_size, square_size, gstate.color_off)
                color = rl.BLACK
            }
            switch i{
                case 0:
                    rl.DrawText("D", i32(i + 1) * empty_void + i32(i) * square_size + square_size / 2, HEIGHT - 250 + square_size / 2, 40, color)
                case 1:
                    rl.DrawText("F", i32(i + 1) * empty_void + i32(i) * square_size + square_size / 2, HEIGHT - 250 + square_size / 2, 40, color)
                case 2:
                    rl.DrawText("J", i32(i + 1) * empty_void + i32(i) * square_size + square_size / 2, HEIGHT - 250 + square_size / 2, 40, color)
                case 3:
                    rl.DrawText("K", i32(i + 1) * empty_void + i32(i) * square_size + square_size / 2, HEIGHT - 250 + square_size / 2, 40, color)
            }
        }
}

game_state_end :: proc(gstate: GameState) -> bool{
    if gstate.seconds < 1 || gstate.lives < 1{
        return true
    }
    return false
}
