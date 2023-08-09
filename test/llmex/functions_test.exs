defmodule Llmex.Functions.Test do
  use ExUnit.Case
  doctest Llmex.Functions

  @function %{
    name: "test_func",
    description: "A function for test.",
    parameters: %{
      type: "object",
      properties: %{
        arg: %{
          type: "string",
          description: "An argument for this function."
        }
      }
    },
    required: ["arg"]
  }

  test "new/1 with a function" do
    functions = Llmex.Functions.new(@function)

    assert functions.functions == [@function]
  end

  test "new/1 with multiple functions" do
    functions = Llmex.Functions.new([@function])

    assert functions.functions == [@function]
  end

  test "new/1 with no functions" do
    functions = Llmex.Functions.new()

    assert functions.functions == []
  end

  test "add/2 with a function" do
    functions =
      Llmex.Functions.new()
      |> Llmex.Functions.add(@function)

    assert functions.functions == [@function]
  end

  test "add/2 with multiple functions" do
    functions =
      Llmex.Functions.new()
      |> Llmex.Functions.add([@function])

    assert functions.functions == [@function]
  end

  test "add/2 with no functions" do
    functions =
      Llmex.Functions.new()
      |> Llmex.Functions.add(nil)

    assert functions.functions == []
  end
end
