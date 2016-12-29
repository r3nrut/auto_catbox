require 'json'

funcHash = Hash.new
scriptHash = Hash.new
usedFindersHash = Hash.new
notUsedFindersHash = Hash.new


Dir["c:/dev/**/**/*.dtsx"].each { |file|
  next if File.directory? file
  functions = File.readlines(file).select { |line| line =~ /\s*DTS:PropertyExpression/ }
  functions.map! {|line| line.chomp.strip.sub(/\s*/,'').delete "()"}
  funcHash[file] = functions if functions.length > 0
}
puts "#{funcHash.values.flatten.count} references located in #{funcHash.count} files\n"

Dir["c:/dev/GS.EIM.SSIS/**/*"].each {|file|
  next if File.directory? file
  scriptHash[file] = File.open(file, "r").read
}
puts "#{scriptHash.length} *Reference files found"

# for each finder file
funcHash.each {|finder_file, finders|
  # for each finder
  finders.each {|finder_name|
    usage_count = 0
    # search through every script source file summing up occurrences of the finder
    # the value part of the hash is the content for each file
    # scriptHash.each {|script_name, script_content|
    #   usage_count += script_content.scan(/#{finder_name}/).length
    # }
    findersHash = (usage_count == 0) ? notUsedFindersHash : usedFindersHash
    finders_arr = findersHash[finder_file]
    finders_arr = Array.new if finders_arr.nil?
    finder_rep = (usage_count == 0) ? finder_name : finder_name + ' ==> ' + usage_count.to_s
    finders_arr << finder_rep
    findersHash[finder_file] = finders_arr
  }
}

puts "#{notUsedFindersHash.values.flatten.count} references have not been used"
puts "#{usedFindersHash.values.flatten.count} references have been used\n"
puts "See files generated - ScrapedShitz.csv"
#
File.open('ScrapedShitz.csv', "w") do |file|
  file.puts JSON.pretty_generate(notUsedFindersHash)
end




