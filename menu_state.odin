package main

import rl "vendor:raylib"

import "core:fmt"

MenuState :: struct{
    play_rect: rl.Rectangle,
    draw_rect: bool,
    play: bool,

    add_timer: bool,
    show_next_node: bool,
}

collission_rect_mouse :: proc(rect: rl.Rectangle) -> bool{
    pos := rl.GetMousePosition()
    if pos.x > rect.x && pos.x < rect.x + rect.width && pos.x > rect.y && pos.y < rect.y + rect.height{
        return true
    }
    return false
}

menu_state_update :: proc(mstate: MenuState) -> MenuState{
    mstate := mstate
    if collission_rect_mouse(mstate.play_rect){
        if rl.IsMouseButtonPressed(.LEFT){
            mstate.play = true
        }
        mstate.draw_rect = true
    }
    else{
        mstate.draw_rect = false
    }

    if rl.IsKeyPressed(.ENTER){
        mstate.play = true
    }

    if rl.IsKeyPressed(.ONE){
        mstate.add_timer = !mstate.add_timer 
    }
    if rl.IsKeyPressed(.TWO){
        mstate.show_next_node = !mstate.show_next_node
    }
    return mstate
}

menu_state_render :: proc(mstate: MenuState){
    if mstate.draw_rect{
        rl.DrawRectangleRec(mstate.play_rect, rl.Color{0, 0, 0, 75})
    }
    rl.DrawText("PLAY", i32(mstate.play_rect.x + 5), i32(mstate.play_rect.y), 70, rl.BLACK)
    rl.DrawText("Show Timer: ", i32(mstate.play_rect.x - 75), i32(mstate.play_rect.y + 100), 50, rl.BLACK)

    if !mstate.add_timer{
        rl.DrawText("OFF", i32(mstate.play_rect.x + 230), i32(mstate.play_rect.y + 100), 50, {255, 153, 128, 255})
    }
    else{
        rl.DrawText("ON", i32(mstate.play_rect.x + 230), i32(mstate.play_rect.y + 100), 50, {108, 235, 112, 255})
    }

    rl.DrawText("Show next node: ", i32(mstate.play_rect.x - 140), i32(mstate.play_rect.y + 175), 50, rl.BLACK)
    if !mstate.show_next_node{
        rl.DrawText("OFF", i32(mstate.play_rect.x + 280), i32(mstate.play_rect.y + 175), 50, {255, 153, 128, 255})
    }
    else{
        rl.DrawText("ON", i32(mstate.play_rect.x + 280), i32(mstate.play_rect.y + 175), 50, {108, 235, 112, 255})
    }
}

