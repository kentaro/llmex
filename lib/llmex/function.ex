defmodule Llmex.Function do
  defstruct [:name, :description, :parameters, :required]

  def new(args) do
    struct(__MODULE__, args)
  end
end
