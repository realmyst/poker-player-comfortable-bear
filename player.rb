
class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
    small_blind = game_state["small_blind"]
    small_blind * 2
  end

  def showdown(game_state)
  end

  def check_combination(player_cards, community_cards = [])
  end

  def have_pair?(player_cards, community_cards = [])
    card1 = player_cards[0]
    card2 = player_cards[1]
    community_ranks = community_cards.map {|c| c["rank"] }

    return true if card1["rank"] == card2["rank"]
    return true if community_ranks.include? card1["rank"]
    return true if community_ranks.include? card2["rank"]

    false
  end
end
