defmodule Llmex.Messages do
  defstruct [:messages]

  def new() do
    %__MODULE__{
      messages: []
    }
  end

  def add(messages, message) do
    %__MODULE__{
      messages: messages.messages ++ [message]
    }
  end
end
