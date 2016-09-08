defmodule Spawn1 do
  def greet do
    receive do
      {sender, msg} ->
        send sender, { :ok, "Hello, #{msg}" }
        greet
    end
  end
end

pid = spawn(Spawn1, :greet, [])
send pid, {self, "World!"}

receive do
  {:ok, message} ->
    IO.puts message
end

pid = spawn(Spawn1, :greet, [])
send pid, {self, "Yo dawg!"}

receive do
  {:ok, message} ->
    IO.puts message
end

pid = spawn(Spawn1, :greet, [])
send pid, {self, "hay!"}

receive do
  {:ok, message} ->
    IO.puts message
end
