defmodule AdventOfCode.Day05 do
  def part1(args, input_value) do
    Enum.with_index(args)
    |> Enum.map(fn {value, pos} -> {pos, value} end)
    |> Enum.into(%{})
    |> process_position(0, input_value)

    nil
  end

  defp process_position(input, pos, input_value) do
    op =
      Map.get(input, pos)
      |> Integer.digits()
      |> pad_zeros()

    code =
      Enum.take(op, -2)
      |> Integer.undigits()

    modes = Enum.take(op, 3)

    case code do
      99 ->
        input

      1 ->
        add(input, pos, modes) |> process_position(pos + 4, input_value)

      2 ->
        mult(input, pos, modes) |> process_position(pos + 4, input_value)

      3 ->
        input(input, pos, modes, input_value) |> process_position(pos + 2, input_value)

      4 ->
        output(input, pos, modes) |> process_position(pos + 2, input_value)

      5 ->
        next_pos = jump_true(input, pos, modes)
        process_position(input, next_pos, input_value)

      6 ->
        next_pos = jump_false(input, pos, modes)
        process_position(input, next_pos, input_value)

      7 ->
        less(input, pos, modes) |> process_position(pos + 4, input_value)

      8 ->
        equal(input, pos, modes) |> process_position(pos + 4, input_value)
    end
  end

  defp get_value(input, pos, 0) do
    Map.get(input, Map.get(input, pos))
  end

  defp get_value(input, pos, 1) do
    Map.get(input, pos)
  end

  defp write_value(input, value, pos, 0) do
    Map.put(input, Map.get(input, pos), value)
  end

  defp write_value(_input, _value, _pos, 1) do
    throw("Not supported")
  end

  defp add(input, pos, modes) do
    [p3_mode, p2_mode, p1_mode] = modes
    v1 = get_value(input, pos + 1, p1_mode)
    v2 = get_value(input, pos + 2, p2_mode)
    write_value(input, v1 + v2, pos + 3, p3_mode)
  end

  defp mult(input, pos, modes) do
    [p3_mode, p2_mode, p1_mode] = modes
    v1 = get_value(input, pos + 1, p1_mode)
    v2 = get_value(input, pos + 2, p2_mode)
    write_value(input, v1 * v2, pos + 3, p3_mode)
  end

  defp input(input, pos, modes, value) do
    [_p3_mode, _p2_mode, p1_mode] = modes
    write_value(input, value, pos + 1, p1_mode)
  end

  defp output(input, pos, modes) do
    [_p3_mode, _p2_mode, p1_mode] = modes

    get_value(input, pos + 1, p1_mode)
    |> IO.puts()

    input
  end

  defp jump_true(input, pos, modes) do
    [_p3_mode, p2_mode, p1_mode] = modes

    case get_value(input, pos + 1, p1_mode) do
      0 ->
        pos + 3

      _ ->
        get_value(input, pos + 2, p2_mode)
    end
  end

  defp jump_false(input, pos, modes) do
    [_p3_mode, p2_mode, p1_mode] = modes

    case get_value(input, pos + 1, p1_mode) do
      0 ->
        get_value(input, pos + 2, p2_mode)

      _ ->
        pos + 3
    end
  end

  defp less(input, pos, modes) do
    [p3_mode, p2_mode, p1_mode] = modes
    v1 = get_value(input, pos + 1, p1_mode)
    v2 = get_value(input, pos + 2, p2_mode)

    case v1 < v2 do
      true -> write_value(input, 1, pos + 3, p3_mode)
      false -> write_value(input, 0, pos + 3, p3_mode)
    end
  end

  defp equal(input, pos, modes) do
    [p3_mode, p2_mode, p1_mode] = modes
    v1 = get_value(input, pos + 1, p1_mode)
    v2 = get_value(input, pos + 2, p2_mode)

    case v1 == v2 do
      true -> write_value(input, 1, pos + 3, p3_mode)
      false -> write_value(input, 0, pos + 3, p3_mode)
    end
  end

  defp pad_zeros(list) do
    for _ <- 1..(5 - length(list)) do
      0
    end
    |> Kernel.++(list)
  end

  def part2(args, input_value) do
    Enum.with_index(args)
    |> Enum.map(fn {value, pos} -> {pos, value} end)
    |> Enum.into(%{})
    |> process_position(0, input_value)

    nil
  end
end
