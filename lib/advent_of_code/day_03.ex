defmodule AdventOfCode.Day03 do
  def part1(arg1, arg2) do
    t1 =
      Task.async(fn ->
        r1 = split_input(arg1)

        MapSet.new()
        |> fill_route(r1, {0, 0})
      end)

    r2 = split_input(arg2)

    covered2 =
      MapSet.new()
      |> fill_route(r2, {0, 0})

    covered1 = Task.await(t1)

    MapSet.intersection(covered1, covered2)
    |> MapSet.delete({0, 0})
    |> MapSet.to_list()
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min(fn -> -1 end)
  end

  defp split_input(input) do
    Enum.map(input, &create_command/1)
  end

  defp create_command(input) do
    String.split_at(input, 1)
    |> (fn {direction, distance} ->
          {direction,
           Integer.parse(distance)
           |> elem(0)}
        end).()
  end

  defp fill_route(covered, [], _), do: covered

  defp fill_route(covered, [command | rest], {x, y}) do
    filled =
      case command do
        {"R", distance} ->
          x..(x + distance)
          |> Enum.map(&{&1, y})

        {"U", distance} ->
          y..(y + distance)
          |> Enum.map(&{x, &1})

        {"L", distance} ->
          x..(x - distance)
          |> Enum.map(&{&1, y})

        {"D", distance} ->
          y..(y - distance)
          |> Enum.map(&{x, &1})
      end

    covered = MapSet.union(covered, MapSet.new(filled))
    fill_route(covered, rest, Enum.at(filled, -1))
  end

  def part2(arg1, arg2) do
    r1 = split_input(arg1)

    m1 =
      %{}
      |> fill_route_with_length(r1, {0, 0}, 0)

    # |> IO.inspect()

    r2 = split_input(arg2)

    m2 =
      %{}
      |> fill_route_with_length(r2, {0, 0}, 0)

    # |> IO.inspect()

    m1 =
      Enum.filter(m1, fn {key, _} ->
        Map.has_key?(m2, key)
      end)
      |> Enum.into(%{})
      |> Map.delete({0, 0})

    m1
    |> Enum.map(fn {key, lenght} -> lenght + m2[key] end)
    |> Enum.min()
  end

  defp fill_route_with_length(covered, [], _, _), do: covered

  defp fill_route_with_length(covered, [command | rest], {x, y}, length) do
    filled =
      case command do
        {"R", distance} ->
          x..(x + distance)
          |> Enum.with_index(length)
          |> Enum.map(fn {coord, pos} -> {{coord, y}, pos} end)
          |> Enum.into(%{})

        {"U", distance} ->
          y..(y + distance)
          |> Enum.with_index(length)
          |> Enum.map(fn {coord, pos} -> {{x, coord}, pos} end)
          |> Enum.into(%{})

        {"L", distance} ->
          x..(x - distance)
          |> Enum.with_index(length)
          |> Enum.map(fn {coord, pos} -> {{coord, y}, pos} end)
          |> Enum.into(%{})

        {"D", distance} ->
          y..(y - distance)
          |> Enum.with_index(length)
          |> Enum.map(fn {coord, pos} -> {{x, coord}, pos} end)
          |> Enum.into(%{})
      end

    covered = Map.merge(filled, covered)

    fill_route_with_length(
      covered,
      rest,
      Enum.max_by(filled, fn {_, v} -> v end) |> elem(0),
      length + elem(command, 1)
    )
  end
end
