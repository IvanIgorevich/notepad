class Link < Post

  def initialize
    super

    @url = ""
  end

  def read_from_console
    puts "Введите адрес ссылки"
    @url = STDIN.gets.chomp

    puts "Напишите пару слов о том, куда ведёт ссылка"
    @text = STDIN.gets.chomp
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n"

    [@url, @text, time_string]
  end

  def save

    file = File.new(file_path, "w:UTF-8")
    time_string = @created_at.strftime("%Y.%m.%d, %H:%M")
    file.puts(time_string + "\n\r")

    file.puts(@url)
    file.puts(@text)

    file.close

    puts "Ваша ссылка сохранена"
  end

  def to_db_hash
    return super.merge(
      {
        'text' => @text,
        'url' => @url
      }
    )
  end

  def load_data(data_hash)
    super

    @url = data_hash['url']
  end
end
