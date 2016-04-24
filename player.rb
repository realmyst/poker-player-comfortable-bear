
class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
    small_blind = game_state["small_blind"]
    small_blind * 2
  end

  def showdown(game_state)

  end
end
