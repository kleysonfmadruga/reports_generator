defmodule ReportsGeneratorTest do
  @moduledoc false

  use ExUnit.Case

  describe "build/1" do
    test "when a valid filename is given, build a report" do
      filename = "report_test.csv"

      response = ReportsGenerator.build(filename)

      expected_response = %{
        "foods" => %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      assert response == expected_response
    end
  end

  describe "fetch_higher_value/1" do
    test "when a valid filename is given and no option is given, return the max user value" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_value()

      expected_reponse = {:ok, %{"food" => {"esfirra", 3}, "user" => {"5", 49}}}

      assert expected_reponse == response
    end
  end

  describe "fetch_higher_value/2" do
    test "when a valid filename is given and the option 'users' is given, return the max user value" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_value("users")

      expected_reponse = {:ok, {"5", 49}}

      assert expected_reponse == response
    end

    test "when a valid filename is given and the option 'foods' is given, return the max food occurrences" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_value("foods")

      expected_reponse = {:ok, {"esfirra", 3}}

      assert expected_reponse == response
    end

    test "when a valid filename is given and a invalid option is given, return an error" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_value("banana")

      expected_reponse = {:error, "Invalid option"}

      assert expected_reponse == response
    end
  end
end
