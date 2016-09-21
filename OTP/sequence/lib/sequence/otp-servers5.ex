defmodule Sequence.Pop do
  use GenServer

  ####
  # External API

  def start_link(current_number) do
    GenServer.start_link(__MODULE__, current_number, name: __MODULE__)
  end

  def pop do
      GenServer.call(__MODULE__, :pop)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  ####
  # GenServer Implementation

  def handle_call(:pop, _from, [current_item | stack]) do
    if(stack == []) do
      current_item
      terminate("List empty", current_item)
    end

    {:reply, current_item, stack}
  end

  def handle_cast({ :push, item }, state) do
    { :noreply, [item | state] }
  end

  def terminate(reason, state) do
    IO.puts "Terminating because: #{reason}.  Server state: #{state}"
  end
end
