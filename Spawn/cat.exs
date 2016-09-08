#Unfinished, will come back to.

defmodule Cat do
  import String

  def file_list() do
    File.ls!()
    |> List.first
    |> traverse_file("cat")
  end

  def traverse_file(file, word) do
    stream = File.open!(file, [:read, :utf8])
      |> IO.stream(:line)

      Cat.find_word(stream, word)
      |> IO.inspect
  end


  def find_word(stream, word) do
    list = Enum.into(stream, [])
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

  def fib(scheduler) do
    send scheduler, {:ready, self}

    receive do
      {:fib, n, client} ->
        send client, {:answer, n, fib_calc(n), self}
        fib(scheduler)
      {:shutdown} ->
        exit(:normal)
    end
  end

  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n-1) + fib_calc(n-2)

end

defmodule Scheduler do

  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {:fib, next, self}
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
      if length(processes) > 1 do
        schedule_processes(List.delete(processes, pid), queue, results)
      else
        Enum.sort(results, fn {n1,_}, {n2,_} -> n1 <= n2 end)
      end

      {:answer, number, result, _pid} ->
      schedule_processes(processes, queue, [ {number, result} | results ])
    end
  end
end

#to_process = [ 37, 37, 37, 37, 37, 37 ]

#Cat.file_list()
File.ls!
|> Enum.each(fn file_name ->
  test = String.contains?(file_name, "beam")

  case String.contains?(file_name, "beam") do
    false ->
      Cat.traverse_file(file_name, "cat")
    true ->
      IO.puts "Skipping beam file: #{file_name}"
  end
end)

#Enum.each 1..10, fn num_processes ->
  #{time, result} = :timer.tc(Scheduler, :run,
  #  [num_processes, Cat, :fib, to_process])

#if num_processes == 1 do
#  IO.puts inspect result
  #IO.puts "\n # time (s)"
#end

#:io.format "~2B ~.2f~n", [num_processes, time/1000000.0]
#end
