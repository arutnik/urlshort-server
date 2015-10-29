# urlshort-server

This project is my implementation of a URL-shortening website.

A version of it is hosted at https://url-short-arutnik.herokuapp.com/

# Key Design Points
The 'Short' url is generated by creating a new database row in the short_url table. This row will be used for looking up on subsequent requests but also provides a unique key to generate the short-id part of the short URL. We simply use the base64 version of the 'id' column. This guarantees uniqueness and atomicity. The base64 representation is good because it can represent well over 100 million short URLS and still remain 5 digits long. In addition, it only takes up as many digits as currently needed, thus the first 64 URLs registered will have the short-id section only be 1 digit long!.

I designed the controller with the future development of a public API in mind. Most of the work in URL generation is done in helper methods for minimal code duplication.

# Public API

## api/create

JSON Body: { "shortenRequest": { "original_url": "http://www.github.com"}}

JSON Response: {"url_id":"t","maps_to":"http://www.github.com"}

## api/info/:id

Parameter id: The url_id of the short URL

JSON Response: {"url_id":"t","maps_to":"http://www.github.com"}

# Testing

For now there are only functional tests for the main controller. This is where the bulk of app logic is so this makes the most sense.

# Instructions to run solution

1. Pull the latest version of the 'develop' branch
2. Navigate to '\urlshort' folder
3. Run 'bundle install'
4. Run 'rake db:migrate'
5. Run 'rails s -p 8000' (or whatever port you want)
6. In your browser go to http://localhost:8000/

# Instructions to run tests

1. Pull the latest version of the 'develop' branch
2. Navigate to '\urlshort' folder
3. Run 'bundle install'
4. Run 'rake db:test:prepare'
5. Run 'rake test'
