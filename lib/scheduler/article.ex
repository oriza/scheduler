defmodule Scheduler.Article do

  alias Db.{Article, Site}

  def run() do
    sites = Site.Service.lists()
    site_ids = get_site_ids(sites)

    Enum.map(sites, fn site ->
      article = Article.Service.lists([site.id], false, 1)

      %{
        selectors: site.article_selector,
        article: List.first(article)
      }
    end)
    |> Enum.filter(fn item -> not is_nil(item.article) end)
    |> Enum.map(fn item ->
      case Scraper.scrape_article(item.article.url, item.selectors) do
        {:ok, article} -> article
        {:error, reason} ->
          IO.inspect reason
          nil
      end
    end)
    |> Enum.filter(fn article -> not is_nil(article) end)
    |> Enum.map(fn article -> article.published_at end)

    #Article.Service.lists(site_ids, false, 1)
    #|> Enum.map(fn article ->
    #  site = get_site(sites, article.site.id)
    #  IO.inspect site.name
    #  IO.inspect article.url
    #  Scraper.scrape_article(article.url, site.article_selector)
    #  |> update_article(article)
    #end)
  end

  defp update_article({:ok, scraped_article}, article) do
    scraped_article
    |> Map.put(:extracted, true)
    |> Article.Service.update(article)
  end

  defp update_article({:error, reason}, _), do: IO.inspect reason

  defp update_article(_, _), do: nil

  defp get_site(sites, id), do: Enum.find(sites, fn site -> site.id == id end)

  defp get_site_ids(sites), do: Enum.map(sites, fn site -> site.id end)
end
