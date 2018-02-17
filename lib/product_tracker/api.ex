defmodule ProductTracker.API do
  @end_date Timex.today()
  @start_date Timex.shift(Timex.today(), days: -30)

  def fetch_product_updates(start_date \\ @start_date, end_date \\ @end_date) do
    with {:ok, url} <- get_env(:url),
         {:ok, api_key} <- get_env(:api_key) do
      build_request(url, api_key, start_date, end_date)
      |> HTTPoison.get()
      |> parse_response()
    end
  end

  defp get_env(key), do: has_env(key, Application.get_env(:product_tracker, key))

  defp has_env(key, nil), do: {:error, "#{key} is required"}
  defp has_env(_key, ""), do: get_env(nil)
  defp has_env(_key, value), do: {:ok, value}

  defp build_request(url, api_key, start_date, end_date) do
    query_params =
      URI.encode_query(%{
        api_key: api_key,
        start_date: start_date,
        end_date: end_date
      })

    "#{url}?#{query_params}"
  end

  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    body
    |> Poison.decode(keys: :atoms)
    |> handle_response
  end

  defp parse_response({:ok, %{status_code: status_code}}) do
    {:error, "unable to fetch product records: status code #{status_code}"}
  end

  defp parse_response({:error, %{reason: reason}}) do
    {:error, "unable to fetch product records: #{reason}"}
  end

  defp handle_response({:ok, %{productRecords: product_records}}) do
    {:ok, product_records}
  end

  defp handle_response({:error, _}) do
    {:error, "unable to parse response body"}
  end
end
