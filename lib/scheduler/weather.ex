defmodule Scheduler.Weather do

  alias Db.Weather
  alias Scraper.Utils.HTTPClient.HTTPoison
  alias Scraper.Utils.JSONParser.Jason

  def run() do
    Weather.Service.lists()
    |> Enum.each(fn item ->
      current = Scraper.scrape_weather(HTTPoison, Jason, item.city)

      Weather.Service.update(item, current)
    end)
  end
end
