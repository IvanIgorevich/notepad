if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative "#{__dir__}/lib/post.rb"
require_relative "#{__dir__}/lib/memo.rb"
require_relative "#{__dir__}/lib/link.rb"
require_relative "#{__dir__}/lib/task.rb"
require 'optparse'

# Все опции
options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать (по умолчанию любой)') { |o| options[:type] = o } #
  opt.on('--id POST_ID', 'если задан id — показываем подробно только этот пост') { |o| options[:id] = o } #
  opt.on('--limit NUMBER', 'сколько последних постов показать (по умолчанию все)') { |o| options[:limit] = o } #

end.parse!

result = {
  limit: options[:limit],
  type: options[:type],
  id: options[:id]
}

if !result[:id].nil?
  post = Post.find_by_id(result[:id])
  puts "Запись #{post.class.name}, id = #{options[:id]}"

  post.to_strings.each do |line|
    puts line
  end

else
  result = Post.find_all(options[:limit], options[:type])
  print "| id\t| @type\t|  @created_at\t\t\t|  @text \t\t\t| @url\t\t| @due_date \t "

  result&.each do |row|
    puts

    row.each do |element|
      print "|  #{element.to_s.delete("\\n\\r")[0..40]}\t"
    end

  end
end

puts
