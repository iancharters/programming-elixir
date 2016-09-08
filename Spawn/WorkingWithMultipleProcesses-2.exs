# Code taken from user Nathan Feaver on Prag Forums.
# Just testing it to see how/why it works.

defmodule DeterministicTest do
  def run do
    generate(:fred)
    generate(:betty)
  end

  def test_process(client) do
    receive do
      token ->
        send(client, token)
    end
  end

  def generate(token) do
    p = spawn(DeterministicTest, :test_process, [self])
    send(p, token)
    receive do
      response -> IO.puts(inspect(response))
    end
  end
end
