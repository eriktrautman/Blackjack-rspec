require 'rspec'
require_relative 'blackjack'

include Blackjack



describe 'Deck' do
  let(:deck) { Deck.new }
  it 'should start with 52 cards' do
    deck
  end

  describe "#shuffle" do
    it 'should be able to shuffle the cards' do
      expect do
        deck.shuffle
      end.to change { deck.cards }
    end
  end

  describe '#take' do
    it 'should be able to deal out cards' do
      dealt_cards = deck.take(1)
      deck.cards.count.should eq(51)

      deck.cards.include?(dealt_cards[0]).should be_false
    end
  end

  describe "#return" do
    let(:deck) { Deck.new([]) }

    it 'should be able to return cards to the deck' do
      hand = [Card.new(:clubs, :six), Card.new(:diamonds, :king)]
      deck.return(hand)
      deck.cards.should =~ hand
    end

    it 'should return the cards to the bottom of the deck' do
      d = Deck.new
      hand = d.take(3)
      d.return(hand)

      d.cards[0..2].should =~ hand  #.include?(hand[0]).should be_false
    end
  end
end

describe 'Hand' do
  let(:deck) { double("deck") }

  subject(:normal_hand) do
    Hand.new([
      Card.new(:clubs, :queen),
      Card.new(:hearts, :deuce)
      ])
  end

  it 'should deal a hand of two cards' do
    deck.should_receive(:take).with(2).and_return([Card.new(:clubs, :deuce), Card.new(:hearts, :queen)])
    hand = Hand.deal_from(deck)
    hand.cards.count.should == 2
  end

  describe '#points' do
    it 'should get the correct point value for standard cards' do
      hand = Hand.new([Card.new(:clubs, :deuce), Card.new(:hearts, :queen)])
      hand.points.should == 12
    end

    it 'should default the aces at 11' do
      hand = Hand.new([Card.new(:clubs, :queen), Card.new(:hearts, :ace)])
      hand.points.should == 21
    end

    it 'should make aces value 1 if hand would be bust' do
      hand = Hand.new([Card.new(:clubs, :queen), Card.new(:hearts, :ace), Card.new(:hearts, :deuce)])
      hand.points.should == 13
    end

  end

  describe '#busted' do
    it "should return true if over 21" do
      card1 = Card.new(:clubs, :queen)
      card2 = Card.new(:hearts, :jack)
      card3 = Card.new(:hearts, :queen)
      hand = Hand.new([card1,card2,card3])
      hand.busted?.should be_true
    end
  end

  describe '#hit' do
    it "should make a call to the deck with take with value 1" do
      deck.stub(:take).with(1) {[Card.new(:hearts, :four)]}
      deck.should_receive(:take).with(1)
      normal_hand.hit(deck)
    end

    it "should add a card to the hand" do
      deck.stub(:take).with(1) {[Card.new(:hearts, :four)]}
      normal_hand.hit(deck)
      normal_hand.cards.count.should == 3
    end
  end


end

#comment




