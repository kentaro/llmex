defmodule Llmex.Llms.OpenAI do
  defstruct [:model, :config, :client]

  @default_model "gpt-4"
  @default_client OpenAI

  def new(config) do
    {model_config, client_config} =
      config
      |> Keyword.split([:model])

    struct(__MODULE__, %{
      model: model_config[:model] || @default_model,
      config: struct(OpenAI.Config, client_config),
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
    messages = args[:messages] || []
    client = llm.client || @default_client

    {status, response} =
      client.chat_completion(
        Keyword.merge(args, model: llm.model),
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
