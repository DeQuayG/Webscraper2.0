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


>>> response.css('div.link-title').getall() 
## Same as above but may work better

>>> response.css('div.title::attr(link-title)').getall()
