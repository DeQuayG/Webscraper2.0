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

# div.seasonal-anime-list:nth-child(1) > div:nth-child(5) > div:nth-child(3)
#     <p class="preline">In a trash-filled apartment, 24-year-old Akira Tendou watches a zombie movie with lifeless, envious eyes. After spending three hard years at an exploitative corporation in Japan, his spirit is broken. He can't even muster the courage to confess his feelings to his beautiful co-worker Ootori. Then one morning, he stumbles upon his landlord eating lunch—which happens to be another tenant! The whole city's swarming with zombies, and even though he's running for his life, Akira has never felt more alive!

# (Source: VIZ Media)</p>
#     <button class="js-toggle-text" style="display: block; margin: 0 auto; background: none; border: none;">
#       <i class="fa-solid fa-angle-down" style="pointer-events: none;"></i>
#     </button>

#     <div class="properties">
#       <div class="property">
#         <span class="caption">Studio</span><span class="item"><a href="/anime/producer/2674/BUG_FILMS" title="BUG FILMS">BUG FILMS</a></span></div>
#       <div class="property">
#         <span class="caption">Source</span><span class="item">Manga</span>
#       </div><div class="property">
#         <span class="caption">Themes</span><span class="item"><a href="/anime/genre/50/Adult_Cast" title="Adult Cast">Adult Cast</a></span><span class="item"><a href="/anime/genre/76/Survival" title="Survival">Survival</a></span></div><div class="property">
#         <span class="caption">Demographic</span><span class="item"><a href="/anime/genre/42/Seinen" title="Seinen">Seinen</a></span></div></div>
  
# scraper()html.appearance-none body.page-common.season div#myanimelist div.wrapper div#contentWrapper div#content.pl0.pr0 div.js-categories-seasonal div.seasonal-anime-list.js-seasonal-anime-list.js-seasonal-anime-list-key-1 div.js-anime-category-producer.seasonal-anime.js-seasonal-anime.js-anime-type-all.js-anime-type-1 div.synopsis.js-synopsis p.preline


### Returns all titles from the current page 
# ex: <div class="title"><div class="title-text">
#         <h2 class="h2_anime_title"><a href="https://myanimelist.net/anime/53127/Fate_strange_Fake__Whispers_of_Dawn" class="link-title">Fate/strange Fake: Whispers of Dawn</a></h2></div>
#       <span style="display: none;" class="js-members">60306</span>
#       <span style="display: none;" class="js-score">8.26</span>
#       <span style="display: none;" class="js-start_date">20230702</span>
#       <span style="display: none;" class="js-title">Fate/strange Fake: Whispers of Dawn</span>
#     </div>




