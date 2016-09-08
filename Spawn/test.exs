defmodule Cat do

def findword2(stream, word) do
  list = Enum.into(stream, [])
  IO.inspect list
  findword2(list, word, 0)
end

def findword2([head|tail], word, acc) do
  str = String.downcase(head)
    |> String.contains?(word)

  if str do
    acc = acc + 1
  end

  findword2(tail, word, acc)
end

def findword2(_list, _word, acc), do: acc

end

stream = File.open!("cat-finder.exs", [:read, :utf8])
|> IO.stream(:line)

Cat.findword2(stream, "cat")
|> IO.inspect
