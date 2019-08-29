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
        method = args[0]
        self.send(method, *args[1..-1])
    end

    def rainbow(msg)
        rainbow_colours = [:red, :yellow, :green, :blue, :cyan, :magenta]
        return msg.split("").each_with_index.inject("") { |acc, (element, index)|
            acc += (element == " ") ? " " : self.send(rainbow_colours[index % 6], element)
        }
    end

end


printer = SpecialPrint.new

puts printer.print(ARGV[0], ARGV[1..-1].join(" "))


