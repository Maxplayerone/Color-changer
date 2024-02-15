package main

import rl "vendor:raylib"

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:strconv"

WIDTH :: 960
HEIGHT :: 720

CurState :: enum{
    Game,
    End,
}

trim_not_number :: proc(buf: []byte) -> []byte{
    n := 0
    for item in buf{
        if item < 48 || item > 57{
            break
        }
        n += 1
    }
    return buf[0:n]
}

atoi_buf :: proc(buf: []byte) -> int{
    num := 0
    for n, i in buf{
        num += int(n) + i * 10
    }

    return num
}

main :: proc(){
    rl.InitWindow(WIDTH, HEIGHT, "color changer")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    game_state := GameState{
        color_on = rl.LIME,
        color_off = rl.BLACK,
        selected_square = int(rand.int31_max(4)),
        score = 0,
        square_size = 100,
        empty_void = (WIDTH - (4 * 100)) / 5,
        seconds = 5,
        miliseconds = 60,
    }

    end_state := EndState{}

    cur_state := CurState.Game

    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        defer rl.EndDrawing()

        rl.ClearBackground(rl.WHITE)

        //------------UPDATING-------------
        switch cur_state{
            case .Game:
                game_state = game_state_update(game_state)

                if game_state.seconds < 0{
                    cur_state = CurState.End
                    end_state = end_state_create(game_state.score)
                }
            case .End:
        }


        //----------RENDERING-------------
        switch cur_state{
            case .Game:
                game_state_render(game_state)
            case .End:
                end_state_render(end_state)
        }
    }

    pb, pb_ok := os.read_entire_file_from_filename("pb.txt")
    if pb_ok{
        pb_num := atoi_buf(pb[:])

        if end_state.highscore > pb_num{
            buf: [4]byte 
            strconv.itoa(buf[:], end_state.highscore)
            os.write_entire_file("pb.txt", trim_not_number(buf[:])) 
        }
    }

}