defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = [12, 14]
    result = part1(input)

    assert result == 4
  end

  test "part2" do
    input = [100_756]
    result = part2(input)

    assert result == 50346
  end
end
