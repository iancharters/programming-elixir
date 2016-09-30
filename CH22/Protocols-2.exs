defprotocol Caesar do
  def encrypt(string, shift)

  def rot13(string)

  def parse_file(path, word)
end

defimpl Caesar, for: [BitString, List] do

  @alphabet_length 26

  #Apply cipher to word
  def encrypt(input, shift) do
    input
    |> String.to_charlist
    |> Enum.map(fn c -> shifteroo(c, shift) end)
    |> List.to_string
  end

  def rot13(input) do
    encrypt(input, 13)
  end

  # Get directory listing, then feed each line from each file
  # into parse_line

  def parse_file(file, path, word) do
    File.stream!(path <> "/" <> file, [:read])
    |> Enum.each(&(parse_line(&1, word, file)))
  end

  def parse_file(word, path) do
    File.ls!(path)
    |> Enum.each(&(parse_file(&1, path, word)))
  end

  # Split words apart, check for match

  def parse_line(line, word, file) do
    line
    |> String.split(~r/\n/)
    |> Enum.each(fn x ->
      if x == word do
        IO.puts "Found word: #{word} in file: #{file}"
      end
    end)
  end

  # Helper functions
  def shifteroo(char, shift) do
    cond do
      is_lowercase(char) ->
        rem(char + shift - ?a, @alphabet_length) + ?a
      is_uppercase(char) ->
        rem(char + shift - ?A, @alphabet_length) + ?A
      true               -> char
    end
  end

  def is_uppercase(char) do
    char >= ?A && char <= ?Z
  end

  def is_lowercase(char) do
    char >= ?a && char <= ?z
  end
end

Caesar.rot13("yrnearq")
|> Caesar.parse_file("./dict/final")
