defmodule Llmex.Llms.OpenAI do
  defstruct [:config, :client]

  @default_client OpenAI

  def new(config) do
    struct(__MODULE__, %{
      config: struct(OpenAI.Config, config),
      client: nil
    })
  end

  def client(llm, client) do
    struct(__MODULE__, %{
      config: llm.config,
      client: client
    })
  end

  def generate(llm, args) do
    messages = [messages: args[:messages].messages]
    client = llm.client || @default_client

    client.chat_completion(
      args |> Keyword.merge(messages),
      llm.config
    )
  end
end
