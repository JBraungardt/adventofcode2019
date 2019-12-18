defmodule AdventOfCode.Day07 do
  def part1(args) do
    amplifiers =
      0..4
      |> Enum.to_list()
      |> permutations()

    comp = Intcode.new(args)

    amplifiers
    |> Enum.map(&thrust(&1, comp))
    |> Enum.max()
  end

  defp thrust(amp, comp) do
    amp
    |> Enum.reduce(0, fn i, accu ->
      Intcode.process_inputs(comp, [i, accu])
      |> Enum.at(0)
    end)
  end

  def part2(args) do
  end

  defp permutations([]), do: [[]]

  defp permutations(l) do
    for h <- l, t <- permutations(l -- [h]), do: [h | t]
  end
end
