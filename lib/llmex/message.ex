defmodule Llmex.Message do
  defstruct [:role, :content, :function_call]

  def new(args) do
    struct(__MODULE__, args)
  end
end
