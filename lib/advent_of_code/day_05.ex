defmodule AdventOfCode.Day05 do
  def part1(args, input_value) do
    Intcode.new(args)
    |> Intcode.run()
  end

  def part2(args, input_value) do
    Intcode.new(args, [input_value])
    |> Intcode.run()
  end
end
