require 'win32ole'
require 'win32/registry'

# ps = WIN32OLE.connect("winmgmts:\\\\.")
# ps.InstancesOf("win32_process").each do |p|
#   puts "Process: #{p.name}"
#   puts "\tID: #{p.processid}"
#   puts "\tPATH: #{p.executablepath}"
#   puts "\tTHREADS: #{p.threadcount}"
#   puts "\tPRIORITY: #{p.priority}"
#   puts "\tCMD_ARGS: #{p.commandline}"
#   puts "\tSTATUS: #{p.status}"
# end
#
# Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows NT\CurrentVersion') do |reg|
#   puts reg['ProductName']
#   puts reg['PathName', Win32::Registry::REG_SZ]
#
#   reg.each_value { |name, type, data| puts "#{name} = #{data}" }
#   reg.each_key { |key, wtime| puts "#{key} ::  #{wtime}" }
# # Do your dirty work here!
# end

excel = WIN32OLE.new('Excel.Application')
puts excel.methods - Object.methods
#puts excel.methods.grep /ole/
#excel.methods.grep /ole/i
#puts excel.ole_methods.collect!{ |e| e.to_s }.sort
