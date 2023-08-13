alias Llmex.Message
alias Llmex.Llms.OpenAI
alias Llmex.Prompts.Template

llm =
  OpenAI.new(
    model: "gpt-4",
    api_key: System.get_env("OPENAI_API_KEY")
  )

title_template =
  Template.new("""
  What is a good title of a movie about <%= @topic %>?
  """)

message =
  Message.new(
    role: "user",
    content: title_template |> Template.prompt(topic: "friendship")
  )

{_status, _response, messages} =
  llm
  |> OpenAI.generate(messages: [message])

messages |> IO.inspect()
