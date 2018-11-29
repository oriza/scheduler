defmodule Scheduler.Archive do

  alias Utils.{HttpClient, HtmlParser}
  alias Db.Service.{Article, Site}

  def fetch() do
    Site.lists()
    |> Enum.map(fn site ->
      IO.inspect site.name
      Scraper.scrape_archive(HttpClient, HtmlParser, site.url, site.archive_selector)
      |> save_articles(site)
    end)
  end

  defp save_articles(articles, site) when is_list(articles) do
    articles
    |> Enum.map(fn article -> 
      Article.create(Map.put(article, :site_id, site.id))
    end)
  end

  defp save_articles({:error, reason}, _), do: IO.puts reason
end