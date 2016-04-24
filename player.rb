require 'pry'

class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
    player_cards = game_state["players"][game_state["in_action"]]["hole_cards"]
    community_cards = game_state["community_cards"]
    p check_combination(player_cards, community_cards)

    if game_state["community_cards"].length >= 3
      if check_combination(player_cards, community_cards) == :pair
        return call(game_state)
      end
    else
      if check_combination(player_cards, community_cards) == :high_hand
        return call(game_state)
      end
    end

    0
  end

  def showdown(game_state)
  end

  def call(game_state)
    game_state["current_buy_in"] - game_state["players"][game_state["in_action"]]["bet"]
  end

  def check_combination(player_cards, community_cards = [])
    # писать по убыванию старшинства
    case true
    when royal_flush?(player_cards, community_cards)
      return :royal_flush
    when straight_flush?(player_cards, community_cards)
      return :straight_flush
    when four_of_a_kind?(player_cards, community_cards)
      return :four_of_a_kind
    when full_house?(player_cards, community_cards)
      return :full_house
    when flush?(player_cards, community_cards)
      return :flush
    when straight?(player_cards, community_cards)
      return :straight
    when three_of_kind?(player_cards, community_cards)
      return :three_of_kind
    when two_pair?(player_cards, community_cards)
      return :two_pair
    when pair?(player_cards, community_cards)
      return :pair
    when high_hand?(player_cards, community_cards)
      return :high_hand
    else
      nil
    end
  end

  def pair?(player_cards, community_cards)
    card1 = player_cards[0]
    card2 = player_cards[1]
    community_ranks = community_cards.map {|c| c["rank"] }

    return true if card1["rank"] == card2["rank"]
    return true if community_ranks.include? card1["rank"]
    return true if community_ranks.include? card2["rank"]

    false
  end

  def two_pair?(player_cards, community_cards)

    false
  end

  def three_of_kind?(player_cards, community_cards)

    false
  end

  def straight?(player_cards, community_cards)

    false
  end

  def flush?(player_cards, community_cards)

    false
  end

  def full_house?(player_cards, community_cards)

    false
  end

  def four_of_a_kind?(player_cards, community_cards)

    false
  end

  def straight_flush?(player_cards, community_cards)

    false
  end

  def royal_flush?(player_cards, community_cards)

    false
  end

	def high_hand(player_cards, community_cards)
		player_cards.each do |card|
      if card.rank == 'A' || card.rank == 'K' || card.rank == 'Q'
        return true
      end
    end

    false
	end
end
