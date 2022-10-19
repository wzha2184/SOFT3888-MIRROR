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

  def get_random_data() do
    call_python(:all_data_capture, :get_format_example, [])
  end

  def get_super_clusters_data() do
    call_python(:run, :get_sc_result, ["usyd-10a", "6r7mYcxLHXLq8Rgu", "config.json"])
  end

  def get_bmc_data() do
    call_python(:run, :get_bmc_result, ["config.json"])
  end

  def call_discord_bot(info) do
    call_python(:alertBOT, :run, [info])
  end


  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
          {:ok, json} <- JSON.decode(body), do: {:ok, json}
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
