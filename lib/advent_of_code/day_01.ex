defmodule AdventOfCode.Day01 do
  def part1(args) do
    Enum.map(args, &(Float.floor(&1 / 3) - 2))
    |> Enum.sum()
  end

  def part2(args) do
    Enum.map(args, &((Float.floor(&1 / 3) - 2) |> calc_fuel()))
    |> Enum.sum()
  end

  defp calc_fuel(arg) do
    case Float.floor(arg / 3) - 2 do
      r when r > 0 -> arg + calc_fuel(r)
      _ -> arg
    end
  end
end
