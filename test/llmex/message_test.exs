defmodule Llmex.Message.Test do
  use ExUnit.Case
  doctest Llmex.Message

  test "new/1 with a Keyword list" do
    arg = [
      role: "user",
      content: "How are you?"
    ]

    message = Llmex.Message.new(arg)

    assert message.role == arg[:role]
    assert message.content == arg[:content]
    assert message.function_call == nil
  end

  test "new/1 with a Map" do
    arg = %{
      role: "user",
      content: "How are you?"
    }

    message = Llmex.Message.new(arg)

    assert message.role == arg.role
    assert message.content == arg.content
    assert message.function_call == nil
  end
end
