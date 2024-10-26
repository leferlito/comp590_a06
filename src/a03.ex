# Team: AJ Valentino and Lauren Ferlito

defmodule P1 do
  def start do
    # Get input from the user.
    input = IO.gets("Enter a number: ")

    # Try to convert input to an integer and handle possible errors.
    case Integer.parse(String.trim(input)) do
      :error ->
        IO.puts("Not an integer")

      {num, _} when num < 0 ->
        # If the number is negative, calculate absolute value raised to the 7th power.
        abs_value = abs(num)
        result = :math.pow(abs_value, 7)
        IO.puts("Absolute value raised to the 7th power: #{result}")

      {0, _} ->
        # If the number is 0, just print 0.
        IO.puts("0")

      {num, _} when num > 0 ->
        # If the number is positive, check if it is a multiple of 7.
        if rem(num, 7) == 0 do
          # If num is a multiple of 7, compute the 5th root.
          root = :math.pow(num, 1 / 5)
          IO.puts("5th root: #{root}")
        else
          # Otherwise, calculate the factorial.
          factorial = factorial(num)
          IO.puts("Factorial: #{factorial}")
        end
    end
  end

  # Recursive factorial function.
  defp factorial(0), do: 1  # Base case
  defp factorial(n) when n > 0, do: n * factorial(n - 1)
end

defmodule P2 do
  def loop do
    P1.start()
    input = IO.gets("Press enter to continue or '0' to quit: ")
    case String.trim(input) do
    "0" ->
      IO.puts("Exiting program.")
    _ ->
      loop()
    end
  end
end
