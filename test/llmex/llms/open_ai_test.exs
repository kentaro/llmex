defmodule Llmex.Llms.OpenAI.Test do
  use ExUnit.Case
  doctest Llmex.Llms.OpenAI

  test "new/1" do
    llm = Llmex.Llms.OpenAI.new(api_key: "api key")

    assert llm.config == %OpenAI.Config{
             api_key: "api key"
           }
  end

  test "generate/2 with an ok response" do
    message = %{role: "user", content: "Hello, how are you?"}
    messages = Llmex.Messages.new(message)

    response =
      Llmex.Llms.OpenAI.new(api_key: "api key")
      |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient)
      |> Llmex.Llms.OpenAI.generate(messages: messages)

    response_message =
      Llmex.Llms.OpenAI.TestClient.ok_response()
      |> get_in([:choices, Access.at(0), "message"])

    response_messages = Llmex.Messages.new([message, response_message])

    assert response == {
             :ok,
             Llmex.Llms.OpenAI.TestClient.ok_response(),
             response_messages
           }
  end

  test "generate/2 with an error response" do
    message = %{role: "user", content: "Hello, how are you?"}
    messages = Llmex.Messages.new(message)

    response =
      Llmex.Llms.OpenAI.new(api_key: "api key")
      |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient)
      |> Llmex.Llms.OpenAI.generate(
        messages: messages,
        error: true
      )

    assert response == {
             :error,
             Llmex.Llms.OpenAI.TestClient.error_response(),
             messages
           }
  end
end
