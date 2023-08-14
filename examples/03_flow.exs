alias Llmex.{Flow, Step}
alias Llmex.Llms.OpenAI

llm = OpenAI.new(
  model: "gpt-4-0613",
  api_key: System.get_env("OPENAI_API_KEY"),
  http_options: [recv_timeout: 180_000]
)

s1 = Step.new(
  type: :function,
  name: :movie_topic,
  function: fn _args ->
    ["friendship", "love", "war", "hate"]
    |> Enum.random()
  end
)

s2 = Step.new(
  type: :function_call,
  name: :movie_title,
  llm: llm,
  template: """
  Generate a great title of a movie about <%= @movie_topic %>?
  """
)

s3 = Step.new(
  type: :function_call,
  name: :song_title,
  llm: llm,
  template: """
  Generate a great song title of a soundtrack for a movie called <%= @movie_title %>?
  """
)

s4 = Step.new(
  type: :function_call,
  name: :main_characters,
  llm: llm,
  template: """
  Generate two names of the main characters of a movie called <%= @movie_title %>?

  Example:
  John and Mary
  """
)

s5 = Step.new(
  type: :generation,
  name: :lyrics,
  llm: llm,
  template: """
  Generate lyrics of a song called <%= @song_title %> for a movie tittled <%= @movie_title %>. The main characters are <%= @main_characters %>
  """
)

Flow.new()
|> Flow.connect(s1, s2)
|> Flow.connect(s2, s3)
|> Flow.connect(s2, s4)
|> Flow.connect(s2, s5)
|> Flow.connect(s3, s5)
|> Flow.connect(s4, s5)
|> Flow.run(s1, nil)
|> IO.inspect()
