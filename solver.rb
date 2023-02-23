# frozen_string_literal: true

# require 'pry-byebug'

class Maker
    attr_reader :code

    def initialize(range)
        @code = []
        make_code(range)
    end


    private

    def make_code(range)
        not_valid_code = true
        until !not_valid_code
            puts "What is your code? Please enter 4 numbers in the range 1-6."
            input = gets.chomp.split('')
            input.each do |num|
                if range.include?(num.to_i) && input.length == 4
                    @code.push(num.to_i)
                else
                    puts "Not a valid input, please try again."
                    @code.clear
                    break
                end
            end

            not_valid_code = code.empty? ? true : false
        end
    end



end

class Breaker
    attr_accessor :guesses, :clues

    def initialize
        @guesses = []
        @clues = []
    end

    def break(code)
        code.each_with_index do |value, ind1|
            if value == @guesses[ind1]
                @clues.push('o')
                next
            end
            @guesses.each_with_index do |guess, ind2|
                if @clues[ind2] == 'o' || @clues[ind2] == 'x'
                    next
                end
                if value == guess
                    @clues.push('x')
                end
            end
        end  
    end

    def check_guess(range)
        @guesses.clear
        not_valid_guess = true
        until !not_valid_guess
            input = gets.chomp.split('')
            input.each do |num|
                if range.include?(num.to_i) && input.length == 4
                    @guesses.push(num.to_i)
                else
                    puts "Not a valid input, please try again."
                    @guesses.clear
                    break
                end
            end

            not_valid_guess = @guesses.empty? ? true : false
        end
    end

    def get_guess
        print "Code: "
        guesses.each do |guess|
            print code_colors(guess.to_s)
        end
    end

    def get_clues
        print "    Clues: "
        clues.each do |peg|
            print clue(peg)
        end
        puts
        clues.clear
    end
end