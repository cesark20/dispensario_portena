require 'net/http'
require 'json'

class ExchangeRatesController < ApplicationController
  def dolar
    url = URI("https://api.bluelytics.com.ar/v2/latest")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    render json: {
      oficial: data["oficial"]["value_avg"],
      blue: data["blue"]["value_buy"].to_int - 30
    }
  rescue => e
    render json: { error: "No se pudo obtener el valor del dólar." }, status: :unprocessable_entity
  end
end