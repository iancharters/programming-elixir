defmodule StackTest do
  use ExUnit.Case, async: true
  doctest Stack

  #review with izaak why this doesn't work like I expect it to.
  # Fuckery is going on.  How does the tree actually look?

  test "App initializes correctly" do
    #Test initialization
    {stacktest, pid} = :sys.get_state Stack.Server
    {stash, stash_pid} = :sys.get_state Stack.Stash

    assert stacktest == [3,2,1]

    refute pid == nil
    refute stash_pid == nil

  end

  test "Pop works" do
    assert Stack.Server.pop == 3
  end

  test "Push works" do
    #:observer.start
    #:timer.sleep 50000 #Tree seems to look normal in "stack"
    assert Stack.Server.push("4") == :ok
  end
end
