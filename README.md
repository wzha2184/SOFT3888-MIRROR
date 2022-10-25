# USYD10-A Data Center Monitor Dashboard

## Preparation
* To setup the virtual machine which will run the Strong Data Centre:
  * Updata system by `sudo apt update`
  * First install Git by `sudo apt-get install git`
  * Clone our project repo by `git clone git clone https://Astral_Jason@bitbucket.org/astral_jason/soft3888_tu12_04_re_p39.git` with the password `ATBB8J9vxpLMtdwe4Ak5pdpzBfWp03788AF4`
  * Go to the root directory of the repository and run `bash vm_setup.sh` to install all the required packages(may require manual confirmation)
  
* To setup the supercluster environment:
  * Updata system by `sudo apt update`
  * First install Git by `sudo apt-get install git`
  * Clone our project repo by `git clone git clone https://Astral_Jason@bitbucket.org/astral_jason/soft3888_tu12_04_re_p39.git` with the password `ATBB8J9vxpLMtdwe4Ak5pdpzBfWp03788AF4` to get the required scripts
  * Go to the root directory of the repository and run `bash sc_setup.sh` to install all the required packages(may require manual confirmation)

* [`Elixir`](https://elixir-lang.org/install.html) v1.13.4 Installed
  * [`Elixir`](https://elixir-lang.org/install.html) Installed
  * Setup [`PostgreSQL`](https://www.postgresql.org/download/) and start [`PostgreSQL`](https://www.postgresql.org/) server
  * `Python 3.6+` Installed
    * python dependencies installed

## To start Dashboard Phoenix server:
  * `cd Dashboard-Contex`
  * Install dependencies with `sudo mix deps.get`
  * Create and migrate your database with `sudo mix ecto.setup`
  * Start Phoenix endpoint with `sudo mix phx.server` or inside IEx with `iex -S mix phx.server`

  Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Unit Testing:
  The unit testing focuses on the back-end part and consists of 3 parts: the test for web scraper (test_web_scraper.py), the test for gpu scraper (test_gpu_scraper.py), and the test for shell scraper (test_shell_scraper.py). We check the occurrences of attribute keywords, the type (e.g., string, integer or float) and the format of attribute values (e.g., 3 decimal places), etc.  
  * Test the web scraper: you can use any computer to do this. 'cd Feature_Scraper/BMC', and then run 'python3 test_web_scraper.py'.
  * Test the cpu scraper: this should be performed on supercluster9. After connecting to supercluster9, go to Feature_Scraper/Supercluster, and then run 'sudo python3 test_gpu_scraper.py'.
  * Test the shell scraper: this should be performed on supercluster10. After connecting to supercluster10, go to Feature_Scraper/Supercluster, and then run 'sudo python3 test_shell_scraper.py'.
