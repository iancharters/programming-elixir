defmodule Stack.Server do
  use GenServer

  @vsn "0"

  ####
  # External API

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack, name: __MODULE__)
  end

  def pop do
      GenServer.call(__MODULE__, :pop)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def blowup_server do
    GenServer.call(__MODULE__, :thiswillgo)
  end

  ####
  # GenServer Implementation

  def init(stash_pid) do
    stack = Stack.Stash.get_value(stash_pid)
    { :ok, {stack, stash_pid} }
  end

  def handle_call(:pop, _from, {[current_item | stack], stash_pid}) do
    IO.inspect(stack)
    if(stack == []) do
      #current_item
      terminate("List empty", {current_item, stash_pid})
    end

    {:reply, current_item, {stack, stash_pid}}
  end

  def handle_call(:thiswillgo, _from, {stack, stash_pid}) do
    { :reply, __MODULE__, {stack + 1, stash_pid+1}}
  end

  def handle_cast({ :push, item }, stack) do
    { :noreply, [item | stack] }
  end

  def terminate(_reason, {current_stack, stash_pid}) do
      Stack.Stash.save_value stash_pid, current_stack

      #[data: [{'State', "My current state is '#{inspect current_stack}',
      #and reason for termination is: #{reason}"}]]
  end
end
