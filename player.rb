require 'pry'
require 'ruby-poker'

class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
    player_cards = game_state["players"][game_state["in_action"]]["hole_cards"]
    community_cards = game_state["community_cards"]

    combination = check_combination(player_cards, community_cards)
    p combination

    case combination
    when :royal_flush
      return raise_bet(game_state, 500)
    when :straight_flush
      return raise_bet(game_state, 500)
    when :four_of_a_kind
      return raise_bet(game_state, 500)
    when :full_house
      return raise_bet(game_state, 500)
    when :flush
      return raise_bet(game_state, 300)
    when :straight
      return raise_bet(game_state, 300)
    when :three_of_kind
      return raise_bet(game_state, 200)
    when :two_pair
      return raise_bet(game_state, 150)
    when :pair
      better_pairs = possible_better_pairs(player_cards, community_cards)
      case better_pairs
        when 0
          return raise_bet(game_state, 150)
        when 1
          return raise_bet(game_state, 100)
        else
          cards = player_cards + community_cards
          if good_pair?(cards)
            if stop_loss?(game_state, 100)
              return 0
            else
              return call(game_state)
            end
          else
            if stop_loss?(game_state, 50)
              return 0
            else
              return call(game_state)
            end
          end
      end
    when :high_hand
      if community_cards.length < 3
        if stop_loss?(game_state, 100)
          return 0
        else
          return call(game_state)
        end
      end
    end

    0
  end

  def showdown(game_state)
  end

  def possible_better_pairs(player_cards, community_cards)
    my_pair_rank = get_pair(player_cards + community_cards)

    all_cards = player_cards + community_cards

    better_cards = all_cards.select do |card|
      rank_force(card["rank"]) > rank_force(my_pair_rank)
    end

    better_cards.length
  end

  def rank_force(rank)
    ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].find_index(rank)
  end

  def good_pair?(cards)
    card = get_pair(cards)
    ["A", "K", "Q", "J", "10"].include?(card)
  end

  def get_pair(cards)
    ranks = cards.map do |card|
      card["rank"]
    end
    hash = ranks.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h  }.select{|k,v| v == 2}
    card = hash.keys[0]
  end

  def stop_loss?(game_state, stop)
    if game_state["current_buy_in"] > stop
      true
    else
      false
    end
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
    when !!pair?(player_cards, community_cards)
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
      rank = card['rank']
      rank = "T" if rank == "10"
      "#{rank}#{card['suit'][0]}"
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
