defmodule Llmex.FunctionCall.Test do
  use ExUnit.Case
  doctest Llmex.FunctionCall

  test "new/1" do
    arg = %{
      "name" => "test",
      "arguments" => "{\n  \"region\": \"Tokyo\"\n}"
    }

    function = Llmex.FunctionCall.new(arg)

    assert function.name == arg["name"]

    assert function.arguments ==
             Jason.decode!(
               arg["arguments"],
               keys: :atoms
             )
  end
end
