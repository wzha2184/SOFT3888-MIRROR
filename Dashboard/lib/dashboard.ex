defmodule Dashboard do
  @moduledoc """
  Dashboard keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Dashboard.Helper

  def get_all_data_capture() do
    call_python(:all_data_capture, :get_result, [])
  end

  defp default_instance() do
    #Load all modules in our priv/python directory
    path = [:code.priv_dir(:dashboard), "python"]
          |> Path.join()
    Helper.python_instance(to_charlist(path))
  end

  # wrapper function to call python functions using
  # default python instance
  defp call_python(module, function, args \\ []) do
    default_instance()
    |> Helper.call_python(module, function, args)
  end
end
