defmodule Sequence.Server do
  use GenServer

  ####
  # External API

  def start_link(current_number) do
    GenServer.start_link(__MODULE__, current_number, name: __MODULE__)
  end

  def next_number do
    GenServer.call(__MODULE__, :next_number)
  end

  def increment_number(delta) do
    GenServer.cast(__MODULE__, {:increment_number, delta})
  end

  ###
  # GenServer Implementation
  def init(stash_pid) do
    initial_stack = Stack.Stash.get_value(stash_pid)
    { :ok, {initial_stack, stash_pid} }
  end

  def handle_call(:next_number, _from, {current_number, stash_pid}) do
    { :reply, current_number, {current_number+1, stash_pid}}
  end

  def handle_cast({:increment_number, delta}, {stack, stash_pid}) do
    { :noreply, {stack ++ delta, stash_pid} }
  end

  def terminate(_reason, {stack, stash_pid}) do
      Stack.Stash.save_value stash_pid, stack
  end

end
