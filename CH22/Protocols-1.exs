defprotocol Caesar do
  def encrypt(string, shift)

  def rot13(string)
end

defimpl Caesar, for: [BitString, List] do

  @alphabet_length 26

  #Protocol Implementation
  def encrypt(input, shift) do
    input
    |> String.to_charlist
    |> Enum.map(fn c -> shifteroo(c, shift) end)
    |> List.to_string
    |> IO.puts
  end

  def rot13(input) do
    encrypt(input, 13)
  end

  # Helper functions
  def shifteroo(char, shift) do
    cond do
      is_lowercase(char) ->
        rem(char + (shift-1) - ?a, @alphabet_length) + ?a
      is_uppercase(char) ->
        rem(char + (shift-1) - ?A, @alphabet_length) + ?A
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

Caesar.rot13("this will go")
