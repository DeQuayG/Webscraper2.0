import scrapy
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor

class MiguelSpider(scrapy.Spider):
    name = "miguel"
    allowed_domains = ["myanimelist.net"]
    start_urls = ["https://myanimelist.net/anime/season"]

    def parse(self, response):
        titles = response.css('span.js-title::text').getall()
        links = response.css('div.title-text a[href^="https://myanimelist.net/anime/"]::attr(href)').getall()
        descriptions = response.css('div.synopsis.js-synopsis p.preline::text').getall()
        print(titles)
        print(descriptions)
        print(links)





