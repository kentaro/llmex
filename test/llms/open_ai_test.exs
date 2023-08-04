defmodule Llmex.Llms.OpenAI.Test do
  use ExUnit.Case
  doctest Llmex

  test "new/1" do
    llm = Llmex.Llms.OpenAI.new(api_key: "api key")

    assert llm.config == %OpenAI.Config{
      api_key: "api key"
    }
  end
end
