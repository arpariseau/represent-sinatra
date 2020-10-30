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

#### Caution: 

The '/bills' endpoint is very call-intensive on the Propublica API, because of the amount of data it collects. Use sparingly, as it is easy to rate-limit your API key with it. It will also take some time to run, thanks to the amount of calls.


### Endpoints

- /representatives
  * This endpoint retrieves biographical information from active members of the United States House of Representatives. The returned values are:
  
    | First name | Last name | Congressional ID | Date of birth | Gender |
    |:---:|:---:|:---:|:----:|:---:|
    | **Political party** | **Leadership role (if any)** | **Twitter account (official)** | **Facebook account (official)** | **GovTrack ID** |
    | **Official website URL** | **Contact form URL** | **Cook PVI** | **DW-NOMINATE score** | **Office location** |
    | **Time last updated** | **Phone** | **State** | **District** | **At-Large** |
    | **Total votes made** | **Missed votes** | **Percentage of missed votes** | **Votes with party** | **Votes against party** |
    
- /senators
  * This endpoint retrieves biographical information from active members of the United States Senate. The returned values are:
  
    | First name | Last name | Congressional ID | Date of birth | Gender |
    |:---:|:---:|:---:|:----:|:---:|
    | **Political party** | **Leadership role (if any)** | **Twitter account (official)** | **Facebook account (official)** | **GovTrack ID** |
    | **Official website URL** | **Contact form URL** | **DW-NOMINATE score** | **Next election year** | **Office location** | 
    | **Time last updated** | **Phone** | **State** | **Senate class** | **State rank (junior or senior)** |
    | **Total votes made** | **Missed votes** | **Percentage of missed votes** | **Votes with party** | **Votes against party** |
  
- /articles
  * This endpoint retrieves news articles for requested members of Congress. The parameters are:
    - A comma separated list of members
    - The sorting methodology ('relevance', for example)
    - The language, using an abbreviation ('en' for English, for example)
    - The number of articles requested
  * The returned values are: 
    | Source | Title | Description | Article URL | Date published |
    |:---:|:---:|:---:|:----:|:---:|
    
- /bills
  * This endpoint retrieves the bills that have gone up for a passage vote in Congress in the current congressional session.
  * The returned values are: 
  
    | Short title | Primary subject | Short summary |
    |:---:|:---:|:---:|
    | **Bill ID** | **House roll call** | **House session** |
    | **Congress bill URL** | **Senate roll call** | **Senate session** |
    
- /chamber_votes
  * This endpoint retrieves the number of different types of roll call votes that have been performed over the course of the current congressional session. The parameter is:
    - The chamber in question ('house' or 'senate')
  * The returned values are a filtered list of key-value pairs between the type of vote and how many of those there were. For example, votes for passing a bill will be labeled "On Passage", and will have a value for how many passage votes for bills have been made.
  
- /member_votes
  * This endpoint retrieves the vote from a particular member of Congress on a particular roll call vote. The parameters are:
    - The Congressional ID of the member in question
    - The chamber in which the member sits ('house' or 'senate')
    - The session in which the vote occurred (Each two-year Congress is split into 2 sessions, one for each year. '1' is the first session, over the course of an odd number year - for example, 2019, and '2' is the second session occuring during an even number year - for example, 2020)
    - The roll call vote number in question (This is sequential, starting from 1 at the beginning of each session, for every vote that involves the entire chamber)
  * The returned value is the member's vote, i.e. "Yes" or "No" (or if they missed the vote)
    
- /images
  * This endpoint retrieves an image url from a repository containing official portaits of US Congress members. It returns a default if one is missing. The parameter is:
    - The Congressional ID of the member in question
  * The returned value is the URL of the photo or the URL of the default, if none is located.

## Built With

* **Ruby**
* **Sinatra**

## Authors

- **Antonio Jackson** (https://github.com/AntonioJacksonII) 
- **Rostam Mahabadi** (https://github.com/Rostammahabadi) 
- **Derek Borski** (https://github.com/dborski) 
- **Alex Pariseau** (https://github.com/arpariseau)
