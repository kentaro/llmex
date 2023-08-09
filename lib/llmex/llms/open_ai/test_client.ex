defmodule Llmex.Llms.OpenAI.TestClient do
  @ok_response %{
    id: "chatcmpl-7jovC95ZNUUQ7kBUiH5mbDRDz3gs2",
    usage: %{
      "completion_tokens" => 27,
      "prompt_tokens" => 13,
      "total_tokens" => 40
    },
    model: "gpt-4-0613",
    object: "chat.completion",
    choices: [
      %{
        "finish_reason" => "stop",
        "index" => 0,
        "message" => %{
          "content" =>
            "As an artificial intelligence, I don't have feelings but I'm here and ready to assist you. How can I help you today?",
          "role" => "assistant"
        }
      }
    ],
    created: 1_691_154_858
  }

  @error_response %{
    "error" => %{
      "code" => "invalid_api_key",
      "message" =>
        "Incorrect API key provided: WRONG_API_KEY. You can find your API key at https://platform.openai.com/account/api-keys.",
      "param" => nil,
      "type" => "invalid_request_error"
    }
  }

  @ok_response_with_function_call %{
    choices: [
      %{
        "finish_reason" => "function_call",
        "index" => 0,
        "message" => %{
          "content" => nil,
          "function_call" => %{
            "arguments" => "{\n  \"region\": \"東京\"\n}",
            "name" => "get_weather"
          },
          "role" => "assistant"
        }
      }
    ],
    created: 1_687_190_705,
    id: "chatcmpl-7TBfFEi1L3yUq8xOam1lnx4SbapqK",
    model: "gpt-3.5-turbo-0613",
    object: "chat.completion",
    usage: %{"completion_tokens" => 17, "prompt_tokens" => 77, "total_tokens" => 94}
  }

  def chat_completion(args, _config) do
    case args[:error] do
      true ->
        {:error, @error_response}

      _ ->
        case args[:function_call] do
          true -> {:ok, @ok_response_with_function_call}
          _ -> {:ok, @ok_response}
        end
    end
  end

  def ok_response() do
    @ok_response
  end

  def error_response() do
    @error_response
  end

  def ok_response_with_function_call() do
    @ok_response_with_function_call
  end
end
