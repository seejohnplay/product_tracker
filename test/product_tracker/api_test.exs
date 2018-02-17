defmodule APITest do
  use ExUnit.Case, async: true

  alias ProductTracker.{API, Repo}
  import Mock

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "parsing a valid response" do
    with_mock HTTPoison, get: fn _url -> response(:ok, 200) end do
      {:ok, updates} = API.fetch_product_updates()

      assert updates ==
               [
                 %{
                   category: "home-furnishings",
                   discontinued: false,
                   id: 123_456,
                   name: "Nice Chair",
                   price: "$10.26"
                 },
                 %{
                   category: "electronics",
                   discontinued: true,
                   id: 234_567,
                   name: "Black & White TV",
                   price: "$43.77"
                 }
               ]
    end
  end

  test "parsing with an invalid body" do
    with_mock HTTPoison, get: fn _url -> response(:ok, 200, invalid_json()) end do
      {:error, message} = API.fetch_product_updates()

      assert message == "unable to parse response body"
    end
  end

  test "unable to fetch product records with status code" do
    with_mock HTTPoison, get: fn _url -> response(:ok, 404) end do
      {:error, message_with_code} = API.fetch_product_updates()

      assert message_with_code == "unable to fetch product records: status code 404"
    end
  end

  test "unable to fetch product records with error message" do
    with_mock HTTPoison,
      get: fn _url ->
        {:error, %{id: nil, reason: :econnrefused}}
      end do
      {:error, message} = API.fetch_product_updates()

      assert message == "unable to fetch product records: econnrefused"
    end
  end

  defp response(status, status_code, json_string \\ valid_json()) do
    {status,
     %{
       body: json_string,
       headers: [
         {"Content-Type", "application/json"},
         {"X-Content-Type-Options", "nosniff"},
         {"Content-Length", "238"}
       ],
       request_url:
         "http://localhost:4567/example.json?api_key=abc123key&end_date=2017-12-18&start_date=2017-11-18",
       status_code: status_code
     }}
  end

  defp valid_json do
    "{\"status\":\"OK\",\"productRecords\":[{\"id\":123456,\"name\":\"Nice Chair\",\"price\":\"$10.26\",\"category\":\"home-furnishings\",\"discontinued\":false},{\"id\":234567,\"name\":\"Black & White TV\",\"price\":\"$43.77\",\"category\":\"electronics\",\"discontinued\":true}]}"
  end

  defp invalid_json do
    "invalid json string"
  end
end
