defmodule LiveboardWeb.PageController do
  use LiveboardWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
