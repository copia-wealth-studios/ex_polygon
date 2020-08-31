defmodule ExPolygon.Rest.LastTradeOfTicker do
  @type last_trade :: ExPolygon.LastTrade.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/last/stocks/:symbol"

  @spec query(String.t(), api_key) :: {:ok, last_trade} | {:error, shared_error_reasons}
  def query(symbol, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "success", "last" => results}) do
    {:ok, trade} =
      Mapail.map_to_struct(results, ExPolygon.LastTrade, transformations: [:snake_case])

    {:ok, trade}
  end
end