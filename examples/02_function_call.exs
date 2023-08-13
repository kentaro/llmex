alias Llmex.{Function, Message}
alias Llmex.Llms.OpenAI

llm =
  OpenAI.new(
    model: "gpt-4-0613",
    api_key: System.get_env("OPENAI_API_KEY")
  )

message =
  Message.new(
    role: "user",
    content: """
    What will the weather be like in Tokyo from today?
    """
  )

function_name = "get_weather"

function = Function.new(
  name: function_name,
  description: "Retrieves weather information for a given location",
  parameters: %{
    type: "object",
    properties: %{
      location: %{
        type: "string",
        description: "The location to retrieve weather information for"
      }
    }
  },
  required: [:location]
)

{_status, _response, messages} =
  llm
  |> OpenAI.generate(
    messages: [message],
    functions: [function],
    function_call: %{name: function_name}
  )

if Message.function_call?(messages) do
  location =
    messages
    |> get_in([Access.at(1), :function_call, :arguments, :location])

  weather_for = fn location ->
    "The weather for #{location} is sunny."
  end

  {_status, _response, messages} =
    llm
    |> OpenAI.generate(
      messages:
        messages ++
          [
            Message.new(
              role: :function,
              name: function_name,
              content: location |> weather_for.()
            )
          ]
    )

  messages |> IO.inspect()
end
