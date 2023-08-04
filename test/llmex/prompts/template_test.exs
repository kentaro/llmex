defmodule Llmex.Prompts.Template.Test do
  use ExUnit.Case
  doctest Llmex

  test "new/1" do
    template = Llmex.Prompts.Template.new(template: "test")

    assert template.template == "test"
  end

  test "prompt/2" do
    template = Llmex.Prompts.Template.new(template: "Hello, <%= @name %>!")
    prompt = template |> Llmex.Prompts.Template.prompt(name: "Kentaro")

    assert prompt == "Hello, Kentaro!"
  end
end
