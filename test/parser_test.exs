defmodule ReportsGenerator.ParserTest do
  @moduledoc false

  use ExUnit.Case

  alias ReportsGenerator.Parser

  describe "parse_file/1" do
    test "when a valid filename is given, parses the file" do
      filename = "report_test.csv"

      response =
        filename
        |> Parser.parse_file()
        |> Enum.map(& &1)

      expected_response = [
        ["1", "pizza", 48],
        ["2", "açaí", 45],
        ["3", "hambúrguer", 31],
        ["4", "esfirra", 42],
        ["5", "hambúrguer", 49],
        ["6", "esfirra", 18],
        ["7", "pizza", 27],
        ["8", "esfirra", 25],
        ["9", "churrasco", 24],
        ["10", "churrasco", 36]
      ]

      assert expected_response == response
    end
  end
end
