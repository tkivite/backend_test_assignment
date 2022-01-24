# Introduction

A car market platform that provides a personalized selection of cars to users. There are few main models
# pre-requisites:
- ruby (v2.7.2)
- bundler (v2.1.4)


# Setup

Clone the app from github
- bundle install
- rails db:create
(Ensure your database.yml is confiigure with the right access credentials for the database)
- rails db:migrate
- rails db:seed



# Start the app

- rails s

# Usage

## Sample Request

Endpoint: {base_url}/usercarseleciton/:userid
Request Method: GET
Optional Query String: ?page=1&query=vol&price_min=20000&price_max=80000



## Schema of response:
```
[
  {
    "id": <car id>
    "brand": {
      id: <car brand id>,
      name: <car brand name>
    },
    "price": <car price>,
    "rank_score": <rank score>,
    "model": <car model>,
    "label": <perfect_match|good_match|nil>
  },
  ...
]