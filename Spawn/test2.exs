defmodule Cat do

def find_word(stream, word) do
  list = Enum.into(stream, [])
  IO.inspect list
  find_word(list, word, 0)
end

def find_word([head|tail], word, acc) do
  count = String.downcase(head)
    |> String.split(word)
    |> Enum.count

    acc = acc + (count - 1)

  find_word(tail, word, acc)
end

def find_word(_list, _word, acc), do: acc

end

stream = File.open!("test2.exs", [:read, :utf8])
|> IO.stream(:line)

Cat.find_word(stream, "cat")
|> IO.inspect
