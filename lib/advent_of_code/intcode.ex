defmodule Intcode do
  @type t :: %__MODULE__{
          code: map(),
          instruction_pointer: non_neg_integer(),
          inputs: list(integer()),
          outputs: list(integer())
        }

  @enforce_keys [:code]
  defstruct [:code, instruction_pointer: 0, inputs: [], outputs: []]

  @spec new(list(integer()), list(integer())) :: Intcode.t()
  def new(instructions, inputs \\ [])
      when is_list(instructions) and is_list(inputs) do
    code =
      instructions
      |> Enum.with_index()
      |> Enum.map(fn {value, pos} -> {pos, value} end)
      |> Enum.into(%{})

    %__MODULE__{code: code, inputs: inputs}
  end

  @spec process_inputs(Intcode.t(), [integer]) :: [integer]
  def process_inputs(computer, inputs) do
    %__MODULE__{outputs: outputs} =
      %__MODULE__{computer | inputs: inputs}
      |> Intcode.process_next_instruction()

    outputs
  end

  @spec process_next_instruction(Intcode.t()) :: Intcode.t()
  def process_next_instruction(computer) do
    next_instruction(computer)
    |> perform_operation(computer)
  end

  defp next_instruction(%__MODULE__{code: code, instruction_pointer: ip}) do
    Map.get(code, ip)
    |> Operation.new()
  end

  defp perform_operation(%Operation{op_code: 99}, computer), do: computer

  defp perform_operation(operation, computer) do
    func = operation_function(operation)

    func.(computer, operation)
    |> process_next_instruction()
  end

  defp operation_function(operation) do
    case operation.op_code do
      1 -> &add/2
      2 -> &multiply/2
      3 -> &input/2
      4 -> &output/2
      5 -> &jump_true/2
      6 -> &jump_false/2
      7 -> &less/2
      8 -> &equal/2
    end
  end

  defp get_value(code, pos, :position_mode) do
    Map.get(code, Map.get(code, pos))
  end

  defp get_value(code, pos, :immediate_mode) do
    Map.get(code, pos)
  end

  defp write_value(%Intcode{code: code} = computer, value, pos, :position_mode) do
    code = Map.put(code, Map.get(code, pos), value)

    %Intcode{computer | code: code}
  end

  defp write_value(_computer, _value, _pos, :immediate_mode) do
    throw("Not supported to write value in immediate mode")
  end

  defp add(
         %Intcode{code: code, instruction_pointer: pos} = computer,
         %Operation{
           param1_mode: p1_mode,
           param2_mode: p2_mode,
           param3_mode: p3_mode
         }
       ) do
    v1 = get_value(code, pos + 1, p1_mode)
    v2 = get_value(code, pos + 2, p2_mode)

    computer = write_value(computer, v1 + v2, pos + 3, p3_mode)

    %Intcode{computer | instruction_pointer: pos + 4}
  end

  defp multiply(
         %Intcode{code: code, instruction_pointer: pos} = computer,
         %Operation{
           param1_mode: p1_mode,
           param2_mode: p2_mode,
           param3_mode: p3_mode
         }
       ) do
    v1 = get_value(code, pos + 1, p1_mode)
    v2 = get_value(code, pos + 2, p2_mode)

    computer = write_value(computer, v1 * v2, pos + 3, p3_mode)

    %Intcode{computer | instruction_pointer: pos + 4}
  end

  defp input(%Intcode{inputs: []}, _operation), do: throw("No input available")

  defp input(
         %Intcode{instruction_pointer: pos, inputs: inputs} = computer,
         %Operation{param1_mode: p1_mode}
       ) do
    [input | inputs] = inputs

    computer = write_value(computer, input, pos + 1, p1_mode)

    %Intcode{computer | instruction_pointer: pos + 2, inputs: inputs}
  end

  defp output(
         %Intcode{code: code, instruction_pointer: pos, outputs: outputs} = computer,
         %Operation{param1_mode: p1_mode}
       ) do
    value = get_value(code, pos + 1, p1_mode)

    %Intcode{computer | instruction_pointer: pos + 2, outputs: outputs ++ [value]}
  end

  defp jump_true(
         %Intcode{code: code, instruction_pointer: pos} = computer,
         %Operation{param1_mode: p1_mode, param2_mode: p2_mode}
       ) do
    next_pos =
      case get_value(code, pos + 1, p1_mode) do
        0 ->
          pos + 3

        _ ->
          get_value(code, pos + 2, p2_mode)
      end

    %Intcode{computer | instruction_pointer: next_pos}
  end

  defp jump_false(
         %Intcode{code: code, instruction_pointer: pos} = computer,
         %Operation{param1_mode: p1_mode, param2_mode: p2_mode}
       ) do
    next_pos =
      case get_value(code, pos + 1, p1_mode) do
        0 ->
          get_value(code, pos + 2, p2_mode)

        _ ->
          pos + 3
      end

    %Intcode{computer | instruction_pointer: next_pos}
  end

  defp less(
         %Intcode{code: code, instruction_pointer: pos} = computer,
         %Operation{
           param1_mode: p1_mode,
           param2_mode: p2_mode,
           param3_mode: p3_mode
         }
       ) do
    v1 = get_value(code, pos + 1, p1_mode)
    v2 = get_value(code, pos + 2, p2_mode)

    computer =
      case v1 < v2 do
        true -> write_value(computer, 1, pos + 3, p3_mode)
        false -> write_value(computer, 0, pos + 3, p3_mode)
      end

    %Intcode{computer | instruction_pointer: pos + 4}
  end

  defp equal(
         %Intcode{code: code, instruction_pointer: pos} = computer,
         %Operation{
           param1_mode: p1_mode,
           param2_mode: p2_mode,
           param3_mode: p3_mode
         }
       ) do
    v1 = get_value(code, pos + 1, p1_mode)
    v2 = get_value(code, pos + 2, p2_mode)

    computer =
      case v1 == v2 do
        true -> write_value(computer, 1, pos + 3, p3_mode)
        false -> write_value(computer, 0, pos + 3, p3_mode)
      end

    %Intcode{computer | instruction_pointer: pos + 4}
  end
end
