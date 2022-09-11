import paramiko
import sys
import json
from Feature_Scraper.BIOS_And_CPU.supercluster_scraper import SuperclusterScraper
from Feature_Scraper.BIOS_And_CPU.web_scraper import WebScraper
from Feature_Scraper.GPU.gpu_scraper import GPUScraper


def get_all_features(url_config: str):
    config = json.load(url_config)
    bmc_url = config["BMC"]
    sc_url = config["supercluster"]

    result = {}
    gpu_scraper = GPUScraper()
    result.update(gpu_scraper.get_gpu_result())
    
    web_scraper = WebScraper()
    for bmc in bmc_url.keys():
        web_scraper = WebScraper(bmc, bmc_url[bmc])
        result.update(web_scraper.get_bmc_result())

    super_cluster_scraper = SuperclusterScraper()
    
    

 


if __name__ == "__main__":
    get_all_features()



