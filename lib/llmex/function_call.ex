defmodule Llmex.FunctionCall do
  @keys [:name, :arguments]
  defstruct @keys

  def new(args) do
    %__MODULE__{
      name: args["name"],
      arguments:
        Jason.decode!(
          args["arguments"],
          keys: :atoms
        )
    }
  end

  def keys() do
    @keys
  end

  # To compliant with Access behaviour
  def fetch(struct, key), do: Map.fetch(struct, key)

  defimpl Jason.Encoder, for: Llmex.FunctionCall do
    def encode(value, opts) do
      not_nil =
        value
        |> Map.take(Llmex.FunctionCall.keys())
        |> Map.filter(fn {_, v} -> v != nil end)
        # `arguments` must be encoded to JSON value
        |> Map.update!(:arguments, &Jason.encode!/1)

      Jason.Encode.map(not_nil, opts)
    end
  end
end
