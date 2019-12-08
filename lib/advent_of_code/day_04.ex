defmodule AdventOfCode.Day04 do
  def part1(args) do
    # args
    # |> Stream.map(&Integer.digits/1)
    # |> Stream.filter(&is_increasing/1)
    # |> Stream.filter(&contains_doubles/1)
    # |> Enum.count()

    args
    |> Flow.from_enumerable()
    |> Flow.map(&Integer.digits/1)
    |> Flow.filter(&is_increasing/1)
    |> Flow.filter(&contains_doubles/1)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(&is_increasing/1)
    |> Stream.filter(&contains_doubles2/1)
    |> Enum.count()
  end

  defp is_increasing(digits) do
    Enum.reduce_while(digits, -1, fn digit, accu ->
      if digit >= accu, do: {:cont, digit}, else: {:halt, false}
    end)
    |> case do
      result when is_number(result) -> true
      _ -> false
    end
  end

  defp contains_doubles(digits) do
    Enum.chunk_by(digits, & &1)
    |> Enum.any?(&(length(&1) > 1))
  end

  defp contains_doubles2(digits) do
    Enum.chunk_by(digits, & &1)
    |> Enum.any?(&(length(&1) == 2))
  end
end
