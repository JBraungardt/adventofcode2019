defmodule AdventOfCode.Day06 do
  def part1(args) do
    map =
      args
      |> Enum.map(fn s ->
        [inner, outer] = String.split(s, ")")
        {outer, inner}
      end)
      |> Enum.into(%{})

    map
    |> Enum.map(fn {outer, _inner} -> count_orbits(map, outer, 0) end)
    |> Enum.sum()
  end

  defp count_orbits(map, obj, orbits) do
    case Map.has_key?(map, obj) do
      true -> count_orbits(map, Map.get(map, obj), orbits + 1)
      false -> orbits
    end
  end

  def part2(args) do
  end
end
