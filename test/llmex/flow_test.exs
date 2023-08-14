defmodule Llmex.Flow.Test do
  use ExUnit.Case
  doctest Llmex.Flow

  test "new/1" do
    flow = Llmex.Flow.new()

    assert flow.steps == %{}
    assert is_pid(flow.state)
  end
end
