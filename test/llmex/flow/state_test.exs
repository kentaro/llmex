defmodule Llmex.Flow.State.Test do
  use ExUnit.Case
  doctest Llmex.Step

  test "connect/3" do
    {:ok, pid} = Llmex.Flow.State.start_link(name: :connect_3)

    pid |> Llmex.Flow.State.connect(:s1, :s2)
    state = pid |> Llmex.Flow.State.state()

    assert state == %{
             steps: %{
               s1: %{next: [:s2]},
               s2: %{prev: [:s1]}
             },
             results: %{}
           }

    pid |> Llmex.Flow.State.connect(:s1, :s3)
    pid |> Llmex.Flow.State.connect(:s2, :s3)
    state = pid |> Llmex.Flow.State.state()

    assert state == %{
             steps: %{
               s1: %{next: [:s2, :s3]},
               s2: %{prev: [:s1], next: [:s3]},
               s3: %{prev: [:s1, :s2]}
             },
             results: %{}
           }
  end

  test "add_result/3" do
    {:ok, pid} = Llmex.Flow.State.start_link(name: :add_result_3)

    pid |> Llmex.Flow.State.add_result(:s1, %{answer: 42})
    state = pid |> Llmex.Flow.State.state()

    assert state == %{
             steps: %{},
             results: %{
               s1: %{answer: 42}
             }
           }
  end

  test "ready?/2" do
    {:ok, pid} = Llmex.Flow.State.start_link(name: :ready_2)

    pid |> Llmex.Flow.State.connect(:s1, :s3)
    pid |> Llmex.Flow.State.connect(:s2, :s3)
    status = pid |> Llmex.Flow.State.ready?(:s3)

    refute status

    pid |> Llmex.Flow.State.add_result(:s1, %{answer: 42})
    status = pid |> Llmex.Flow.State.ready?(:s3)

    refute status

    pid |> Llmex.Flow.State.add_result(:s2, %{answer: 42})
    status = pid |> Llmex.Flow.State.ready?(:s3)

    assert status
  end
end
