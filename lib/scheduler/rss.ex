defmodule Scheduler.Rss do

  use Timex
  alias Db.{Article, Site}
  alias Scraper.Utils.{HTTPoison, Meeseeks}

  def run() do
    Site.Service.lists()
    |> Enum.map(&scrape_rss/1)
  end

  def scrape_rss(site) do
    HTTPoison
    |> Scraper.scrape_rss(Meeseeks, site.feed)
    |> save_articles(site)
  end

  defp scrape_article(article, selectors) do
    Scraper.Article.scrape(HTTPoison, article.url, selectors)
  end

  defp save_article(article, site) do
    article
    |> Map.put(:site_id, site.id)
    |> Article.Service.create()
  end

  defp save_articles(articles, site) when is_list(articles) do
    articles |> Enum.map(fn article -> save_article(article, site) end)
  end

  defp save_articles({:error, reason}, _), do: IO.puts reason

  defp save_articles(_, _), do: nil
end
