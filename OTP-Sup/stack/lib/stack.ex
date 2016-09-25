defmodule Stack do
  use Application

  # Sets initial value to be passed into the Stack.Server module.
  @stack [1,2,3,4]

  def start(_type, _args) do
    {:ok, _pid} = Stack.Supervisor.start_link(@stack)
  end

end
