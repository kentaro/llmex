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
    messages = args[:messages]
    client = llm.client || @default_client

    {status, response} =
      client.chat_completion(
        args,
        llm.config
      )

    response_messages =
      case status do
        :ok ->
          response.choices
          |> Enum.map(fn choice ->
            message = choice |> Map.get("message")
            Llmex.Message.new(message)
          end)

        :error ->
          []
      end

    {status, response, messages ++ response_messages}
  end
end
