defmodule AdventOfCode.Day09 do
  def part1(args) do
    {out, _} =
      Intcode.new(args, [1])
      |> Intcode.run()
      |> Intcode.consume_outputs()

    out
  end

  def part2(args) do
    {out, _} =
      Intcode.new(args, [2])
      |> Intcode.run()
      |> Intcode.consume_outputs()

    out
  end
end
