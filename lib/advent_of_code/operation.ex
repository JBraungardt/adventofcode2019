defmodule Operation do
  @type mode :: :position_mode | :immediate_mode | :relative_mode
  @type t :: %__MODULE__{
          op_code: integer(),
          param1_mode: mode(),
          param2_mode: mode(),
          param3_mode: mode()
        }

  defstruct [:op_code, :param1_mode, :param2_mode, :param3_mode]

  @spec new(integer) :: Operation.t()
  def new(operation) do
    op =
      operation
      |> Integer.digits()
      |> pad_zeros()

    op_code =
      Enum.take(op, -2)
      |> Integer.undigits()

    [param3_mode, param2_mode, param1_mode] =
      Enum.take(op, 3)
      |> Enum.map(fn mode ->
        case mode do
          0 -> :position_mode
          1 -> :immediate_mode
          2 -> :relative_mode
        end
      end)

    %__MODULE__{
      op_code: op_code,
      param1_mode: param1_mode,
      param2_mode: param2_mode,
      param3_mode: param3_mode
    }
  end

  defp pad_zeros(list) do
    List.duplicate(0, 5 - length(list)) ++ list
  end
end
