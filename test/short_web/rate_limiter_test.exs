defmodule ShortWeb.RateLimiterTest do
  use ShortWeb.ConnCase

  alias ShortWeb.RateLimiter

  import RateLimiter, only: [rate_limit: 2]

  @config %{
    interval_seconds: 1,
    max_requests: 5
  }

  setup do
    ExRated.delete_bucket("192.168.1.2:/links")
    ExRated.delete_bucket("192.168.1.3:/links")
    ExRated.delete_bucket("192.168.1.2:/other")
    ExRated.delete_bucket("192.168.1.3:/other")

    put_in(@config[:interval_ms], @config[:interval_seconds] * 1000)
  end

  test "groups requests by remote_ip and path", %{
    conn: conn,
    interval_ms: interval_ms,
    max_requests: max_requests
  } do
    rate_limit(%{conn | remote_ip: {192, 168, 1, 2}, request_path: "/links"}, @config)
    rate_limit(%{conn | remote_ip: {192, 168, 1, 2}, request_path: "/links"}, @config)

    rate_limit(%{conn | remote_ip: {192, 168, 1, 3}, request_path: "/links"}, @config)

    rate_limit(%{conn | remote_ip: {192, 168, 1, 2}, request_path: "/other"}, @config)
    rate_limit(%{conn | remote_ip: {192, 168, 1, 3}, request_path: "/other"}, @config)

    assert {_requests_count = 2, _remaining_requests = 3, _, _, _} =
             ExRated.inspect_bucket("192.168.1.2:/links", interval_ms, max_requests)

    assert {_requests_count = 1, _remaining_requests = 4, _, _, _} =
             ExRated.inspect_bucket("192.168.1.3:/links", interval_ms, max_requests)

    assert {_requests_count = 1, _remaining_requests = 4, _, _, _} =
             ExRated.inspect_bucket("192.168.1.2:/other", interval_ms, max_requests)

    assert {_requests_count = 1, _remaining_requests = 4, _, _, _} =
             ExRated.inspect_bucket("192.168.1.3:/other", interval_ms, max_requests)
  end

  test "it does not block the request when max requests are not exceeded", %{
    conn: conn,
    max_requests: max_requests
  } do
    conns =
      for _ <- 1..max_requests do
        rate_limit(%{conn | remote_ip: {192, 168, 1, 2}, request_path: "/links"}, @config)
      end

    assert Enum.all?(conns, &(&1.status == nil))
  end

  test "renders an error when max requests are exceeded", %{
    conn: conn,
    max_requests: max_requests
  } do
    conns =
      for _ <- 1..(max_requests + 1) do
        rate_limit(%{conn | remote_ip: {192, 168, 1, 2}, request_path: "/links"}, @config)
      end

    assert [%{status: 429, resp_body: body} | _] = Enum.reverse(conns)
    assert body =~ ~r/Rate limit exceeded/
  end
end
