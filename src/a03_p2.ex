# Team: AJ Valentino and Lauren Ferlito
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
