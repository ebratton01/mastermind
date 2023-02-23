# frozen_string_literal: true

require_relative 'solver'

module Board
    def code_colors(number)
        {
          '1' => "\e[101m  1  \e[0m ",
          '2' => "\e[106m  2  \e[0m ",
          '3' => "\e[44m  3  \e[0m ",
          '4' => "\e[102m  4  \e[0m ",
          '5' => "\e[46m  5  \e[0m ",
          '6' => "\e[105m  6  \e[0m ",
        }[number]
    end

    def clue(peg)
        {
          'o' => "\e[91m \u25CF \e[0m",
          'x' => "\e[37m \u25CF \e[0m",
        }[peg]
    end

    def display_board(breaker)
        breaker.get_guess
        breaker.get_clues
    end
end