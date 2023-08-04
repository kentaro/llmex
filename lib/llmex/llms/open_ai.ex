defmodule Llmex.Llms.OpenAI do
  defstruct [:config]

  def new(args) do
    config = struct(OpenAI.Config, args)

    %__MODULE__{
      config: config
    }
  end

  def generate(llm, args) do
    messages = [messages: args[:messages].messages]

    OpenAI.chat_completion(
      args |> Keyword.merge(messages),
      llm.config
    )
  end
end
