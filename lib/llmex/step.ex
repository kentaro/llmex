defmodule Llmex.Step do
  @keys [:type, :name, :action]
  defstruct @keys

  def new(opts) do
    {step_opts, _action_opts} =
      opts
      |> Keyword.split(@keys)

    struct(__MODULE__, step_opts)
    |> Map.put(
      :action,
      Llmex.Action.new(opts)
    )
  end

  def run(step, args) do
    step.action
    |> Llmex.Action.run(step.type, args)
  end
end
