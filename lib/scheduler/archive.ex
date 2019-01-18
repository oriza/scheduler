defmodule Scheduler.Archive do

  alias Utils.{HttpClient, HtmlParser}
  alias Db.Service.{Article, Site}

  def run(site_name, page \\ 1) do
    site = Site.get_by_name!(site_name)
    url = "#{site.archive}#{page}"

    Scraper.scrape_archive(url, site.archive_selector)
    |> save_articles(site)

    run(site_name, page + 1)
  end

  defp save_articles(articles, site) when is_list(articles) do
    articles
    |> Enum.map(fn article ->
      IO.inspect article
      #Article.create(Map.put(article, :site_id, site.id))
    end)
  end

  defp save_articles({:error, reason}, _), do: IO.puts reason
end
