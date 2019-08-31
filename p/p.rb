#! /home/john/.rvm/rubies/ruby-2.6.3/bin/ruby

class SpecialPrint    
    def initialize()
        @colours = {
            black: "\u001b[30m",
            red: "\u001b[31m",
            green: "\u001b[32m",
            yellow: "\u001b[33m",
            blue: "\u001b[34m",
            magenta: "\u001b[35m",
            cyan: "\u001b[36m",
            white: "\u001b[37m",
            reset: "\u001b[0m"
        }
        
        # Define each colour print method
        @colours.each do |colour_key, escape|
            self.define_singleton_method(colour_key) { |msg| "#{escape}#{msg}#{@colours[:reset]}" }
        end
    end

    def print(*args)
        methods = args[0].split(",")
        methods.reduce(args[1]) { |string, method| self.send(method, string) }
    end

    def help(args)
        '
p (ruby script) - a command line print program
==============================================

p method[,method1,method2] message which can be many words

VISUAL METHODS:

        black
        red
        green
        yellow
        blue
        magenta
        cyan
        white {message} ............ Prints message in that colour

        rainbow {message} .......... Prints a message in rainbow colours

        upcase {message} ........... Prints a message in uppercase

        downcase {message} ......... Prints a message in lowercase

        ascend {message} ........... Print a message in capitals with spaces between each letter

        lower_ascend {message} ..... Print a message in lowercase with spaces between each letter

        mocking {message} .......... Prints a message tHaT mOcKs YoU

UTILITY METHODS:

        stringify .................. Converts text to a string that can be used in your favourite programming language
        '
    end

    def rainbow(msg)
        rainbow_colours = [:red, :yellow, :green, :blue, :cyan, :magenta]
        msg.split("").each_with_index.inject("") { |acc, (element, index)|
            acc += (element == " ") ? " " : self.send(rainbow_colours[index % 6], element)
        }
    end

    def stringify(msg)
        p msg
        "^^ string above ^^"
    end

    def ascend(msg)
        msg.split("").inject("") { |final_string, char| final_string += char.upcase + " " }
    end

    def lower_ascend(msg)
        msg.split("").inject("") { |final_string, char| final_string += char.downcase + " " }
    end

    def mocking(msg)
        offset = 0
        msg.split("").each_with_index.inject("") { |final_string, (char, index)|
            offset += 1 if char == " "
            final_string += (((index + offset).odd?) ? char.upcase : char.downcase )
        }
    end

    def downcase(msg)
        msg.downcase
    end

    def upcase(msg)
        msg.upcase
    end

end


printer = SpecialPrint.new

puts printer.print(ARGV[0], ARGV[1..-1].join(" "))


