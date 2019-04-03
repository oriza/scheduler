defmodule Scheduler.Rates do

  alias Db.{Bank, Rate}

  def run() do
    Bank.Service.lists()
    |> Enum.each(fn bank ->
      rates = Rate.Service.lists(bank.id)
      current_rates = bank.slug
      |> Scraper.scrape_rates()
      |> Enum.map(fn rate -> %{currency: rate.currency, value: rate.average} end)

      if (Enum.empty?(rates)) do
        create_rate(current_rates, bank)
      else
        update_rates(rates, current_rates)
      end
    end)
  end

  defp create_rate(current_rates, bank) do
    current_rates
    |> Enum.map(fn rate -> Map.put(rate, :bank_id, bank.id) end)
    |> Enum.each(&Rate.Service.create/1)
  end

  defp update_rates(rates, current_rates) do
    rates
    |> Enum.map(fn rate ->
      current_rate = Enum.find(current_rates, fn current ->
        current.currency === rate.currency
      end)

      current_with_grow = current_rate
      |> Map.put(:did_grow, did_grow(current_rate.value, rate.value, rate.did_grow))

      if current_rate do
        Rate.Service.update(rate, current_with_grow)
      end
    end)
  end

  defp did_grow(new_value, old_value, old_grow) do
    cond do
      old_value == new_value ->
        old_grow
      old_value < new_value ->
        true
      old_value > new_value ->
        false
    end
  end
end
