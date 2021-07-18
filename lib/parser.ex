defmodule ReportsGenerator.Parser do
  @moduledoc """
    Provides a function to parse a CSV file into a list of lines splitted by comma
  """

  @doc """
    Receive a CSV file name and return a stream of parsed lines

    ## Parameters
    - filename: The CSV file name in the /reports folder\n

    ## Examples
        iex> ReportsGenerator.Parser.parse_file("report_test.csv") |> Enum.each(&IO.inspect/1)
        ["1", "pizza", 48]
        ...
        :ok
  """
  def parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(2, &String.to_integer/1)
  end
end
