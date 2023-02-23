# frozen_string_literal: true

require_relative 'board'
require_relative 'solver'

include Board

class Game
    COLOR_RANGE = Range.new(1, 6)

    def initialize
        @game_over = false
    end

    def introdutction
        puts <<~HEREDOC
        Welcome to Mastermind!

        You can play against the computer as a code MAKER or code BREAKER.

        The objective of the code BREAKER is to figure out the computer's randomly
        generated code consisting of four digits chosen from the range 1-6.
        
        An example of code can be: #{code_colors('2')}#{code_colors('3')}#{code_colors('2')}#{code_colors('5')}

        If you guess the correct digit but in the wrong place, you will see a #{clue('x')}.
        If you guess the correct digit in the right place #{clue('o')}.

        For example: #{code_colors('2')}#{code_colors('3')}#{code_colors('2')}#{code_colors('5')} : #{clue('o')}#{clue('x')}#{clue('o')}

        Do you want to be the code maker or code breaker?
        Enter 1 for MAKER and 2 for BREAKER: 
        HEREDOC
        choose_game
    end

    def choose_game
        valid_choice = false
        choice = gets.chomp.to_i
        until valid_choice
            case choice
            when 1
                valid_choice = true
                turns = get_turns
                code_maker(turns)
            when 2
                valid_choice = true
                turns = get_turns
                code_breaker(turns)
            else 
                puts "Not a valid choice, please try again."
            end
        end
    end

    def code_breaker(turns)
        breaker = Breaker.new
        turn = 1
        guesses_left = 4
        turns = turns + 1

        code = Array.new(4) { rand(COLOR_RANGE) }

        puts "Great! The computer will now think of a code..."
        sleep 3

        until turn == turns || @game_over
            if turn == turns
                puts "Final turn! Enter 4 digits to break the code: "
            else
                puts "Turn ##{turn}. Enter 4 digits to break the code: "
            end
            breaker.check_guess(COLOR_RANGE)
            breaker.break(code)

            if breaker.clues.count('o') == 4
                @game_over = true
            end

            display_board(breaker) 

            turn += 1
        end
        if @game_over
            puts "You win! You have broken the code!"
        else
            puts "You lose! The computer is the MASTERMIND!"
        end

        play_again
    end

    def code_maker(turns)
        maker = Maker.new(COLOR_RANGE)
        comp = Breaker.new
        turn = 1
        guesses_left = 4
        turns = turns + 1

        puts "The computer will now try to solve the code."
        
        until turn == turns || guesses_left.zero?
            if turn == 1
                comp.guesses = Array.new(4) { rand(COLOR_RANGE) }
            else
                comp.guesses.each_with_index do |value, index|
                    if value == 0
                        comp.guesses[index] = rand(COLOR_RANGE)
                    end
                end
            end  

            comp.break(maker.code)
            display_board(comp)

            # binding.pry

            maker.code.each_with_index do |value, index|
                if value != comp.guesses[index]
                    comp.guesses[index] = 0
                end
            end

            guesses_left = comp.guesses.count(0)
            turn += 1

            if guesses_left == 0
                puts "Done!"
            else
                puts "Guessing new code..."
                sleep 3
            end
            # binding.pry
        end
    
        if guesses_left.zero?
            puts "You lose! The computer has broken the code."
        else
            puts "You win! You are the MASTERMIND!"
        end

        play_again
    end

    def get_turns
        valid_choice = false
        until valid_choice
            puts "How many turns do you want to allow? (Average is 12)."
            turns = gets.chomp.to_i
            
            if turns > 0 && turns < 20
                valid_choice = true
            else
                puts "Please enter an integer between 0 and 20."
            end
        end
        return turns
    end

    def play_again
        puts "Would you like to play again? Enter 'y' if yes and any key for no: "
        input = gets.chomp

        if input.downcase == 'y'
            Game.new.introdutction
        else
            puts "Farewell."
        end
    end
end