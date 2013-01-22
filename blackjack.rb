# -*- coding: utf-8 -*-

module Blackjack
  class Card
    SUIT_STRINGS = {
      :clubs    => "♣",
      :diamonds => "♦",
      :hearts   => "♥",
      :spades   => "♠"
    }

    VALUE_STRINGS = {
      :deuce => "2",
      :three => "3",
      :four  => "4",
      :five  => "5",
      :six   => "6",
      :seven => "7",
      :eight => "8",
      :nine  => "9",
      :ten   => "10",
      :jack  => "J",
      :queen => "Q",
      :king  => "K",
      :ace   => "A"
    }

    BLACKJACK_VALUE = {
      :deuce => 2,
      :three => 3,
      :four  => 4,
      :five  => 5,
      :six   => 6,
      :seven => 7,
      :eight => 8,
      :nine  => 9,
      :ten   => 10,
      :jack  => 10,
      :queen => 10,
      :king  => 10
    }

    def self.suits
      SUIT_STRINGS.keys
    end

    def self.values
      VALUE_STRINGS.keys
    end

    attr_reader :suit, :value

    def initialize(suit, value)
      unless Card.suits.include?(suit) and Card.values.include?(value)
        raise "illegal suit (#{suit.inspect}) or value (#{value.inspect})"
      end

      @suit, @value = suit, value
    end

    def blackjack_value
      raise "ace has special value" if value == :ace

      BLACKJACK_VALUE[value]
    end

    def ==(other_card)
      (self.suit == other_card.suit) && (self.value == other_card.value)
    end

    def to_s
      VALUE_STRINGS[value] + SUIT_STRINGS[suit]
    end
  end

  class Deck
    def self.all_cards
      all_cards = []
      Card.suits.product(Card.values).each { |suit, value| all_cards << Card.new(suit, value) }
      all_cards
    end

    attr_reader :cards

    def initialize(cards = Deck.all_cards)
      @cards = cards
    end

    def shuffle
      @cards.shuffle!
    end

    def take(n)
      cards = []
      n.times do
        cards << @cards.pop
      end
      cards
    end

    def return(cards)
      cards.each do |card|
        @cards.unshift(card)
      end
    end
  end

  class Hand
    def self.deal_from(deck)
      cards = deck.take(2)
      Hand.new(cards)
    end

    attr_accessor :cards

    def initialize(cards)
      @cards = cards
    end

    def points
      points = 0
      @cards.each do |card|
        if card.value == :ace
          points += 11
        else
          points += Card::BLACKJACK_VALUE[card.value]
        end
      end
      if points > 21
        points = 0
        @cards.each do |card|
          if card.value == :ace
            points += 1
          else
            points += Card::BLACKJACK_VALUE[card.value]
          end
        end
      end

      points
    end

    def busted?
      return true if points > 21
    end

    def hit(deck)
      @cards = @cards + deck.take(1)
    end

    def beats?(other_hand)
    end

    def return_cards(deck)
    end

    def to_s
      @cards.join(",") + " (#{points})"
    end
  end

  class Player
    attr_reader :name, :bankroll
    attr_accessor :hand

    def initialize(name, bankroll)
    end

    def place_bet(dealer, bet_amt)
    end

    def pay_winnings(bet_amt)
    end

    def return_cards(deck)
    end
  end

  class HumanPlayer < Player
    def request_bet(dealer)
      print_status
      puts "Place bet"
      place_bet(dealer, Integer(gets))
    end

    def play_hand(deck)
      until hand.busted?
        print_status
        puts "    Hit or stay?"
        case gets.chomp.downcase
        when "hit"
          hand.hit(deck)
        when "stay"
          break
        end
      end

      puts "    Hand: #{hand}"
    end

    private
    def print_status
      puts "Name:"
      puts "    Bankroll: #{bankroll}"
      puts "    Hand: #{hand}"
    end
  end

  class Dealer < Player
    attr_reader :bets

    def initialize
    end

    def play_hand(deck)
    end

    def place_bet(dealer, amt)
    end

    def take_bet(player, amt)
    end

    def pay_bets
    end
  end

  class Game
    def initialize(players, dealer = Dealer.new, deck = nil)
      if deck.nil?
        deck = Deck.new
        deck.shuffle
      end

      @players, @dealer, @deck = players, dealer, deck
    end

    def deal_cards
      (@players + [@dealer]).each { |p| p.hand = Hand.deal_from(@deck) }
    end

    def request_bets
      (@players).each { |p| p.request_bet(@dealer) }
    end

    def play_hands
      (@players + [@dealer]).each { |p| p.play_hand(@deck) }
    end

    def resolve_bets
      puts "Dealer hand: #{@dealer.hand}"
      @dealer.pay_bets
    end

    def return_cards
      (@players + [@dealer]).each { |p| p.return_cards(@deck) }
    end

    def play_round
      deal_cards
      request_bets
      play_hands
      resolve_bets
      return_cards

      nil
    end
  end
end
