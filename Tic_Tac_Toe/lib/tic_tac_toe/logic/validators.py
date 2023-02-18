"""
    Created By: Norman Thien
    Creation Date: 15 Feb 2023
    Last Modified: 18 Feb 2023

    File to store validation methods. Keep validation separate from other files whenever possible
"""


#imports
from __future__ import annotations
from typing import TYPE_CHECKING
import re
from tic_tac_toe.logic.exceptions import InvalidGameState

if TYPE_CHECKING:
    from tic_tac_toe.game.players import Player
    from tic_tac_toe.logic.models import Grid, GameState


"""
    Wrongly initialised cells can break the game so we only allow object to exist in
    a valid state only, otherwise the object won't be created at all 
    following fail-fast and always-valid domain model principles.
    post initialization to perform cell validation. 
"""
def validate_grid(grid: Grid) -> None:
    if not re.match(r"^[\sXO]{9}$", grid.cells):
        raise ValueError("Must contain 9 cells of: X, O, or space")
    
def validate_game_state(game_state: GameState) -> None:
    validate_number_of_marks(game_state.grid)
    validate_starting_mark(game_state.grid, game_state.starting_mark)
    validate_winner(
        game_state.grid, game_state.starting_mark, game_state.winner
    )

#more than 1 difference in number of each mark means a turn missed or some other issue
def validate_number_of_marks(grid: Grid) -> None:
    if abs(grid.x_count - grid.o_count) > 1:
        raise InvalidGameState("Wrong number of Xs and Os")

#player who started should have more cells filled    
def validate_starting_mark(grid: Grid, starting_mark: Mark) -> None:
    if grid.x_count > grid.o_count:
        if starting_mark != "X":
            raise InvalidGameState("Wrong starting mark")
    elif grid.o_count > grid.x_count:
        if starting_mark != "O":
            raise InvalidGameState("Wrong starting mark")
        
#if starting player wins then they have more marks, if other player then equal num of marks
def validate_winner(
    grid: Grid, starting_mark: Mark, winner: Mark | None
) -> None:
    if winner == "X":
        if starting_mark == "X":
            if grid.x_count <= grid.o_count:
                raise InvalidGameState("Wrong number of Xs")
        else:
            if grid.x_count != grid.o_count:
                raise InvalidGameState("Wrong number of Xs")
    elif winner == "O":
        if starting_mark == "O":
            if grid.o_count <= grid.x_count:
                raise InvalidGameState("Wrong number of Os")
        else:
            if grid.o_count != grid.x_count:
                raise InvalidGameState("Wrong number of Os")
            
def validate_players(player1: Player, player2: Player) -> None:
    if player1.mark is player2.mark:
        raise ValueError("Players must use different marks")