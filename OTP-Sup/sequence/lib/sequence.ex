defmodule Sequence do
  use Application

  #@starting_state 125

  def start(_type, _args) do
    {:ok, _pid} = Sequence.Supervisor.start_link(123)
  end
end
