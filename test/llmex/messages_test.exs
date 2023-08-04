defmodule Llmex.Messages.Test do
  use ExUnit.Case
  doctest Llmex.Messages

  test "new/1 with a message" do
    arg = %{
      role: "user",
      content: "How are you?"
    }

    messages = Llmex.Messages.new(arg)

    assert messages.messages == [arg]
  end

  test "new/1 with multiple messages" do
    args = [
      %{
        role: "system",
        content: "You are a helpful assistant."
      },
      %{
        role: "user",
        content: "How are you?"
      }
    ]

    messages = Llmex.Messages.new(args)

    assert messages.messages == args
  end

  test "new/1 with no messages" do
    messages = Llmex.Messages.new()

    assert messages.messages == []
  end

  test "add/2 with a message" do
    arg = %{
      role: "user",
      content: "How are you?"
    }

    messages =
      Llmex.Messages.new()
      |> Llmex.Messages.add(arg)

    assert messages.messages == [arg]
  end

  test "add/2 with multiple messages" do
    args = [
      %{
        role: "system",
        content: "You are a helpful assistant."
      },
      %{
        role: "user",
        content: "How are you?"
      }
    ]

    messages =
      Llmex.Messages.new()
      |> Llmex.Messages.add(args)

    assert messages.messages == args
  end

  test "add/2 with no messages" do
    messages =
      Llmex.Messages.new()
      |> Llmex.Messages.add(nil)

    assert messages.messages == []
  end
end
