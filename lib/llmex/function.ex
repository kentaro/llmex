defmodule Llmex.Function do
  @keys [:name, :description, :parameters, :required]
  defstruct @keys

  def new(args) do
    struct(__MODULE__, args)
  end

  def keys() do
    @keys
  end

  defimpl Jason.Encoder, for: Llmex.Function do
    def encode(value, opts) do
      not_nil =
        value
        |> Map.take(Llmex.Function.keys())
        |> Map.filter(fn {_, v} -> v != nil end)

      Jason.Encode.map(not_nil, opts)
    end
  end
end
