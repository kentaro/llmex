defmodule LlmexTest do
  use ExUnit.Case
  doctest Llmex

  test "greets the world" do
    assert Llmex.hello() == :world
  end
end
