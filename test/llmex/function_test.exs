defmodule Llmex.Function.Test do
  use ExUnit.Case
  doctest Llmex.Function

  test "new/1 with a Keyword list" do
    arg = [
      name: "test",
      description: "test function"
    ]

    function = Llmex.Function.new(arg)

    assert function.name == arg[:name]
    assert function.description == arg[:description]
    assert function.parameters == nil
    assert function.required == nil
  end

  test "new/1 with a Map" do
    arg = %{
      name: "test",
      description: "test function"
    }

    function = Llmex.Function.new(arg)

    assert function.name == arg.name
    assert function.description == arg.description
    assert function.parameters == nil
    assert function.required == nil
  end
end
