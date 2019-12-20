defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import AdventOfCode.Day05

  test "part1" do
    input = [3, 0, 4, 0, 99]

    output =
      part1(input, nil)
      |> Intcode.input(7)
      |> Intcode.consume_outputs()
      |> elem(0)
      |> Enum.at(0)

    assert output == 7
  end

  test "part2" do
    # input = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
    # assert capture_io(fn -> part1(input, 8) end) == "1\n"

    # input = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
    # assert capture_io(fn -> part1(input, 7) end) == "1\n"

    # input = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
    # assert capture_io(fn -> part1(input, 8) end) == "1\n"

    # input = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
    # assert capture_io(fn -> part1(input, 7) end) == "1\n"

    # input = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
    # assert capture_io(fn -> part1(input, 0) end) == "0\n"

    # input = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
    # assert capture_io(fn -> part1(input, 8) end) == "1\n"

    # input = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]
    # assert capture_io(fn -> part1(input, 0) end) == "0\n"

    # input = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]
    # assert capture_io(fn -> part1(input, 8) end) == "1\n"
  end
end
