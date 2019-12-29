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
    String.split(args, "", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(150)
    |> Enum.reduce(&build_image/2)
    |> Enum.map(fn p ->
      case p do
        0 -> " "
        1 -> "."
      end
    end)
    |> Enum.chunk_every(25)
    |> Enum.map(&to_string/1)
    |> Enum.each(&IO.puts/1)
  end

  defp build_image(layer, image) do
    Enum.zip(image, layer)
    |> Enum.map(fn e ->
      case e do
        {0, _} -> 0
        {1, _} -> 1
        {_, layer_value} -> layer_value
      end
    end)
  end
end
