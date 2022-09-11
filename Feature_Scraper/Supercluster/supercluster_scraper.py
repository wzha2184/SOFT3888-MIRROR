from Supercluster.gpu_scraper import GPUScraper
from Supercluster.shell_scraper import ShellScraper


def run():
    gpu_scraper = GPUScraper()
    shell_scraper = ShellScraper()

    result = gpu_scraper.get_gpu_result()
    shell_scraper = shell_scraper.get_shell_result()

    result.update(shell_scraper)
    return result


if __name__ == "__main__":
    run()