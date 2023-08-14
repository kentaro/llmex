defmodule Llmex.Action.Function do
  defstruct [:name, :function]

  @behaviour Llmex.Action

  def new(opts) do
    struct(__MODULE__, opts)
  end

  def run(action, args) do
    result = action.function.(args)
    %{action.name => result}
  end
end
