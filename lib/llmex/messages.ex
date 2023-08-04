defmodule Llmex.Messages do
  defstruct [:messages]

  def new(messages \\ nil) do
    messages =
      cond do
        is_list(messages) ->
          messages
        is_nil(messages) ->
          []
        true ->
          [messages]
      end

    struct(__MODULE__, %{
      messages: messages
    })
  end

  def add(messages, message) do
    struct(__MODULE__, %{
      messages: messages.messages ++ [message]
    })
  end
end
