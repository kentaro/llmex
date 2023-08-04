defmodule Llmex.Messages.Test do
  use ExUnit.Case
  doctest Llmex

  test "new/0" do
    messages = Llmex.Messages.new()

    assert messages.messages == []
  end
end
