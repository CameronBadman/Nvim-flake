defmodule TestLspTest do
  use ExUnit.Case
  doctest TestLsp

  test "greets the world" do
    assert TestLsp.hello() == :world
  end
end
