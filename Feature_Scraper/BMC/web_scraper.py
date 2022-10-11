from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
import time
from bs4 import BeautifulSoup
import json
import os

class WebAccesser:
    def __init__(self) -> None:
        self.url = ""

        self._options = webdriver.ChromeOptions()
        self._options.add_argument('--no-sandbox')
        self._options.add_argument('ignore-certificate-errors')
        self._options.add_argument('--headless')
        self._options.add_argument('--disable-dev-shm-usage')

        self.driver = webdriver.Chrome(ChromeDriverManager().install(), options=self._options)
        
    def set_url(self, url: str) -> None:
        self.url = url
    
    def login(self) -> None:
        self.driver.get(self.url + '/#login')
        
        name = WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.ID, "userid")))
        name.send_keys("admin")

        password = WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.ID, "password")))
        password.send_keys("admin")
        
        submit = WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.ID, "btn-login")))
        submit.click()
        
        time.sleep(15)

    def get_page(self, page_name: str) -> str:
        self.driver.get(self.url + '/#{}'.format(page_name))
        time.sleep(10)
        return str(self.driver.page_source)


class WebScraper:
    def __init__(self, machine_name: str, web_accesser: WebAccesser) -> None:
        self.web_accesser = web_accesser
        self.machin_name = machine_name

        self.result = {}

        self.get_info()

    def get_bmc_result(self) -> dict:
        return self.result 

    def get_info(self) -> None:
        try:
            self.web_accesser.login()
            html_doc = self.web_accesser.get_page()

            self.result["status"] = "OK"

            soup = BeautifulSoup(html_doc, 'html.parser')
            critical_sensors = None
            descrete_sensors = None
            normal_sensors = None

            info = soup.find_all("div")
            for div in info:
                if div.get("class") is not None and " ".join(div.get("class")) == "row animated fadeInUp":
                    critical_sensors = div
                elif div.get("class") is not None and " ".join(div.get("class")) == "row animated fadeInUp delay-0":
                    descrete_sensors = div
                elif div.get("class") is not None and " ".join(div.get("class")) == "row animated fadeInUp delay-1":
                    normal_sensors = div

            # Critical sensors(CPU)
            CPU_info = critical_sensors.find_all("div")
            name = None
            value = None
            for div in CPU_info:
                if " ".join(div.get("class")) == "percentage":
                    value = div.text
                if " ".join(div.get("class")) == "sensor-title":
                    name = div.text

                if name is not None and value is not None:
                    self.result[name] = value.split(" ")[0].replace("RPM", "")
                    name = None
                    value = None

            # Descrete sensors
            descrete_info = descrete_sensors.find_all("tr")
            for row in descrete_info:
                state = []
                for col in row.find_all("td"):
                    if col.get("class") is None or "".join(col.get("class")) != "hide":
                        state.append(col.text.strip())
                    if len(state) == 2:
                        self.result[state[0]] = state[1].split(" ")[0].replace("RPM", "")
                        state = []

            normal_info = normal_sensors.find_all("tr")
            for row in normal_info:
                state = []
                for col in row.find_all("td"):
                    state.append(col.text.strip())
                    if len(state) == 2:
                        self.result[state[0]] = state[1].split(" ")[0].replace("RPM", "")
                        state = []
        except:
            self.result["status"] = "error"

def run(url_config: str) -> dict:
    with open(url_config, "r") as jc:
        config = json.load(jc)
        superclusters = config["superclusters"]

        web_accesser = WebAccesser()
        result = {}
        result["BMC"] = {}
        for sc in superclusters.keys():
            bmc_url = superclusters[sc]["BMC"]
            web_accesser.set_url(bmc_url)
            web_scraper = WebScraper(sc, web_accesser)
    
            result["BMC"][sc] = web_scraper.get_bmc_result()

        return result

if __name__ == "__main__":
    # config = os.path.join("..", "config.json")
    # result = run(config)
    # print(json.dumps(result, indent=2))
    web_accesser = WebAccesser()
    bmc_url = "https://192.168.10.102"
    web_accesser.set_url(bmc_url)

    web_accesser.login()
    web_accesser.get_page()

