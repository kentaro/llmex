defmodule Llmex.Functions do
  defstruct [:functions]

  def new(function \\ nil) do
    struct(__MODULE__, %{
      functions: handle_args(function)
    })
  end

  def add(functions, function) do
    struct(__MODULE__, %{
      functions: functions.functions ++ handle_args(function)
    })
  end

  defp handle_args(function) do
    cond do
      is_list(function) ->
        function

      is_nil(function) ->
        []

      true ->
        [function]
    end
  end
end
