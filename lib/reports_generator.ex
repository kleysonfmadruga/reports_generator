defmodule ReportsGenerator do
  @moduledoc """
    Provides functions to generate reports of food consumption, to get the most consumed food and the user who has the highest amount spent
  """

  @available_foods [
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

  @doc """
    Builds the complete report of food consumption and users spendings from a single file

    ## Parameters
    - filename: Name of the CSV file in the /reports folder\n

    ## Examples
      iex> ReportsGenerator.build("report_test.csv")
      %{"foods" => %{...}, "users" => %{...}}
  """
  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_accumulator(), fn line, report -> sum_values(line, report) end)
  end

  @doc """
    Builds the complete report of food consumption and users spendings from multiple files

    ## Parameters
    - filenames: List of names of the CSV files in the /reports folder\n

    ## Examples
      iex> ReportsGenerator.build_from_many(["report_1.csv", "report_2.csv", "report_3.csv"])
      %{"foods" => %{...}, "users" => %{...}}
  """
  def build_from_many(filemanes) when not is_list(filemanes) do
    {:error, "Please provide a list of filenames"}
  end

  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(fn filename -> build(filename) end)
      |> Enum.reduce(
        report_accumulator(),
        fn {:ok, result}, report ->
          sum_reports(result, report)
        end
      )

    {:ok, result}
  end

  @doc """
    Fetches the highest value in the chosen collection according with the given option

    ## Parameters
    - report: A complete report built with the build/1 or build_from_many/1 functions
    - option: A string that indicates in which collection the highest value must be fetched. The valid options are "users" (default option) and "foods"\n

    ## Examples
      iex> ReportsGenerator.build("report_test.csv") |> ReportsGenerator.fetch_highest_value("users")
      {:ok, {"5", 49}}

      iex> ReportsGenerator.build("report_test.csv") |> ReportsGenerator.fetch_highest_value()
      {:ok, {"5", 49}}

      iex> ReportsGenerator.build("report_test.csv") |> ReportsGenerator.fetch_highest_value("foods")
      {:ok, {"esfirra", 3}}

      iex> ReportsGenerator.build("report_test.csv") |> ReportsGenerator.fetch_highest_value("banana")
      {:error, "Invalid option"}
  """
  def fetch_highest_value(report, option) when option in @options do
    result = Enum.max_by(report[option], fn {_key, value} -> value end)

    {:ok, result}
  end

  def fetch_highest_value(_report, _option), do: {:error, "Invalid option"}

  def fetch_highest_value(report) do
    {:ok, user_highest_value} = fetch_highest_value(report, "users")
    {:ok, food_highest_value} = fetch_highest_value(report, "foods")

    {:ok, %{"user" => user_highest_value, "food" => food_highest_value}}
  end

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    %{"users" => users, "foods" => foods}
  end

  defp sum_reports(%{"foods" => foods_a, "users" => users_a}, %{"foods" => foods_b, "users" => users_b}) do
    foods = merge_maps(foods_a, foods_b)
    users = merge_maps(users_a, users_b)

    %{"users" => users, "foods" => foods}
  end

  defp merge_maps(map_a, map_b) do
    Map.merge(map_a, map_b, fn _key, value_a, value_b -> value_a + value_b end)
  end

  defp report_accumulator do
    foods = Enum.into(@available_foods, %{}, fn food -> {food, 0} end)
    users = Enum.into(1..30, %{}, fn id -> {Integer.to_string(id), 0} end)

    %{"users" => users, "foods" => foods}
  end
end
