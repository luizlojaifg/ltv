# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc

#Algorithm used to shorten url

    The algorithm that was used to encode the url is simple it takes the recod's id and convert it 
    to the 62 base using the array of CHARACTERS fomented by the ShorUrl class
    To do this the algorithm takes the id number and look over the rest of this number out of 62
    This value will be used to discover witch caracter must be used convert that number in 62 base 
    The value is divided by 62 and the loops restart, finally the string is reversed. 
    The reversion is needed because the algorithm firsts identify the last digits of the new identifier
    
    I also created the method really_simple_short_code that uses ruby method to encode the id in 32 base
    , nonethe less I thought that you would like to see a code that uses the constant CHARATERS that was in
    the class   
        