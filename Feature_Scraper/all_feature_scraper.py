from operator import imod
from Feature_Scraper.BIOS_And_CPU.supercluster_scraper import SuperclusterScraper
from Feature_Scraper.BIOS_And_CPU.web_scraper import WebScraper
from Feature_Scraper.GPU.gpu_scraper import GPUScraper


def get_all_features(bmc_url: str):
	web_scraper = WebScraper(bmc_url)
	super_cluster_scraper = SuperclusterScraper()
	gpu_scraper = GPUScraper()

	result = {}
	result["CPU"] = web_scraper.get_cpu_result()
	result["BIOS"] = {}
	result["GPU"] = gpu_scraper.get_gpu_result()



