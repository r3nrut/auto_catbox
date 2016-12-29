require 'zip/zip'

unless ARGV[0]
  puts "Usage: ruby file_compressor.rb <filename.ext>"
  puts "Example: ruby file_compressor.rb thisShit.exe"
  exit
end

file = ARGV[0].chomp

if File.exist?(file)
  print "Enter compress file name:"
  zip = "#{gets.chomp}.zip"
    Zip::ZipFile.open(zip,true) do |zipfile|

      begin
        puts "#{file} is being compressed to archive... eventually... maybe..."
        zipfile.add(file,file)
      rescue Exception => e
        puts "Error adding to compressed archive: \n #{e}"
        puts "Good luck making sense of it.  MWHAHAHAHAHAHA"
      end
    end
else
  puts "\nFile could not be found fool.  Fix it."
end