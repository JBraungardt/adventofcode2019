defmodule Mix.Tasks.D01.P1 do
  use Mix.Task

  import AdventOfCode.Day01

  @shortdoc "Day 01 Part 1"
  def run(args) do
    input = [
      123_265,
      68442,
      94896,
      94670,
      145_483,
      93807,
      88703,
      139_755,
      53652,
      52754,
      128_052,
      81533,
      56602,
      96476,
      87674,
      102_510,
      95735,
      69174,
      136_331,
      51266,
      148_009,
      72417,
      52577,
      86813,
      60803,
      149_232,
      115_843,
      138_175,
      94723,
      85623,
      97925,
      141_772,
      63662,
      107_293,
      130_779,
      147_027,
      88003,
      77238,
      53184,
      149_255,
      71921,
      139_799,
      84851,
      104_899,
      92290,
      74438,
      55631,
      58655,
      140_496,
      110_176,
      138_718,
      104_768,
      93177,
      53212,
      129_572,
      69877,
      139_944,
      116_062,
      51362,
      135_245,
      59682,
      128_705,
      98105,
      69172,
      89244,
      109_048,
      88690,
      62124,
      53981,
      71885,
      59216,
      107_718,
      146_343,
      138_788,
      73588,
      51648,
      122_227,
      54507,
      59283,
      101_230,
      93080,
      123_120,
      148_248,
      102_909,
      91199,
      105_704,
      113_956,
      120_368,
      75020,
      103_734,
      81791,
      87323,
      77278,
      123_013,
      58901,
      136_351,
      121_295,
      132_994,
      84039,
      76813
    ]

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
