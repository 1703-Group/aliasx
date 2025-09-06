defmodule AliasxWeb.PageController do
  use AliasxWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
