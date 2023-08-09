.ONESHELL:
install:
	set -e
	FILE=./requirements.txt
	if [ -f "$$FILE" ]
	then
		python3 -m venv .venv
		. .venv/bin/activate
		pip3 install -r requirements.txt
	else
		python3 -m venv .venv
		. .venv/bin/activate
		pip3 install boto3 && pip3 install beautifulsoup4 && pip3 install scrapy && pip3 install scrapy && pip3 install mkdocs-material && pip3 install awscli && pip freeze > requirements.txt
		pip3 install -r requirements.txt
		mkdocs --version
	fi