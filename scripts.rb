#! /home/john/.rvm/rubies/ruby-2.6.3/bin/ruby
#$ {"name": "scripts", "language": "ruby", "description": "Lists all scripts"}
# ^^ Use this format in every script in the tree (parsed as json)

require "json"

script_array = []

scripts = Dir["/home/john/scripts/**/*"]

scripts.each do |scriptfile|
    if File.file? scriptfile
        File.open(scriptfile, "r") do |f|
            f.each_line do |line|
                line = line.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
                if /(#|\/\/)\$ {/.match(line) != nil
                    script_info = JSON.parse(line.gsub(/(#|\/\/)\$ /, ""))
                    script_array << script_info
                    break;
                end
            end
        end
    end
end

script_array.sort_by {|script_hash| script_hash["name"]}.each do |script_info|
    # print " " * (60 - (script_info["language"].length + script_info["name"].length))  
    puts "#{script_info['name']} (#{script_info['language']})\t\t\t\t#{script_info['description']}"
end
