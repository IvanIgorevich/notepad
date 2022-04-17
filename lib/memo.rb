class Memo < Post

  def read_from_console
    puts "Я сохраню всё, что ты напишешь до строчки \"end\" в файл."

    # Объявим переменную, которая будет содержать текущую введенную строку
    line = nil

    # Запустим цикл, пока не дошли до строчки "end",
    while line != "end" do
      # Читаем очередную строку и записываем в массив @text
      line = STDIN.gets.chomp
      @text << line
    end

    # Теперь удалим последний элемент из массива @text – там служебное слово "end"
    @text.pop
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')}\n"

    @text.unshift(time_string)
  end

  def save
   file = File.new(file_path, "w:UTF-8")

    time_string = @created_at.strftime("%Y.%m.%d, %H:%M")
    file.puts(time_string + "\n\r")

    for item in @text do
      file.puts(item)
    end

    file.close

    puts "Ваша запись сохранена"
  end

  def to_db_hash
    super.merge(
      {
        'text' => @text.join('\n\r')
      }
    )
  end

  def load_data(data_hash)
    super(data_hash)

    @text = data_hash['text'].split('\n\r')
  end
end
