# Team: AJ Valentino and Lauren Ferlito
defmodule Server do
  def start() do
    # Create servers in reverse order to pass them as arguments
    serv3 = spawn(fn -> serv3(0) end)
    serv2 = spawn(fn -> serv2(serv3) end)
    serv1 = spawn(fn -> serv1(serv2) end)

    # Start the main loop
    main_loop(serv1, serv2, serv3)
  end

  def main_loop(serv1, serv2, serv3) do
    IO.puts("Enter a message (or 'all_done' to exit):")
    message = IO.gets("> ") |> String.trim()

    case parse_message(message) do
      :all_done ->
        send(serv1, :halt)  # Send the halt message to serv1, which propagates down
        IO.puts("Shutting down...")
        :ok

      :update1 ->
        send(serv1, :update)
        main_loop(serv1, serv2, serv3)

      :update2 ->
        send(serv2, :update)
        main_loop(serv1, serv2, serv3)

      :update3 ->
        send(serv3, :update)
        main_loop(serv1, serv2, serv3)

      {:ok, msg} ->
        send(serv1, msg)  # Send valid messages to serv1
        main_loop(serv1, serv2, serv3)

      {:error, reason} ->
        IO.puts("Invalid input or unsupported type: #{reason}")
        main_loop(serv1, serv2, serv3)
    end
  end

  def parse_message("all_done"), do: :all_done
  def parse_message("update1"), do: :update1
  def parse_message("update2"), do: :update2
  def parse_message("update3"), do: :update3

  def parse_message(input) do
    # Handle input as a list or a valid tuple
    case Code.eval_string(input) do
      {term, _} when is_tuple(term) -> {:ok, term}  # Successfully parsed as a tuple
      {term, _} when is_list(term) -> {:ok, term}  # Successfully parsed as a list
      _ -> {:error, "Invalid input"}
    end
  end

  def serv1(next) do
    receive do
      :halt ->
        IO.puts("(serv1) Halting...")
        send(next, :halt)  # Forward halt to serv2

      :update ->
        IO.puts("(serv1) Updating serv1...")
        serv1(next)  # Call the updated version of serv1

      {:add, a, b} when is_number(a) and is_number(b) ->
        result = a + b
        IO.puts("(serv1) Adding #{a} + #{b} = #{result}")
        serv1(next)

      {:sub, a, b} when is_number(a) and is_number(b) ->
        result = a - b
        IO.puts("(serv1) Subtracting #{a} - #{b} = #{result}")
        serv1(next)

      {:mult, a, b} when is_number(a) and is_number(b) ->
        result = a * b
        IO.puts("(serv1) Multiplying #{a} * #{b} = #{result}")
        serv1(next)

      {:div, a, b} when is_number(a) and is_number(b) ->
        result = a / b
        IO.puts("(serv1) Dividing #{a} / #{b} = #{result}")
        serv1(next)

      {:neg, a} when is_number(a) ->
        result = -a
        IO.puts("(serv1) Negating #{a} = #{result}")
        serv1(next)

      {:sqrt, a} when is_number(a) ->
        result = :math.sqrt(a)
        IO.puts("(serv1) Square root of #{a} = #{result}")
        serv1(next)

      msg ->
        IO.puts("(serv1) Received message: #{inspect(msg)}")
        send(next, msg)  # Forward all other messages to serv2
        serv1(next)
    end
  end

  def serv2(next) do
    receive do
      :halt ->
        IO.puts("(serv2) Halting...")
        send(next, :halt)  # Forward halt to serv3

      :update ->
        IO.puts("(serv2) Updating serv2...")
        serv2(next)  # Call the updated version of serv2

      [head | tail] when is_integer(head) ->
        sum = Enum.sum(Enum.filter([head | tail], &is_number/1))
        IO.puts("(serv2) Sum of list with integer head: #{inspect([head | tail])} = #{sum}")
        serv2(next)

      [head | tail] when is_float(head) ->
        product = Enum.reduce(Enum.filter([head | tail], &is_number/1), 1.0, &(&1 * &2))
        IO.puts("(serv2) Product of list with float head: #{inspect([head | tail])} = #{product}")
        serv2(next)

      msg ->
        IO.puts("(serv2) Forwarding message: #{inspect(msg)}")
        send(next, msg)  # Forward other messages to serv3
        serv2(next)
    end
  end

  def serv3(unhandled_count) do
    receive do
      :halt ->
        IO.puts("(serv3) Halting...")
        IO.puts("(serv3) Total unhandled messages: #{unhandled_count}")

      :update ->
        IO.puts("(serv3) Updating serv3...")
        serv3(unhandled_count)  # Call the updated version of serv3

      {:error, reason} ->
        IO.puts("(serv3) Error: #{reason}")
        serv3(unhandled_count)

      other ->
        IO.puts("(serv3) Not handled: #{inspect(other)}")
        serv3(unhandled_count + 1)  # Increment the count for unhandled messages
    end
  end
end
