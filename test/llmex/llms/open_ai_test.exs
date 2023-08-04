defmodule Llmex.Llms.OpenAI.Test do
  use ExUnit.Case
  doctest Llmex.Llms.OpenAI

  test "new/1" do
    llm = Llmex.Llms.OpenAI.new(api_key: "api key")

    assert llm.config == %OpenAI.Config{
      api_key: "api key"
    }
  end

  test "generate/2" do
    response =
      Llmex.Llms.OpenAI.new(api_key: "api key")
      |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient)
      |> Llmex.Llms.OpenAI.generate(
        messages: Llmex.Messages.new(%{role: "user", content: "Hello, how are you?"})
      )

    assert response == Llmex.Llms.OpenAI.TestClient.ok_response()
  end
end
