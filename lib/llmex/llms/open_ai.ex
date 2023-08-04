defmodule Llmex.Llms.OpenAI do
  defstruct [:config]

  def new(args) do
    config = struct(OpenAI.Config, args)

    %__MODULE__{
      config: config
    }
  end

  def generate(llm, args) do
    cond do
      Keyword.has_key?(args, :prompt) ->
        generate_with_prompt(llm, args)
      Keyword.has_key?(args, :messages) ->
        generate_with_messages(llm, args)
      end
  end

  defp generate_with_prompt(llm, args) do
    OpenAI.completions(args, llm.config)
  end

  defp generate_with_messages(llm, args) do
    OpenAI.chat_completion(args, llm.config)
  end
end
