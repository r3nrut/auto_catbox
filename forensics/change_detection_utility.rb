# Usage Example
# jruby C:\dev\QAAutomationScripts\Utilities\change_detection_utility.rb "C:/Users/dturner/Syncplicity Folders"

require 'find'
require 'digest/md5'
require 'win32/eventlog'
require 'win32/mc'

unless ARGV[0] and File.directory?(ARGV[0])
	puts "\n\n\nGimme da root: changedFiles.rb
<directory>\n\n\n\n"
	exit
end

root = ARGV[0]
oldfile_hash = Hash.new
newfile_hash = Hash.new
file_report = "#{root}/analysis_report.txt"
file_output = "#{root}/file_list.txt"
oldfile_output = "#{root}/file_list.old"

if File.exists?(file_output)
  File.rename(file_output, oldfile_output)
  File.open(oldfile_output, 'rb') do |infile|
    while (temp = infile.gets) 
	line =  /(.+)\s{5,5}(\w{32,32})/.match(temp)
	put "#{line[1]} ---> #{line[2]}"
	oldfile_hash[line[1]] = line[2]
  end
end
end

Find.find(root) do |file|
	next if /^\./.match(file)
	next unless File.file?(file)
	begin
		newfile_hash[file] = Digest::MD5.hexdigest(File.read(file))
			puts newfile_hash.inspect
    	m = MC.new("filechanged.mc")
    	m.create_all
    	dll_file = File.expand_path(m.dll_file)


				EventLog.add_event_source(
						'source'                => "Application",
						'key_name'              => "foo",
						'category_count'        => 2,
						'event_message_file'    => dll_file,
						'category_message_file' => dll_file
				)

	rescue
		puts "Error reading #{file} --- MD5 hash not computed."
	end
end

report = File.new(file_report, 'wb')
changed_files = File.new(file_output, 'wb')

newfile_hash.each do |file, md5|
	changed_files.puts "#{file}		#{md5}"
	puts "#{file}		#{md5}"
end

newfile_hash.keys.select { |file| newfile_hash[file] == oldfile_hash[file]}.each do |file|
	newfile_hash.delete(file)
	oldfile_hash.delete(file)
end

newfile_hash.each do |file, md5|
	report.puts "#{oldfile_hash[file] ? 'Changed' : 'Added'} file: #{file} 		#{md5}"
	puts "#{oldfile_hash[file] ? 'Changed' : 'Added'} file: #{file} 		#{md5}"
	oldfile_hash.delete(file)
end

oldfile_hash.each do |file, md5|
	report.puts "Deleted/Moved file: #{file}		#{md5}"
end

report.close
changed_files.close


#Good artists copy, great artists steal.
#																		 Pablo Picasso
