defmodule JwtElixirTest do
  use ExUnit.Case
  doctest JwtElixir

  test "greets the world" do
    assert JwtElixir.hello() == :world
  end
end
