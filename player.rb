require 'pry'

class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
    game_state["current_buy_in"] - game_state["players"][game_state["in_action"]]["bet"] + 1
  end

  def showdown(game_state)

  end
end
