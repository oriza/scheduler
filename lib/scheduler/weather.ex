defmodule Scheduler.Weather do

  alias Db.Weather

  def run() do
    Weather.Service.lists()
    |> Enum.each(fn item ->
      current = Scraper.scrape_weather(item.city)
      Weather.Service.update(item, current)
    end)
  end
end
