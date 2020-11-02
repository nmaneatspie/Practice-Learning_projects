#Norman Thien
#Created 25/10/2020

#Simple Game: Tic Tac Toe
#Shouldn't need much explanation. Two modes: singleplayer (1 Human and simple AI: for time being does random move) and two-player (2 Humans) [To be done later]
# Board positions shall be as follows:
# 1 | 2 | 3
# 4 | 5 | 6
# 7 | 8 | 9

#libraries
import sys
import datetime
import time
import pygame as pg
import inspect
from inspect import getframeinfo, currentframe

err_line = getframeinfo(currentframe()).lineno

debug = True  #For visual studio testing

#Game window variables
width = 600
height = 600
status_height = 100

fps = 30

board = [[]*3, []*3, []*3] #setting up 3x3 board

#other variables
char = 'x' #store 'x' or 'o' as char value.

state = "Setup" #current game state. States are: setup, play1, play2, draw, win
winner = None
#Functions
#File writing function
def write_file(filename, err_num):
    try:
        if debug:
            from os.path import dirname, join
            current_dir = dirname(__file__)
            file_path = join(current_dir, "Error_log.txt")
            file = open(file_path, 'a')
            return file
        else:
            file = open("Error_log.txt", 'a')
            return file
    except:
        error_log(err_num, filename)
    sys.exit([2])

#Error logging code: file related
def error_log(err_num, err_line = getframeinfo(currentframe()).lineno, filename = "No file provided",):

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
            if err_line != None: file.write("last Err_call line: {}\n".format(err_line))
            file.close()
        except:
            sys.exit([2])
        sys.exit([1])

def init_window():
    try:
        err_line = getframeinfo(currentframe()).lineno
        scr.blit(cover_img, (0,0))

        #Update window
        pg.display.update()
        time.sleep(0.5)
        scr.blit(bg_img, (0,0))
        pg.display.update()
        state = "play1"
        draw_status()
    except:
        error_log(2, err_line)

def draw_status():

    text_width = 1
    text_colour = (255, 255, 255)
    status_colour = (210, 210, 210)

    msg = ""

    if state == "win":
        if winner == 'x': winning_player = 1
        else: winning_player = 0
        msg = "player {} won".format(winning_player)
    elif state == "draw":
        msg = "A draw"
    elif state == "play1":
        msg = "player 1 turn"
    elif state == "play2":
        msg = "player 2 turn"

    try:
        err_line = getframeinfo(currentframe()).lineno
        font = pg.font.Font(None,30)
        text = font.render(msg, text_width, text_colour)
        scr.fill(status_colour, (0, width, height+status_height, status_height))
        text_rect = text.get_rect(center =(width/2, (height+status_height) - (status_height/2)))
        scr.blit(text, text_rect)
        pg.display.update()
    except:
        error_log(2, err_line)

def check_win():
    global board, state

    #check for winning diagonals then columsn then rows
    if (board[0][0] == board[1][1] == board[2][2]) and board[1][1] != None:
        state = "win"
        winner = board[1][1]
        #Do stuff to show which one's are winning combination
    elif (board[0][2] == board[1][1] == board[2][0]) and board[1][1] != None:
        state = "win"
        winner = board[1][1]
        #Do stuff to show which one's are winning combination

#Initialization
try:
    err_line = getframeinfo(currentframe()).lineno
    pg.init()
    CLK = pg.time.Clock()

    scr = pg.display.set_mode((width, height + status_height), 0 , fps)
    pg.display.set_caption("Tic Tac Toe") #Window name
except:
    error_log(2, err_line)

cover_imagefile = "cover.png"
bg_imagefile = "bg_image.png"
x_imagefile = "x_image.png"
o_imagefile = "o_image.png"

if debug:
    from os.path import dirname, join
    current_dir = dirname(__file__)
    cover_imagefile = join(current_dir, cover_imagefile)
    bg_imagefile = join(current_dir, bg_imagefile)
    x_imagefile = join(current_dir, x_imagefile)
    o_imagefile = join(current_dir, o_imagefile)

obj_height = 100
obj_width  = 100

try:
    err_line = getframeinfo(currentframe()).lineno
    cover_img = pg.image.load(cover_imagefile).convert()
except:
    error_log(1, err_line, cover_imagefile)
try:
    err_line = getframeinfo(currentframe()).lineno
    bg_img = pg.image.load(bg_imagefile).convert()
except:
    error_log(1, err_line, bg_imagefile)
try:
    err_line = getframeinfo(currentframe()).lineno
    x_img = pg.image.load(x_imagefile).convert()
except:
    error_log(1, err_line, x_imagefile)
try:
    err_line = getframeinfo(currentframe()).lineno
    o_img = pg.image.load(o_imagefile).convert()
except:
    error_log(1, err_line, o_imagefile)

#scaling images
try:
    err_line = getframeinfo(currentframe()).lineno
    cover_img = pg.transform.scale(cover_img, (width, height + status_height))
    bg_img = pg.transform.scale(bg_img, (width, height))
    x_img = pg.transform.scale(x_img, (obj_width, obj_height))
    o_img = pg.transform.scale(o_img, (obj_width, obj_height))
except:
    error_log(2, err_line)

init_window()
