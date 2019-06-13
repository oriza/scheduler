defmodule Scheduler.Rss do

  use Timex
  alias Db.{Article, Site}
  alias Scraper.Utils.HTTPClient.HTTPoison
  alias Scraper.Utils.HTMLParser.Meeseeks

  def run() do
    Site.Service.lists()
    |> Enum.map(&scrape_rss/1)
  end

  def scrape_rss(site) do
    HTTPoison
    |> Scraper.scrape_rss(Meeseeks, site.feed)
    |> Enum.map(fn article -> save_article(article, site) end)
    |> Enum.map(fn article -> scrape_article(article, site.article_selector) end)
  end

  defp save_article(article, site) do
    article
    |> Map.put(:site_id, site.id)
    |> Article.Service.create()
  end

  defp scrape_article({:ok, article}, selectors) do
    Scraper.Article.scrape(HTTPoison, Meeseeks, article.url, selectors)
    |> update_article(article)
    #end
  end

  defp scrape_article(_, _), do: nil

  defp update_article({:ok, article}, saved_article) do
    attrs = %{
      title: saved_article.title,
      url: saved_article.url,
      description: saved_article.description,
      published_at: saved_article.published_at,
      author: saved_article.author || article.author,
      content: article.content,
      html: article.html,
      extracted: true
    }

    Article.Service.update(saved_article, attrs)
  end
end
