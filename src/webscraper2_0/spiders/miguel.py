import scrapy
import beautifulsoup


class MiguelSpider(scrapy.Spider):
    name = "miguel"
    allowed_domains = ["myanimelist.net"]
    start_urls = ["https://myanimelist.net/anime/season"]

    def parse(self, response):
        titles = response.css('div.link-title').getall() 
        for title in titles:
            title = response.css('div.link-title').get() 
            print(title)
        pass

