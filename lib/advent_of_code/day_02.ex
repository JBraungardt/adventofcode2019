defmodule AdventOfCode.Day02 do
  def part1(args) do
    Enum.with_index(args)
    |> Enum.map(fn {value, pos} -> {pos, value} end)
    |> Enum.into(%{})
    |> process_position(0)
    |> Map.get(0)
  end

  defp process_position(input, pos) do
    case Map.get(input, pos) do
      99 -> input
      1 -> add(input, pos) |> process_position(pos + 4)
      2 -> mult(input, pos) |> process_position(pos + 4)
    end
  end

  defp value_for_position(input, pos) do
    Map.get(input, Map.get(input, pos))
  end

  defp write_value_to_position(input, value, pos) do
    Map.put(input, Map.get(input, pos), value)
  end

  defp add(input, pos) do
    v1 = value_for_position(input, pos + 1)
    v2 = value_for_position(input, pos + 2)
    write_value_to_position(input, v1 + v2, pos + 3)
  end

  defp mult(input, pos) do
    v1 = value_for_position(input, pos + 1)
    v2 = value_for_position(input, pos + 2)
    write_value_to_position(input, v1 * v2, pos + 3)
  end

  def part2(args) do
    for noun <- 0..99, verb <- 0..99 do
      List.replace_at(args, 1, noun)
      |> List.replace_at(2, verb)
    end
    |> Flow.from_enumerable()
    |> Flow.map(fn l ->
      res = part1(l)

      if res == 19_690_720 do
        {Enum.at(l, 1), Enum.at(l, 2)}
      else
        nil
      end
    end)
    |> Enum.filter(&(&1 != nil))
  end
end
