defmodule Llmex.Message do
  @keys [:role, :content, :name, :function_call]
  defstruct @keys

  def new(args) when is_map(args) do
    keywordlist =
      args
      |> Enum.into([], fn {k, v} ->
        case is_atom(k) do
          true ->
            {k, v}

          false ->
            {String.to_existing_atom(k), v}
        end
      end)

    new(keywordlist)
  end

  def new(args) do
    message = struct(__MODULE__, args)

    case message.function_call do
      nil ->
        message

      _ ->
        message
        |> Map.put(:function_call, Llmex.FunctionCall.new(message.function_call))
    end
  end

  def keys() do
    @keys
  end

  defimpl Jason.Encoder, for: Llmex.Message do
    def encode(value, opts) do
      not_nil =
        value
        |> Map.take(Llmex.Message.keys())
        |> Map.filter(fn {_, v} -> v != nil end)

      Jason.Encode.map(not_nil, opts)
    end
  end
end
