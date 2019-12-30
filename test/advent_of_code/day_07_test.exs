defmodule AdventOfCode.Day07Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  import AdventOfCode.Day07

  @tag capture_log: true
  test "part1" do
    input = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]

    result = part1(input)
    assert result == 43210

    input = [
      3,
      23,
      3,
      24,
      1002,
      24,
      10,
      24,
      1002,
      23,
      -1,
      23,
      101,
      5,
      23,
      23,
      1,
      24,
      23,
      23,
      4,
      23,
      99,
      0,
      0
    ]

    result = part1(input)
    assert result == 54321

    input = [
      3,
      31,
      3,
      32,
      1002,
      32,
      10,
      32,
      1001,
      31,
      -2,
      31,
      1007,
      31,
      0,
      33,
      1002,
      33,
      7,
      33,
      1,
      33,
      31,
      31,
      1,
      32,
      31,
      31,
      4,
      31,
      99,
      0,
      0,
      0
    ]

    result = part1(input)
    assert result == 65210
  end

  @tag capture_log: true
  test "part2" do
    input = [
      3,
      26,
      1001,
      26,
      -4,
      26,
      3,
      27,
      1002,
      27,
      2,
      27,
      1,
      27,
      26,
      27,
      4,
      27,
      1001,
      28,
      -1,
      28,
      1005,
      28,
      6,
      99,
      0,
      0,
      5
    ]

    result = part2(input)

    assert result == 139_629_729
  end
end
