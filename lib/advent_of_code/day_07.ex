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
      Intcode.input(comp, [i, accu])
      |> Intcode.run()
      |> Intcode.consume_outputs()
      |> elem(0)
      |> Enum.at(0)
    end)
  end

  def part2(args) do
    5..9
    |> Enum.to_list()
    |> permutations()
    |> Enum.map(fn amp_values ->
      amp_values
      |> Enum.map(&Intcode.new(args, [&1]))
      |> Enum.to_list()
      |> run_amps(0)
    end)
    |> Enum.max()
  end

  defp run_amps([], input), do: Enum.at(input, 0)

  defp run_amps([current_amp | rest], input) do
    {output, amp} =
      Intcode.input(current_amp, input)
      |> Intcode.consume_outputs()

    case amp.state do
      :halted -> run_amps(rest, output)
      _ -> run_amps(rest ++ [amp], output)
    end
  end

  defp permutations([]), do: [[]]

  defp permutations(l) do
    for h <- l, t <- permutations(l -- [h]), do: [h | t]
  end
end
