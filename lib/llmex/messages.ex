defmodule Llmex.Messages do
  defstruct [:messages]

  def new(message \\ nil) do
    struct(__MODULE__, %{
      messages: handle_message(message)
    })
  end

  def add(messages, message) do
    struct(__MODULE__, %{
      messages: messages.messages ++ handle_message(message)
    })
  end

  defp handle_message(message) do
    cond do
      is_list(message) ->
        message

      is_nil(message) ->
        []

      true ->
        [message]
    end
  end
end
