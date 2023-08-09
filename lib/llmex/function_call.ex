defmodule Llmex.FunctionCall do
  @keys [:name, :arguments]
  defstruct @keys

  def new(args) do
    %__MODULE__{
      name: args["name"],
      arguments: Jason.decode!(args["arguments"])
    }
  end

  def keys() do
    @keys
  end

  defimpl Jason.Encoder, for: Llmex.FunctionCall do
    def encode(value, opts) do
      not_nil =
        value
        |> Map.take(Llmex.FunctionCall.keys())
        |> Map.filter(fn {_, v} -> v != nil end)

      Jason.Encode.map(not_nil, opts)
    end
  end
end
