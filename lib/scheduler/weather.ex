defmodule Scheduler.Weather do

  alias Db.Weather
  alias Scraper.Utils.HTTPoison

  def run() do
    Weather.Service.lists()
    |> Enum.each(fn item ->
      current = Scraper.scrape_weather(HTTPoison, item.city)

      Weather.Service.update(item, current)
    end)
  end
end
