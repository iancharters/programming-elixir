defmodule Link do
  import :timer, only: [ sleep: 1 ]

  def sad_function do
    sleep 500
    exit(:boom)
  end

  def run do
    res = spawn_monitor(Link, :sad_method, [])
    IO.puts inspect res

    receive do
      msg ->
        IO.puts "MESSAGE RECEIVED: #{IO.inspect(msg)}"
    after 1000 ->
        IO.puts "Nothing happened as far as I am concerned"
    end
  end
end
