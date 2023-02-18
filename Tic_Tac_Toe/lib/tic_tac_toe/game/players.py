"""
    Created By: Norman Thien
    Creation Date: 15 Feb 2023
    Last Modified: 18 Feb 2023
    
    AI player 
"""
#imports
import abc
from tic_tac_toe.logic.exceptions import InvalidMove
from tic_tac_toe.logic.models import GameState, Mark, Move

from tic_tac_toe.logic.models import Mark

#define as abstract class
class Player(metaclass=abc.ABCMeta):
    def __init__(self, mark: Mark) -> None:
        self.mark = mark

    def make_move(self, game_state: GameState) -> GameState:
        if self.mark is game_state.current_mark:
            if move := self.get_move(game_state):
                return move.after_state
            raise InvalidMove("No more possible moves")
        else:
            raise InvalidMove("It's the other player's turn")

    @abc.abstractmethod
    def get_move(self, game_state: GameState) -> Move | None:
        """Return the current player's move in the given game state."""