defmodule Llmex.Llms.OpenAI.Test do
  use ExUnit.Case
  doctest Llmex.Llms.OpenAI

  @message [
    role: "user",
    content: "Hello, how are you?"
  ]
  @function [
    name: "test",
    description: "test function"
  ]

  test "new/1" do
    llm = Llmex.Llms.OpenAI.new(api_key: "api key")

    assert llm.config == %OpenAI.Config{
             api_key: "api key"
           }
  end

  test "generate/2 returns an ok response" do
    message = Llmex.Message.new(@message)

    response =
      Llmex.Llms.OpenAI.new(api_key: "api key")
      |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient)
      |> Llmex.Llms.OpenAI.generate(messages: [message])

    response_message =
      Llmex.Llms.OpenAI.TestClient.ok_response()
      |> get_in([:choices, Access.at(0), "message"])
      |> Llmex.Message.new()

    response_messages = [message, response_message]

    assert response == {
             :ok,
             Llmex.Llms.OpenAI.TestClient.ok_response(),
             response_messages
           }
  end

  test "generate/2 returns an error response" do
    message = Llmex.Message.new(@message)

    response =
      Llmex.Llms.OpenAI.new(api_key: "api key")
      |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient)
      |> Llmex.Llms.OpenAI.generate(
        messages: [message],
        error: true
      )

    assert response == {
             :error,
             Llmex.Llms.OpenAI.TestClient.error_response(),
             [message]
           }
  end

  test "generate/2 returns an ok response with function call" do
    message = Llmex.Message.new(@message)
    function = Llmex.Function.new(@function)

    response =
      Llmex.Llms.OpenAI.new(api_key: "api key")
      |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient)
      |> Llmex.Llms.OpenAI.generate(
        messages: [message],
        functions: [function],
        function_call: true
      )

    response_message =
      Llmex.Llms.OpenAI.TestClient.ok_response_with_function_call()
      |> get_in([:choices, Access.at(0), "message"])
      |> Llmex.Message.new()

    response_messages = [message, response_message]

    assert response == {
             :ok,
             Llmex.Llms.OpenAI.TestClient.ok_response_with_function_call(),
             response_messages
           }
  end
end
