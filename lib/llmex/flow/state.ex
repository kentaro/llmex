defmodule Llmex.Flow.State do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      %{
        steps: %{},
        results: %{}
      },
      name: opts[:name] || __MODULE__
    )
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:connect, prev, next}, state) do
    new_state =
      state
      |> add_to(:next, prev, next)
      |> add_to(:prev, next, prev)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:add_result, step, result}, state) do
    new_state =
      state
      |> put_in([:results, step], result)

    {:noreply, new_state}
  end

  @impl true
  def handle_call({:ready?, step}, _from, state) do
    result =
      state.steps[step].prev
      |> Enum.all?(fn prev_step ->
        (state.results |> Map.get(prev_step)) != nil
      end)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:next_steps, step}, _from, state) do
    next_steps = state.steps[step].next
    {:reply, next_steps, state}
  end

  @impl true
  def handle_call({:get_results, step}, _from, state) do
    results =
      state.steps[step].prev
      |> Enum.map(fn prev_step ->
        state.results[prev_step]
      end)
      |> Enum.reduce(%{}, fn result, acc ->
        Map.merge(acc, result)
      end)

    {:reply, results, state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def connect(self, prev, next) do
    GenServer.cast(self, {:connect, prev, next})
  end

  def next_steps(self, step) do
    GenServer.call(self, {:next_steps, step})
  end

  def add_result(self, step, result) do
    GenServer.cast(self, {:add_result, step, result})
  end

  def get_results(self, step) do
    GenServer.call(self, {:get_results, step})
  end

  def ready?(self, step) do
    GenServer.call(self, {:ready?, step})
  end

  def state(self) do
    GenServer.call(self, :state)
  end

  defp add_to(state, to, s1, s2) do
    update_in(
      state.steps[s1],
      fn map ->
        (map || %{})
        |> Map.update(
          to,
          [s2],
          fn container ->
            container ++ [s2]
          end
        )
      end
    )
  end
end
