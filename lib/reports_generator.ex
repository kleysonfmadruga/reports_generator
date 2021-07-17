defmodule ReportsGenerator do
  @moduledoc false

  @availabe_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["foods", "users"]

  alias ReportsGenerator.Parser

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_accumulator(), fn line, report -> sum_values(line, report) end)
  end

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    %{report | "users" => users, "foods" => foods}
  end

  def fetch_higher_value(report) do
    {:ok, user_higher_value} = fetch_higher_value(report, "users")
    {:ok, food_higher_value} = fetch_higher_value(report, "foods")

    {:ok, %{"user" => user_higher_value, "food" => food_higher_value}}
  end

  def fetch_higher_value(report, option) when option in @options do
    result = Enum.max_by(report[option], fn {_key, value} -> value end)

    {:ok, result}
  end

  def fetch_higher_value(_report, _option), do: {:error, "Invalid option"}

  defp report_accumulator do
    foods = Enum.into(@availabe_foods, %{}, fn food -> {food, 0} end)
    users = Enum.into(1..30, %{}, fn id -> {Integer.to_string(id), 0} end)

    %{"users" => users, "foods" => foods}
  end
end
