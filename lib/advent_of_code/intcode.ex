defmodule Intcode do
  require Logger

  @type t :: %Intcode{
          code: map(),
          instruction_pointer: non_neg_integer(),
          inputs: list(integer()),
          outputs: list(integer()),
          state: :ready | :halted | :waiting
        }

  @enforce_keys [:code]
  defstruct [:code, instruction_pointer: 0, inputs: [], outputs: [], state: :ready]

  @spec new(list(integer()), list(integer())) :: Intcode.t()
  def new(instructions, inputs \\ [])
      when is_list(instructions) and is_list(inputs) do
    code =
      instructions
      |> Enum.with_index()
      |> Enum.map(fn {value, pos} -> {pos, value} end)
      |> Enum.into(%{})

    %Intcode{code: code, inputs: inputs}
  end

  @spec input(Intcode.t(), integer) :: Intcode.t()
  def input(computer, input) when is_integer(input) do
    input(computer, [input])
  end

  @spec input(Intcode.t(), [integer]) :: Intcode.t()

  def input(%Intcode{inputs: inputs, state: :halted} = computer, input) do
    %Intcode{computer | inputs: inputs ++ input}
  end

  def input(%Intcode{inputs: inputs} = computer, input) do
    %Intcode{computer | state: :ready, inputs: inputs ++ input}
    |> Intcode.run()
  end

  def run(%Intcode{state: :halted} = computer) do
    Logger.warn("Program has already halted.")

    computer
  end

  def run(%Intcode{state: :waiting} = computer) do
    Logger.info("Program is waiting for input.")

    computer
  end

  @spec run(Intcode.t()) :: Intcode.t()
  def run(computer) do
    next_instruction(computer)
    |> perform_operation(computer)
  end

  @spec consume_outputs(Intcode.t()) :: {[integer()], Intcode.t()}
  def consume_outputs(%Intcode{outputs: []} = computer) do
    {[], computer}
  end

  def consume_outputs(%Intcode{outputs: outputs} = computer) do
    {outputs, %Intcode{computer | outputs: []}}
  end

  defp next_instruction(%Intcode{code: code, instruction_pointer: ip}) do
    Map.get(code, ip)
    |> Operation.new()
  end

  defp perform_operation(%Operation{op_code: 99}, computer) do
    %Intcode{computer | state: :halted}
  end

  defp perform_operation(operation, computer) do
    func = operation_function(operation)

    func.(computer, operation)
    |> run()
  end

  defp operation_function(operation) do
    case operation.op_code do
      1 -> &add/2
      2 -> &multiply/2
      3 -> &input_op/2
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

  defp input_op(%Intcode{inputs: []} = computer, _operation) do
    %Intcode{computer | state: :waiting}
  end

  defp input_op(
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
