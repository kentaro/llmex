defmodule Llmex.Action.Generation do
  defstruct [:name, :llm, :template]

  @behaviour Llmex.Action

  def new(opts) do
    struct(__MODULE__, opts)
  end

  def run(action, args) do
    content =
      action.template
      |> Llmex.Prompts.Template.prompt(args)

    message =
      Llmex.Message.new(
        role: :user,
        content: content
      )

    {_status, _response, messages} =
      action.llm
      |> Llmex.Llms.OpenAI.generate(messages: [message])

    result =
      messages
      |> get_in([Access.at(-1), :content])

    %{action.name => result}
  end
end
