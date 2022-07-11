defmodule ExPolygon.Rest.CryptoExchanges do
  @type crypto :: ExPolygon.CryptoExchange.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/meta/crypto-exchanges"

  @spec query(api_key) :: {:ok, [crypto]} | {:error, shared_error_reasons}
  def query(api_key) do
    with {:ok, data} <- ExPolygon.Rest.HTTPClient.get(@path, %{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(data) do
    list_crypto =
      data
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.CryptoExchange, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, t} -> t end)

    {:ok, list_crypto}
  end
end
