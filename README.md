# Represent Sinatra

This microservice works in companion with the [REPresent](https://github.com/AntonioJacksonII/represent) application, providing a contact point to API services to gather information on United States representatives, senators, bills, votes and news articles.

## Getting Started

* Click "Fork" in the upper right hand corner of the page
* Follow instructions below:

```
git clone git@github.com:YOUR_USER_NAME_HERE/represent-sinatra.git
cd represent-sinatra
- bundle install
- bundle update
```

### Installing

To set up the service, you'll need API keys from [Propublica](https://www.propublica.org/datastore/api/propublica-congress-api) and [NewsAPI](https://newsapi.org/). In order to set up the API keys, you'll need to run:

```
bundle exec figaro install
```

Once it has successfully run, you'll need to access the ```config/application.yml``` file. Inside the file, post the two keys like so:

```
PROPUBLICA_API_KEY: <YOUR_KEY_HERE>
NEWS_API_KEY: <YOUR_KEY_HERE>
```

You should then be able to run the service locally using ```localhost:4567```

#### Caution: ####

The '/bills' endpoint is very call-intensive on the Propublica API, because of the amount of data it collects. Use sparingly, as it is easy to rate-limit your API key with it. It will also take some time to run, thanks to the amount of calls.

## Built With

* **Ruby**
* **Sinatra**

## Authors

- **Antonio Jackson** (https://github.com/AntonioJacksonII) 
- **Rostam Mahabadi** (https://github.com/Rostammahabadi) 
- **Derek Borski** (https://github.com/dborski) 
- **Alex Pariseau** (https://github.com/arpariseau)
