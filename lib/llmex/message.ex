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

  def function_call?(messages) do
    messages
    |> Enum.take(-1)
    |> Enum.any?(fn message ->
      message.function_call != nil
    end)
  end

  # To compliant with Access behaviour
  def fetch(struct, key), do: Map.fetch(struct, key)

  defimpl Jason.Encoder, for: Llmex.Message do
    def encode(value, opts) do
      not_nil =
        value
        |> Map.take(Llmex.Message.keys())
        |> Map.filter(fn {k, v} ->
          # `function_call` and `name` must be excluded if the related values are nil
          k not in [:function_call, :name] ||
            v != nil
        end)

      Jason.Encode.map(not_nil, opts)
    end
  end
end
