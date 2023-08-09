defmodule Llmex.Prompts.Template do
  defstruct [:template]

  def new(template) do
    struct(__MODULE__, %{
      template: template
    })
  end

  def prompt(template, args \\ []) do
    template.template
    |> EEx.eval_string(assigns: args)
  end
end
