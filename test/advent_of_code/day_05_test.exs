defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import AdventOfCode.Day05

  test "part1" do
    input = [3, 0, 4, 0, 99]

    assert capture_io(fn -> part1(input, 7) end) == "7\n"
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
