defmodule Llmex.Prompts.Template do
  defstruct [:template, :prompt]

  def new(args) do
    args |> Keyword.validate!([:template])

    struct(__MODULE__, %{
      template: args[:template],
      prompt: ""
    })
  end

  def prompt(template, args \\ []) do
    template.template
    |> EEx.eval_string(assigns: args)
  end
end
