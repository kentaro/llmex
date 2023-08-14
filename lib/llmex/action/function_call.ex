defmodule Llmex.Action.FunctionCall do
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

    function =
      Llmex.Function.new(
        name: action.name,
        description: "Retrieve information from GPT. This function must be called.",
        parameters: %{
          type: "object",
          properties: %{
            action.name => %{
              type: "string",
              description: "The information retrieved from GPT."
            }
          }
        },
        required: [action.name]
      )

    {_status, _response, messages} =
      action.llm
      |> Llmex.Llms.OpenAI.generate(
        messages: [message],
        functions: [function],
        function_call: %{name: action.name}
      )

    messages
    |> get_in([Access.at(-1), :function_call, :arguments])
  end
end
