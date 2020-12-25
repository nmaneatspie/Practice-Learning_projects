"""
Norman Thien
Created 25/10/2020

Simple Game: Tic Tac Toe
Shouldn't need much explanation. Two modes: singleplayer
(1 Human and simple AI: for time being does random move)
and two-player (2 Humans) [To be done later]

This code will not be following PEP8 style.
"""
#Global pylint disables for this file
# pylint: disable = redefined-outer-name, global-statement, invalid-name
# pylint: disable = missing-function-docstring


# Libraries
import sys
import datetime
import time
import inspect # pylint: disable = unused-import
from inspect import getframeinfo, currentframe
import pygame as pg

err_line = getframeinfo(currentframe()).lineno

#Game window variables
width = 600 #if changed, need to change obj_width
height = 600 #if changed, need to change obj_height
status_height = 100

#Image variables
sides = 20 #remove some amount from edge
#obj_height = height/3 - sides #crashes for some reason, need to check again!!!!!!!!!!!!!!
#obj_width  = width/3 - sides
obj_height = 200 - sides
obj_width = 200 - sides

fps = 1

board = [['0']*3, ['0']*3, ['0']*3] #setting up 3x3 board

#other variables
state = "Setup" #current game state. States are: setup, play1, play2, draw, win, again?
winner = None
run = True

#Functions
#File writing function
def write_file(filename, err_num):

    try:
        file = open("Error_log.txt", 'a')
        return file
    except: # pylint: disable = bare-except
        error_log(err_num, filename)
    sys.exit([2])

#Error logging code: file related
def error_log(
        err_num,
        err_line = getframeinfo(currentframe()).lineno, #pylint: disable = bad-whitespace
        filename = "No file provided" #pylint: disable = bad-whitespace
    ):

    if err_num == -1: #Prevent looping when writing error to log
        sys.exit([2])
    else:
        err_msg = {
            1: "Could not load image {}".format(filename),
            2: ""
        }
        try:
            file = write_file(filename, -1)
            file.write("{} ".format(datetime.datetime.now()))
            file.write("{}".format(err_msg.get(err_num)))
            if err_line is not None:
                file.write("last Err_call line: {}\n".format(err_line))
            file.close()
        except: # pylint: disable = bare-except
            sys.exit([2])
        sys.exit([1])

def init_window():

    global state

    try:
        err_line = getframeinfo(currentframe()).lineno
        scr.blit(cover_img, (0, 0))

        #Update window
        pg.display.update()
        time.sleep(0.5)
        scr.blit(bg_img, (0, 0))
        pg.display.update()
        state = "play1"
        draw_status()
    except: # pylint: disable = bare-except
        error_log(2, err_line)

def draw_status():

    text_width = 1
    text_colour = (255, 255, 255)

    msg = ""

    if state == "win":
        if winner == 'x':
            winning_player = 1
        else:
            winning_player = 0
        msg = "player {} won".format(winning_player)
    elif state == "draw":
        msg = "A draw"
    elif state == "play1":
        msg = "player 1 turn"
    elif state == "play2":
        msg = "player 2 turn"

    try:
        err_line = getframeinfo(currentframe()).lineno
        font = pg.font.SysFont('Arial', 30)
        text = font.render(msg, text_width, text_colour)
        text_rect = text.get_rect(center = (width/2, (height+status_height) - (status_height/2))) # pylint: disable = bad-whitespace
        scr.blit(text, text_rect)
        pg.display.update()
    except: # pylint: disable = bare-except
        error_log(2, err_line)

def check_win():

    global board, state, winner

    #check for winning diagonals then columsn then rows
    if (board[0][0] == board[1][1] == board[2][2]) and board[1][1] != '0':
        winner = board[1][1]
        state = "win"
        #Do stuff to show which one's are winning combination
    elif (board[0][2] == board[1][1] == board[2][0]) and board[1][1] != '0':
        winner = board[1][1]
        state = "win"
    else:
        draw = True

        for i in range(0, 3):

            if (board[i][0] == board[i][1] == board[i][2]) and board[i][0] != '0': #row same
                winner = board[i][0]
                state = "win"
            elif (board[0][i] == board[1][i] == board[2][i]) and board[0][i] != '0': #column same
                winner = board[0][i]
                state = "win"

            if state != "win" and draw is True:
                for j in range(0, 3):
                    if board[i][j] == '0':
                        draw = False
                        break

        if draw is True:
            state = "draw"
            print(state)

     #stub
    if state == "win":
        if winner is not None:
            print(winner)
            state = "again?" #To do: ask if player wants to play again
        else:
            print('error with winner')
            state = "again?"
    elif state == "draw":
        print('Draw')
        state = "again?"

