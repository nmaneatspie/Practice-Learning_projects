#Norman Thien
#Created 25/10/2020

#Practice code for OOP Python programming
#Simple Game
#Will have borders, a character and static objects to block movement. A few random moving objects will appear
#Goal is to move character to avoid moving objects for as long as possible.
#Objects & player move on player input

#libraries
import random

#Class setup
class player:
    def __init__(self, pos, hp=2):
        #inital position (x,y). To be changed once dimensions determined; to start in the centre
        self.pos = [0,0]
        self.hp = 2 #2 hitpoints = 2 hits before game over
    def get_sym(self):
        return 'p'

class dyn_obj:
    def __init__(self, pos,epos):
        #starting pos
        self.cpos = [-1,-1]
        #end pos
        self.epos = [0,0]

    def get_sym(self):
        return '@'

#functions
def exists(arr, tocheck):
    for x in arr:
        if tocheck == x:
            return True
    return False

#Variable init
zone_x = 16
zone_y = 14
num_stat_obj = 14

stat_obj_sym = 'm'

char_start = [(zone_x-2)/2, (zone_y-2)/2]
static_obj_pos = []

for i in range(0, num_stat_obj, 1):
    static_obj_pos.append([random.randint(1,zone_x-1),random.randint(1,zone_y-1)])


#init objects
human = player(char_start)
enable = False

#init visual locations of objects row by row
for y in range(0, zone_y, 1):
    for x in range(0, zone_x, 1):
        pos = [x,y]
        if pos == [x,0] or pos == [x,zone_y-1] or pos == [0, y] or pos == [zone_x-1, y]:
            print('+', end=' ')
        else:
            if [x,y] == char_start:
                print(human.get_sym(),end=' ')
            elif exists(static_obj_pos, [x,y]):
                print(stat_obj_sym,end=' ')
            else:
                print(' ',end=' ')
    print('', end='\n')

#Update row by row on player move

#movement logic?
#use exists to pre-check movement in case obbject is in that direction
#if static: no move, maybe ignore or all other objects move?
#if dynamic/moving object then move to that position but lose 1 hp
#if dynamic object hit then it disappears
#plus 1 score per move