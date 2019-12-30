defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02
  @tag capture_log: true
  test "part1" do
    # input = [1, 0, 0, 0, 99]
    # result = part1(input)
    # assert result == [2, 0, 0, 0, 99]

    # input = [2, 4, 4, 5, 99, 0]
    # result = part1(input)
    # assert result == [2, 4, 4, 5, 99, 9801]

    input = [1, 1, 1, 4, 99, 5, 6, 0, 99]
    result = part1(input)
    assert result == 30
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
