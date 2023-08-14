defmodule Llmex.Action do
  @callback new(Keyword.t()) :: term
  @callback run(term, Keyword.t()) :: term

  def new(opts) do
    opts =
      opts
      |> Keyword.put(:template, Llmex.Prompts.Template.new(opts[:template]))

    case opts[:type] do
      :function ->
        Llmex.Action.Function.new(opts)

      :function_call ->
        Llmex.Action.FunctionCall.new(opts)

      :generation ->
        Llmex.Action.Generation.new(opts)

      _ ->
        raise "Unknown action type: #{opts[:type]}"
    end
  end

  def run(action, type, args) do
    case type do
      :function ->
        action
        |> Llmex.Action.Function.run(args)

      :function_call ->
        action
        |> Llmex.Action.FunctionCall.run(args)

      :generation ->
        action
        |> Llmex.Action.Generation.run(args)

      _ ->
        raise "Unknown action type: #{type}"
    end
  end
end
