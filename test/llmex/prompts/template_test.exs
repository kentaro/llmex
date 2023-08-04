defmodule Llmex.Prompts.Template.Test do
  use ExUnit.Case
  doctest Llmex.Prompts.Template

  test "new/1" do
    template = Llmex.Prompts.Template.new("test")

    assert template.template == "test"
  end

  test "prompt/2" do
    prompt =
      Llmex.Prompts.Template.new("Hello, <%= @name %>!")
      |> Llmex.Prompts.Template.prompt(name: "Kentaro")

    assert prompt == "Hello, Kentaro!"
  end
end
