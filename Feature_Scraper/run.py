import sys
import json
from BMC.web_scraper import run_web_scraper
from Supercluster.supercluster_scraper import run_supercluster_scraper


def get_result(username: str, password: str, url_config: str):
    result = run_web_scraper(url_config)
    result.update(run_supercluster_scraper(username, password, url_config))

    return result


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Invalid arguments!")
    else:
        username = sys.argv[1]
        password = sys.argv[2]
        config_path = sys.argv[3]
        
        print(get_result(username, password, config_path))