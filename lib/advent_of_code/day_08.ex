defmodule AdventOfCode.Day08 do
  def part1(args) do
    layers =
      String.split(args, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(150)

    layer_index =
      layers
      |> Enum.map(&count_number(&1, 0))
      |> Enum.with_index()
      |> Enum.sort()
      |> Enum.at(0)
      |> elem(1)

    layer = Enum.at(layers, layer_index)

    count_number(layer, 1) * count_number(layer, 2)
  end

  defp count_number(layer, number) do
    Enum.count(layer, &(&1 == number))
  end

  def part2(args) do
  end
end
