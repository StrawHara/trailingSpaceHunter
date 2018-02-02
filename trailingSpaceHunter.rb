#!/usr/bin/env ruby
unless ARGV.count >= 1
  puts "Usage: #{File.basename(__FILE__)} DirectoryToParse/."
  exit 1
end

require 'find'

project_directory = ARGV[0]

pathes = []
# Find.find("/tmp") do |f|

Find.find("#{project_directory}") do |path|
  pathes << path unless FileTest.directory?(path)
end

sorted_pathes = []
pathes.each do |path|
  if path[-6, 6] == ".swift" || path[-2, 2] == ".f" || path[-2, 2] == ".m"
    sorted_pathes << path
  end
end

stats = { :lines => 0, :chars => 0, :files => 0 }

sorted_pathes.each do |path|

  file = File.open(path, "r")
  file_content = file.read()

  new_content = ""
  stats_lines = 0
  stats_chars = 0

  file_content.each_line do |line|

    length = line.length
               
    line.each_char.with_index do |char, index|

      if char == " "
        if index == (length - 2)
          line = "\n"
          stats_lines += 1
          stats_chars += length
        end
      else
        break
      end
    end

    new_content << line

  end

  stats[:lines] += stats_lines
  stats[:chars] += stats_chars
  if stats_lines > 0
    stats[:files] += 1
  end
  file = File.open(path, "w")
  file.puts new_content

end

puts "#{stats[:chars]} whitespaces removed in #{stats[:lines]} lines. #{stats[:files]} files modified on #{sorted_pathes.count} reviewed\n#{stats[:chars]/1000}KB saved"
