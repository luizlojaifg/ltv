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
    

#Vue Interface 
    In rails/vue_frontend run yarn install to install node_modules
    To run the program run yarn watch 
    The interface can be accessed through vue/index.html    
    To develop the interface I used Vue and Quasar
    The code can be found in rails/vue_frontend/src/js 
    In components there is a comonent called ViewShortURL.vue
    ViewShorURL has all interface's code
    
#Ember Interface
    The interface code is in rails/ember_frontend
    It may be accessed through localhost:3000/ember. The interface is already built to production use
    To use the interface is necessary to install ember the command is npm install -g ember-cli
    To run the project in a implementation mode execute the command  ember s -proxy http://localhost:3000
    To build the project is necessary execute the command ember build --environment=production

           

# Algorithm used to shorten url

    The algorithm that was used to encode the url is simple. It takes the recod's id and convert it 
    to the 62 base using the array of CHARACTERS fomented by the ShortUrl class.
    The program  takes the id number and look over the rest of this number out of 62
    This value will be used to discover witch caracter must be used to convert that number into 62 base. 
    The value is divided by 62 and the loops restart, finally the string is reversed.
    
 
