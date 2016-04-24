require 'pry'
require 'ruby-poker'

class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
    player_cards = game_state["players"][game_state["in_action"]]["hole_cards"]
    community_cards = game_state["community_cards"]

    combination = check_combination(player_cards, community_cards)
    p combination

    if almost_flush?(player_cards, community_cards)
      return call(game_state)
    end

    if combination
      case combination
      when :royal_flush
      when :straight_flush
      when :four_of_a_kind
      when :full_house
      when :flush
      when :straight
      when :three_of_kind
      when :two_pair
        return raise_bet(game_state, 100)
      when :pair
        return raise_bet(game_state, 100)
      else
        if community_cards.length < 3
          return call(game_state)
        end
      end
    end

    0
  end

  def showdown(game_state)
  end

  def call(game_state)
    game_state["current_buy_in"] - game_state["players"][game_state["in_action"]]["bet"]
  end

  def raise_bet(game_state, bet)
    call(game_state) + bet
  end

  def check_combination(player_cards, community_cards = [])
    # писать по убыванию старшинства
    case true
    when !!royal_flush?(player_cards, community_cards)
      return :royal_flush
    when !!straight_flush?(player_cards, community_cards)
      return :straight_flush
    when !!four_of_a_kind?(player_cards, community_cards)
      return :four_of_a_kind
    when !!full_house?(player_cards, community_cards)
      return :full_house
    when !!flush?(player_cards, community_cards)
      return :flush
    when !!straight?(player_cards, community_cards)
      return :straight
    when !!three_of_kind?(player_cards, community_cards)
      return :three_of_kind
    when !!two_pair?(player_cards, community_cards)
      return :two_pair
    when pair?(player_cards, community_cards)
      return :pair
    when high_hand?(player_cards, community_cards)
      return :high_hand
    else
      nil
    end
  end

  def make_hand(player_cards, community_cards)
    all_cards = player_cards + community_cards
    cards_for_hand = all_cards.map do |card|
      "#{card['rank']}#{card['suit'][0]}"
    end
    PokerHand.new cards_for_hand
  end

  def pair?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.pair?
  end

  def two_pair?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.two_pair?
  end

  def three_of_kind?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.three_of_a_kind?
  end

  def straight?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.straight?
  end

  def flush?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.flush?
  end

  def almost_flush?(player_cards, community_cards)
    all_cards = player_cards + community_cards
    one_suit_count = {}

    all_cards.each do |card|
      one_suit_count[card["suit"]] ||= 0
      one_suit_count[card["suit"]] += 1
    end

    one_suit_count.each do |suit, count|
      if count >= 4
        return true
      end
    end

    false
  end

  def full_house?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.full_house?
  end

  def four_of_a_kind?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.four_of_a_kind?
  end

  def straight_flush?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.straight_flush?
  end

  def royal_flush?(player_cards, community_cards)
    hand = make_hand(player_cards, community_cards)
    return hand.royal_flush?
  end

  def high_hand?(player_cards, community_cards)
    player_cards.each do |card|
      if card["rank"] == 'A' || card["rank"] == 'K' || card["rank"] == 'Q'
        return true
      end
    end

    false
  end
end
