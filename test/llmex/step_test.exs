defmodule Llmex.Step.Test do
  use ExUnit.Case
  doctest Llmex.Step

  test "new/1 with function type" do
    step = Llmex.Step.new(
      type: :function,
      name: :function_step,
      function: fn _args -> end
    )

    assert step.action.__struct__ == Llmex.Action.Function
  end

  test "new/1 with function_call type" do
    step = Llmex.Step.new(
      type: :function_call,
      name: :function_step,
      llm: Llmex.Llms.OpenAI.new([]) |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient),
      template: "Hello, how are you?"
    )

    assert step.action.__struct__ == Llmex.Action.FunctionCall
  end

  test "new/1 with generation type" do
    step = Llmex.Step.new(
      type: :generation,
      name: :generation_step,
      llm: Llmex.Llms.OpenAI.new([]) |> Llmex.Llms.OpenAI.client(Llmex.Llms.OpenAI.TestClient),
      template: "Hello, how are you?"
    )

    assert step.action.__struct__ == Llmex.Action.Generation
  end
end
