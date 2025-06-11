# test.ex - Simple Elixir LSP test file

defmodule Test do
  # Type 'IO.' here and see if you get completions
  def hello do
    IO.puts("Hello World")
  end

  # Type 'Enum.' here and see if you get completions  
  def test_enum do
    [1, 2, 3] |> Enum.map(&(&1 * 2))
  end

  # Hover over 'String' to see if LSP shows documentation
  def test_string do
    String.upcase("test")
  end
end
