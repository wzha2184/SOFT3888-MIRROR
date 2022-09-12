from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
import time
from bs4 import BeautifulSoup
import json

class WebAccesser:
    def __init__(self, BMC_url: str) -> None:
        self.url = BMC_url

        self._options = webdriver.ChromeOptions()
        self._options.add_argument('--no-sandbox')
        self._options.add_argument('ignore-certificate-errors')
        self._options.add_argument('--headless')
        self._options.add_argument('--disable-dev-shm-usage')

        self.driver = webdriver.Chrome(ChromeDriverManager().install(), options=self._options)
        
    def login(self) -> None:
        self.driver.get(self.url + '/#login')
        
        name = WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.ID, "userid")))
        name.send_keys("admin")

        password = WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.ID, "password")))
        password.send_keys("admin")
        
        submit = WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.ID, "btn-login")))
        submit.click()
        
        time.sleep(15)

    def get_page(self) -> str:
        self.driver.get(self.url + '/#sensors')
        time.sleep(10)
        return str(self.driver.page_source)


class WebScraper:
    def __init__(self, machine_name: str, BMC_url: str) -> None:
        self.web_acceccer = WebAccesser(BMC_url)
        self.machin_name = machine_name

        self.result = {}
        self.result["BMC"] = {}
        self.result["BMC"][machine_name] = {}

        self.get_cpu_info()

    def get_bmc_result(self) -> dict:
        return self.result 

    def get_cpu_info(self) -> None:
        self.web_acceccer.login()
        html_doc = self.web_acceccer.get_page()

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
                self.result["BMC"][self.machin_name][name] = value.split(" ")[0].replace("RPM", "")
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
                    self.result["BMC"][self.machin_name][state[0]] = state[1].split(" ")[0].replace("RPM", "")
                    state = []

        normal_info = normal_sensors.find_all("tr")
        for row in normal_info:
            state = []
            for col in row.find_all("td"):
                state.append(col.text.strip())
                if len(state) == 2:
                    self.result["BMC"][self.machin_name][state[0]] = state[1].split(" ")[0].replace("RPM", "")
                    state = []


if __name__ == "__main__":
    web_scraper = WebScraper("BMC1", "https://192.168.10.108")
    print(json.dumps(web_scraper.get_bmc_result(), indent=2))

