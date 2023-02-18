"""
    Created By: Norman Thien
    Creation Date: 15 Feb 2023
    Last Modified: 18 Feb 2023
    
    File for custom exceptions
"""

class InvalidGameState(Exception):
    """Raised when the game state is invalid."""

class InvalidMove(Exception):
    """Raised when the move is invalid."""