# USYD10-A Data Center Monitor Dashboard

## Preparation
  * [`Elixir`](https://elixir-lang.org/install.html) Installed
  * Setup [`PostgreSQL`](https://www.postgresql.org/download/) and start [`PostgreSQL`](https://www.postgresql.org/) server
  * `Python 3.6+` Installed
    * python dependencies installed

## To start Dashboard Phoenix server:
  * `cd Dashboard-Contex`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

  Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
  
## To check the output of the back-end python scripts:
  * Go to the Feature_Scrape folder using `cd Feature_Scraper`
  * Run "python3 run.py usyd-10a 6r7mYcxLHXLq8Rgu url_config.json", wait for about 30 secs and you will see the output
  * (To get the results of the unit test, you need to first use ssh to access supercluster9 192.168.10.9 with username usyd-10a and password 6r7mYcxLHXLq8Rgu. Then cd soft3888_tu12_04_re_p39/Feature_Scraper, and run "sudo bash test_scraper.sh". Wait for about 30 secs and you will see the result.

