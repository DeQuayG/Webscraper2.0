### Place to jot down CDD Selectors ####

Run "scrapy shell <url>" to query the webpage 
Run "reponse" afterwards within the same scrapy shell to query your response


<h1 class="season_nav">
<li>
    <a class="on" href="https://myanimelist.net/anime/season">Summer 2023</a>

<a href="https://myanimelist.net/anime/season/2022/summer">...</a>
https://myanimelist.net/anime/season/<year>/<season>



>>> response.css('a.on')
# The ".css" is for using the "css selector"
# The "a" is for the anchor tag
# Then you follow it with the class 


>>> response.css('a.on::attr(href)').get() --> 'https://myanimelist.net/anime/season'
# The "on" class (as shown above on line 9) contains the "href" attribute which is the link we want. So we use the "attr" and "href" along with the .get() method to retrieve it


>>> response.css('li::text').getall() ---> Retrieves all Genre's if needed 
## Retrieves a messy list of genre's and categories
from the link:"https://myanimelist.net/anime/season" 

>>> response.css('div.horiznav_nav::attr(ul)').getall()


>>> response.css('div.horiznav_nav').getall() 
### Gets all seasons on current page



>>> response.css('div.title').getall() 
### Returns all titles from the current page 
ex: <div class="title"><div class="title-text">
        <h2 class="h2_anime_title"><a href="https://myanimelist.net/anime/53127/Fate_strange_Fake__Whispers_of_Dawn" class="link-title">Fate/strange Fake: Whispers of Dawn</a></h2></div>
      <span style="display: none;" class="js-members">60306</span>
      <span style="display: none;" class="js-score">8.26</span>
      <span style="display: none;" class="js-start_date">20230702</span>
      <span style="display: none;" class="js-title">Fate/strange Fake: Whispers of Dawn</span>
    </div>


>>> response.css('div.title-text').getall()
ex: <h2 class="h2_anime_title"><a href="https://myanimelist.net/anime/53127/Fate_strange_Fake__Whispers_of_Dawn" class="link-title">Fate/strange Fake: Whispers of Dawn</a></h2></div>
<div class="title-text">

>>> response.css('h2.h2_anime_title').getall()
ex: <h2 class="h2_anime_title"><a href="https://myanimelist.net/anime/53127/Fate_strange_Fake__Whispers_of_Dawn" class="link-title">Fate/strange Fake: Whispers of Dawn</a></h2>

>>> response.css('div.link-title').getall() 
## Same as above but may work better

>>> response.css('h2, a.link-title').getall()
ex: '<a href="https://myanimelist.net/anime/56106/Bear_Bear_Bear_Kuma_Punch_Daiundoukai-hen" class="link-title">Bear Bear Bear Kuma Punch!! Daiundoukai-hen</a>']

>>> response.css('a.link-title[href]').getall()
ex: '<a href="https://myanimelist.net/anime/56106/Bear_Bear_Bear_Kuma_Punch_Daiundoukai-hen" class="link-title">Bear Bear Bear Kuma Punch!! Daiundoukai-hen</a>']

>>> response.css('div.title span.js-title').getall()
ex: <span style="display: none;" class="js-title">Fate/strange Fake: Whispers of Dawn</span>',

>>> response.css('span.js-title::text').get()
ex: 'Jujutsu Kaisen 2nd Season'