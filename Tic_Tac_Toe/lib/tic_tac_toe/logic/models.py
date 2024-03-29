"""
    Created By: Norman Thien
    Creation Date: 15 Feb 2023
    Last Modified: 18 Feb 2023

    This file hosts the definitions for the tic-tac-toe domain model objects.
"""
#imports

import enum
import re
from dataclasses import dataclass
from functools import cached_property
from tic_tac_toe.logic.exceptions import InvalidMove
from tic_tac_toe.logic.validators import validate_game_state, validate_grid

#Var

WINNING_PATTERNS = (
    "???......",
    "...???...",
    "......???",
    "?..?..?..",
    ".?..?..?.",
    "..?..?..?",
    "?...?...?",
    "..?.?.?..",
)


#for game grid
"""
        defined as an immutable object for increased fault tolerance and code readability.
        issue is that the cells (object) cannot be altered once created.
"""
@dataclass(frozen=True)
class Grid:
    cells: str = " " * 9
    """
        Wrongly initialised cells can break the game so we only allow object to exist in
        a valid state only, otherwise the object won't be created at all 
        following fail-fast and always-valid domain model principles.
        post initialization to perform cell validation. Method in validators.py
    """
    def __post_init__(self) -> None:
        validate_grid(self)
        
    #return number of crosses, naughts or empty cells
        
    @cached_property
    def x_count(self) -> int:
        return self.cells.count("X")

    @cached_property
    def o_count(self) -> int:
        return self.cells.count("O")
    
    @cached_property
    def empty_count(self) -> int:
        return self.cells.count(" ")
    
# Player Marks
"""
    Since there are only two symbols belonging to a fixed set of discrete values, 
    you can define them within an enumerated type or enum. 
    Using enums is preferable over constants due to their enhanced type safety, common namespace, 
    and programmatic access to their members.
    sometimes be more convenient to think about the player 
    marks in terms of strings instead of enum members.
    Because enums are glorified classes, 
    you're free to put ordinary methods and properties into them
"""
class Mark(str, enum.Enum):
    CROSS = "X"
    NAUGHT = "O"

    @property
    def other(self) -> "Mark":
        return Mark.CROSS if self is Mark.NAUGHT else Mark.NAUGHT

@dataclass(frozen=True)
class Move:
    mark: Mark
    cell_index: int
    before_state: "GameState"
    after_state: "GameState"

@dataclass(frozen=True)
class GameState:
    grid: Grid
    starting_mark: Mark = Mark("X")

    def __post_init__(self) -> None:
        validate_game_state(self)

    #determine who's turn to move
    @cached_property
    def current_mark(self) -> Mark:
        if self.grid.x_count == self.grid.o_count:
            return self.starting_mark
        else:
            return self.starting_mark.other
    
    #identify empty cells that can be filled by the current player
    @cached_property
    def possible_moves(self) -> list[Move]:
        moves = []
        if not self.game_over:
            for match in re.finditer(r"\s", self.grid.cells):
                moves.append(self.make_move_to(match.start()))
        return moves
    
    """
        player make move (input), check valid then add the move to a new Grid
        Containing old Grid values and the new move.
    """
    def make_move_to(self, index: int) -> Move:
        if self.grid.cells[index] != " ":
            raise InvalidMove("Cell is not empty")
        return Move(
            mark=self.current_mark,
            cell_index=index,
            before_state=self,
            after_state=GameState(
                Grid(
                    self.grid.cells[:index]
                    + self.current_mark
                    + self.grid.cells[index + 1:]
                ),
                self.starting_mark,
            ),
        )
    
    #determine if game not started i.e. blank cells
    @cached_property
    def game_not_started(self) -> bool:
        return self.grid.empty_count == 9
    
    #in tie state or there is a winner
    @cached_property
    def game_over(self) -> bool:
        return self.winner is not None or self.tie

    #tie when no winner and no empty cells
    @cached_property
    def tie(self) -> bool:
        return self.winner is None and self.grid.empty_count == 0
    
    #Pattern match the winner
    @cached_property
    def winner(self) -> Mark | None:
        for pattern in WINNING_PATTERNS:
            for mark in Mark:
                if re.match(pattern.replace("?", mark), self.grid.cells):
                    return mark
        return None
    
    """
    @cached_property
    def winning_cells(self) -> list[int]:
        for pattern in WINNING_PATTERNS:
            for mark in Mark:
                if re.match(pattern.replace("?", mark), self.grid.cells):
                    return [
                        match.start()
                        for match in re.finditer(r"\?", pattern)
                    ]
        return []

    """