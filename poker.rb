require 'rspec/autorun'

def evaluate_hands(black, white)
    blacks_cards_by_suit = []
    whites_cards_by_suit = []

    black.each do |k,v|
        blacks_cards_by_suit << v
    end

    white.each do |k,v|
        whites_cards_by_suit << v
    end

    if blacks_cards_by_suit.flatten.length != 5 or whites_cards_by_suit.flatten.length != 5
        "Oops. A hand needs 5 cards"
    else
        card_values = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']

        # *** check if hands have pair
        blacks_pair = nil
        whites_pair = nil

        blacks_cards_not_in_pairs = []
        whites_cards_not_in_pairs = []

        black.each do |k, v|
            if black[k].class == Array
                blacks_pair = k
            end
        end

        white.each do |k, v|
            if white[k].class == Array
                whites_pair = k
            end
        end

        # evaluate which pair has higher value
        if blacks_pair && whites_pair
            card_values.reverse.each do |v|
                if blacks_pair == v && !whites_pair == v
                    return 'Black wins!'
                elsif !blacks_pair == v && whites_pair == v
                    return 'White wins!'
                elsif blacks_pair == v && whites_pair == v
                    # remove similar pairs in both hands so that remaining cards are evaluated below
                    black.delete(v)
                    white.delete(v)
                end
            end
        end

        # *** case where there are no pairs existing in both hands
        card_values.reverse.each do |v|
            if black.has_key?(v) && white.has_key?(v)
                next
            elsif black.has_key?(v) && !white.has_key?(v)
                return "Black wins!"
            elsif !black.has_key?(v) && white.has_key?(v)
                return "White wins!"
            end
        end

        return "It's a tie!"
    end
end

describe "#evaluate_hands" do
    it "returns error message if any hand does not have five cards" do
        black = {'2' => 'H', '3' => 'D', '5' => 'S', '9' => 'C', 'K' => 'D'}
        white = {'2' => 'C', '3'=> 'H', '4' => 'S', '8' => 'C'}

        expect(evaluate_hands(black, white)).to eq('Oops. A hand needs 5 cards')
    end

    it "returns hand with high card as winner" do
        # Black: 2H 3D 5S 9C KD 
        # White: 2C 3H 4S 8C AH
        # Output: White wins
        black = {'2' => 'H', '3' => 'D', '5' => 'S', '9' => 'C', 'K' => 'D'}
        white = {'2' => 'C', '3'=> 'H', '4' => 'S', '8' => 'C', 'A' => 'H'}

        # white has Ace high card
        expect(evaluate_hands(black, white)).to eq('White wins!')
    end

    it "returns hand with the higher valued pair as winner" do
        black = {'2' => 'H', '3' => 'D', '5' => 'S', '7' => ['C','D']}
        white = {'2' => 'C', '3'=> 'H', '4' => 'S', 'A' => ['C','H']}

        expect(evaluate_hands(black,white)).to eq('White wins!')
    end

    it "returns hand with highest value card (in descending order) if pairs in both hands are similar" do
        black = {'2' => 'H', '3' => 'D', '5' => 'S', 'A' => ['C','D']}
        white = {'2' => 'C', '4'=> 'H', '5' => 'S', 'A' => ['C','H']}

        expect(evaluate_hands(black,white)).to eq('White wins!')
    end

    it "returns a tie if hands contain cards with the exact same value" do
        black = {'2' => 'H', '3' => 'D', '5' => 'S', 'A' => ['C','D']}
        white = {'2' => 'C', '3'=> 'C', '5' => 'D', 'A' => ['C','H']}

        expect(evaluate_hands(black,white)).to eq('It\'s a tie!')
    end
end