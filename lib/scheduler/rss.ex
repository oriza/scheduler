defmodule Scheduler.Rss do

  alias Utils.{HttpClient, RssParser}
  alias Db.Service.{Article, Site}

  def fetch() do
    Site.lists()
    |> Enum.map(fn site ->
      IO.inspect site.name
      Scraper.scrape_rss(HttpClient, RssParser, site.feed)
      |> save_articles(site)
    end)
  end

  def save_articles(articles, site) when is_list(articles) do
    articles
    |> Enum.map(fn article -> 
      Article.create(Map.put(article, :site_id, site.id))
    end)
  end

  def save_articles({:error, reason}, _), do: IO.puts reason

  def save_articles(_), do: nil
end