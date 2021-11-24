# Подключаем класс Post и его детей
require_relative "#{__dir__}/lib/post.rb"
require_relative "#{__dir__}/lib/memo.rb"
require_relative "#{__dir__}/lib/link.rb"
require_relative "#{__dir__}/lib/task.rb"

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# Как обычно, при использовании классов программа выглядит очень лаконично
puts "Привет, я блокнот версия 2, записываю новые записи в базу SQLite :)"

# Теперь надо спросить у пользователя, что он хочет создать
puts "Что хотите записать в блокнот?"

# массив возможных видов Записи (поста)
choices = Post.post_types.keys
p choices[0]
choice = -1

until choice >= 0 && choice < choices.size # пока юзер не выбрал правильно
  # выводим заново массив возможных типов поста
  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end
  choice = gets.chomp.to_i
end

entry = Post.create(choices[choice])
entry.read_from_console
rowid = entry.save_to_db

puts "Запись сохранена в базе, id = #{rowid}"
