from gpu_scraper import GPUScraper
from shell_scraper import ShellScraper


def get_supercluster_result() -> dict:
    gpu_scraper = GPUScraper()
    shell_scraper = ShellScraper()

    result = gpu_scraper.get_gpu_result()
    shell_result = shell_scraper.get_shell_result()

    result.update(shell_result)
    return result


if __name__ == "__main__":
    result = get_supercluster_result()
    targets = ['GPU', 'CPU', 'BIOS']
    for t in targets:
        assert t in str(result)
    print(result)
