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
    messages = args[:messages].messages
    client = llm.client || @default_client

    {status, response} =
      client.chat_completion(
        args |> Keyword.merge(messages: messages),
        llm.config
      )

    response_messages =
      case status do
        :ok ->
          response_messages =
            response.choices
            |> Enum.map(fn choice ->
              choice |> Map.get("message")
            end)

          Llmex.Messages.new(messages ++ response_messages)

        :error ->
          messages
      end

    {status, response, response_messages}
  end
end
