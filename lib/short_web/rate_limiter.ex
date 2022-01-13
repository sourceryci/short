defmodule ShortWeb.RateLimiter do
  @moduledoc """
  Limits the number of request a client can make in the given interval
  Requests are groupped by the client's IP and request path
  """

  import Phoenix.Controller, only: [json: 2]
  import Plug.Conn, only: [put_status: 2, halt: 1]

  def rate_limit(conn, %{interval_seconds: interval_seconds, max_requests: max_requests})
      when is_integer(interval_seconds) and is_integer(max_requests) do
    case ExRated.check_rate(bucket_name(conn), interval_seconds * 1000, max_requests) do
      {:ok, _count} -> conn
      {:error, _count} -> render_error(conn)
    end
  end

  def rate_limit(conn, _config), do: conn

  defp bucket_name(%{remote_ip: ip, request_path: path}), do: "#{:inet.ntoa(ip)}:#{path}"

  defp render_error(conn) do
    conn
    |> put_status(:too_many_requests)
    |> json(%{error: "Rate limit exceeded."})
    |> halt
  end
end
