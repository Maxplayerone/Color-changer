package main

import rl "vendor:raylib"

import "core:strings"
import "core:strconv"
import "core:os"
import "core:fmt"

EndState :: struct{
    highscore: int,
}

end_state_create :: proc(highscore: int) -> EndState{
    return EndState{
        highscore = highscore,
    }
}

end_state_render :: proc(estate: EndState){
    hs_text := strings.builder_make()
    strings.write_string(&hs_text, "Highscore: ")
    buf: [4]byte
    strconv.itoa(buf[:], estate.highscore)
    strings.write_bytes(&hs_text, buf[:])

    rl.DrawText(strings.clone_to_cstring(strings.to_string(hs_text)), WIDTH / 2 - 250, HEIGHT / 2 - 100, 75, rl.BLACK)
    pb, pb_ok := os.read_entire_file_from_filename("pb.txt")

    if pb_ok{
        pb_text := strings.builder_make()
        strings.write_string(&pb_text, "Previous best: ")
        strings.write_bytes(&pb_text, pb[:])

        rl.DrawText(strings.clone_to_cstring(strings.to_string(pb_text)), WIDTH / 2 - 200, HEIGHT / 2, 40, rl.BLACK)
    }
}