def player_move(player): #To Do for 'o' player, need to change the image input based on player

    global board, state, scr, width, height, x_img, o_img, sides

    if pg.mouse.get_pressed()[0]: # and player == 'x':
        x, y = pg.mouse.get_pos()

        if player == 'x':
            img = x_img
        else:
            img = o_img

        moved = False

        # pylint: disable = pointless-string-statement
        """
        Regions:
        1 | 2 | 3
        4 | 5 | 6
        7 | 8 | 9
        """
        # pylint: enable = pointless-string-statement
        first_row = y < height/3
        second_row = (y > height/3 and y < 2*height/3)
        third_row = (y > 2*height/3 and y < height)
        first_col = x < width/3
        second_col = (x > width/3 and x < 2*width/3)
        third_col = x > 2*width/3

        Region1 = first_col and first_row and board[0][0] == '0'
        Region2 = second_col and first_row and board[0][1] == '0'
        Region3 = third_col and first_row and board[0][2] == '0'
        Region4 = first_col and second_row and board[1][0] == '0'
        Region5 = second_col and second_row and board[1][1] == '0'
        Region6 = third_col and second_row and board[1][2] == '0'
        Region7 = first_col and third_row and board[2][0] == '0'
        Region8 = second_col and third_row and board[2][1] == '0'
        Region9 = third_col and third_row and board[2][2] == '0'

        if Region1:
            board[0][0] = player
            scr.blit(img, (sides/2, sides/2))
            moved = True

        elif Region2:
            board[0][1] = player
            scr.blit(img, (width/3 + sides/2, sides/2))
            moved = True

        elif Region3:
            board[0][2] = player
            scr.blit(img, (2*width/3 + sides/2, sides/2))
            moved = True

        elif Region4:
            board[1][0] = player
            scr.blit(img, (sides/2, height/3 + sides/2))
            moved = True

        elif Region5:
            board[1][1] = player
            scr.blit(img, (width/3 + sides/2, height/3 + sides/2))
            moved = True

        elif Region6:
            board[1][2] = player
            scr.blit(img, (2*width/3 + sides/2, height/3 + sides/2))
            moved = True

        elif Region7:
            board[2][0] = player
            scr.blit(img, (sides/2, 2*height/3 + sides/2))
            moved = True

        elif Region8:
            board[2][1] = player
            scr.blit(img, (width/3 + sides/2, 2*height/3 + sides/2))
            moved = True

        elif Region9:
            board[2][2] = player
            scr.blit(img, (2*width/3 + sides/2, 2*height/3 + sides/2))
            moved = True

        if moved is True:
            pg.display.update()

            if state == 'play1':
                state = 'play2'
            else:
                state = 'play1'

#Initialization
try:
    err_line = getframeinfo(currentframe()).lineno

    #individual pygame modules init
    #pg.init()
    pg.display.init()
    err_line = getframeinfo(currentframe()).lineno
    pg.font.init()

    err_line = getframeinfo(currentframe()).lineno
    CLK = pg.time.Clock()

    scr = pg.display.set_mode((width, height + status_height), 0, fps)
    pg.display.set_caption("Tic Tac Toe") #Window name
except: # pylint: disable = bare-except
    error_log(2, err_line)

cover_imagefile = "cover.png"
bg_imagefile = "bg_image.png"
x_imagefile = "x_image.png"
o_imagefile = "o_image.png"

try:
    err_line = getframeinfo(currentframe()).lineno
    cover_img = pg.image.load(cover_imagefile).convert()
except: # pylint: disable = bare-except
    error_log(1, err_line, cover_imagefile)
try:
    err_line = getframeinfo(currentframe()).lineno
    bg_img = pg.image.load(bg_imagefile).convert()
except: # pylint: disable = bare-except
    error_log(1, err_line, bg_imagefile)
try:
    err_line = getframeinfo(currentframe()).lineno
    x_img = pg.image.load(x_imagefile).convert()
except: # pylint: disable = bare-except
    error_log(1, err_line, x_imagefile)
try:
    err_line = getframeinfo(currentframe()).lineno
    o_img = pg.image.load(o_imagefile).convert()
except: # pylint: disable = bare-except
    error_log(1, err_line, o_imagefile)

#scaling images
try:
    err_line = getframeinfo(currentframe()).lineno
    cover_img = pg.transform.scale(cover_img, (width, height + status_height))
    bg_img = pg.transform.scale(bg_img, (width, height))
    x_img = pg.transform.scale(x_img, (obj_width, obj_height))
    o_img = pg.transform.scale(o_img, (obj_width, obj_height))
except: # pylint: disable = bare-except
    error_log(2, err_line)

init_window()

try:
    while run:
        pg.event.pump()
        draw_status()
        if state != "again?":
            check_win()
            if state == 'play1':
                player_move('x')
            elif state == 'play2':
                player_move('o')

    time.sleep(2)
    pg.quit()
    sys.exit([0])
except SystemExit:
    pg.quit()
