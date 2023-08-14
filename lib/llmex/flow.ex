defmodule Llmex.Flow do
  defstruct [:steps, :state]

  def new(opts \\ []) do
    {:ok, state} = Llmex.Flow.State.start_link(opts)

    struct(__MODULE__, opts)
    |> Map.put(:steps, [])
    |> Map.put(:state, state)
  end

  def connect(flow, prev, next) do
    flow.state
    |> Llmex.Flow.State.connect(prev, next)

    flow
    |> Map.put(
      :steps,
      flow.steps ++ [prev, next] |> Enum.uniq()
    )
  end

  def run(flow, root_step, args) do
    result = root_step |> Llmex.Step.run(args)
    flow.state
    |> Llmex.Flow.State.add_result(root_step, result)

    flow.steps
    |> Enum.filter(fn step ->
      step != root_step
    end)
    |> Enum.map(fn step ->
      Task.async(fn ->
        wait(fn ->
          flow.state
          |> Llmex.Flow.State.ready?(step)
        end)

        args =
          flow.state
          |> Llmex.Flow.State.get_results(step)

        result = step |> Llmex.Step.run(args)

        flow.state
        |> Llmex.Flow.State.add_result(step, result)

        result
      end)
    end)
    |> Task.await_many(180_000)
  end

  def wait(func) do
    unless func.() do
      :timer.sleep(10)
      wait(func)
    end
  end
end
