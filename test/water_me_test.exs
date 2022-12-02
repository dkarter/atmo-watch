defmodule WaterMeTest do
  use ExUnit.Case
  doctest WaterMe

  test "greets the world" do
    assert WaterMe.hello() == :world
  end
end
