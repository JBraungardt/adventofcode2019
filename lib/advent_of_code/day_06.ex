defmodule AdventOfCode.Day06 do
  def part1(args) do
    map =
      args
      |> Enum.map(fn s ->
        [inner, outer] = String.split(s, ")")
        {outer, inner}
      end)
      |> Enum.into(%{})

    map
    |> Enum.map(fn {outer, _inner} -> count_orbits(map, outer, 0) end)
    |> Enum.sum()
  end

  defp count_orbits(map, obj, orbits) do
    case Map.has_key?(map, obj) do
      true -> count_orbits(map, Map.get(map, obj), orbits + 1)
      false -> orbits
    end
  end

  def part2(args) do
    graph = Enum.reduce(args, %{}, &build_graph/2)

    route =
      try do
        get_route(graph, "YOU", "SAN", [])
      catch
        route -> route
      end
      |> IO.inspect()

    Enum.count(route) - 3
  end

  defp build_graph(entry_str, graph) do
    [n1, n2] = String.split(entry_str, ")")

    graph
    |> Map.update(n1, MapSet.new([n2]), &MapSet.put(&1, n2))
    |> Map.update(n2, MapSet.new([n1]), &MapSet.put(&1, n1))
  end

  defp get_route(_graph, node, node, route) do
    throw([node | route])
  end

  defp get_route(graph, start_node, end_node, route) do
    route = [start_node | route]

    Map.get(graph, start_node)
    |> MapSet.difference(MapSet.new(route))
    |> Enum.map(fn n -> get_route(graph, n, end_node, route) end)
  end
end
