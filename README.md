# Sweater Weather v1

A Rails API that consumes four external APIs to expose weather data via endpoints that can be easily called from a front end application. Through HTTP `get` and `post` requests, the client can obtain:
- A detailed weather forecast for a supplied location, including current, daily and hourly weather data, along with embeddable icon links that reflect the conditions.
- An embeddable link to a relevant image for the location.
- "Road Trip" data, including the travel time between an origin and destination, and arrival forecast info.
- "Munchies" data, which includes travel time and the name and address of a restaurant near the destination.

There is also functionality for registering a new user and logging in an existing user. Users are supplied with a unique API key, which is required to consume the "Road Trip" endpoint.

## Getting Started

Follow these instructions to get a copy of this project up and running on your local machine. See Deployment Notes for information on setting up the API in a production environment.

### Prerequisites

- Ruby 2.7.4
- Rails 5.2.7
- Obtain a [MapQuest API](https://developer.mapquest.com/) key.
- Obtain an [OpenWeather API](https://openweathermap.org/api) key.
- Obtain a [Yelp Fusion API](https://www.yelp.com/developers/documentation/v3) key.
- Obtain an [Usplash API](https://unsplash.com/developers) key.

### Installing

Fork this repo and clone it down to your machine.

Navigate into the home directory, install the gems, and setup a local database:
```
$ cd sweater_weather
$ bundle install
$ rails db:create
$ rails db:migrate
```

Create an `application.yml` file using Figaro, then open it for editing:
```
$ bundle exec figaro install
$ (open in your text editor) config/application.yml
```

Add your API credentials to `application.yml` file using the syntax shown:
```YML
unsplash_key: your_unsplash_key
openweather_key: your_openweather_key
mapquest_key: your_mapquest_key
yelp_key: your_yelp_key
```

Ensure all tests are passing:
```
$ bundle exec rspec
=> ..........................................................................

=> Finished in 0.74927 seconds (files took 1.62 seconds to load)
=> 74 examples, 0 failures

=> Coverage report generated for RSpec to /Users/markertmer/turing/3module/projects/sweater_weather/coverage. 1392 / 1397 LOC (99.64%) covered.
```

You should now be able to establish a local server to answer requests:
```
$ rails s
```

## Endpoints

Using a tool such as [Postman](https://www.postman.com/), you can send HTTP requests to the API according to the following guidelines.

### Authentication
New users may register for an API key, which is required for some features.

To register with Sweater Weather, send a `POST` request to this URI, prepended with your local server, such as `http://localhost:3000`:
```
api/v1/users
```
A JSON payload must be sent in the body of this request to set the user's email and password:
```JSON
{
  "email": "man@dude.com",
  "password": "abc123",
  "password_confirmation": "abc123"
}
```

The response will include your unique Sweater Weather API key in the body:
```
{
    "data": {
        "type": "users",
        "id": 7,
        "attributes": {
            "email": "man@dude.com",
            "api_key": "XU3YM4C9FBPY80ZVC19VTJDN7899BTKUQP1SRPBGF0NJV2GSQODE2SMQPQ3K15E54RIOA"
        }
    }
}
```

Existing users can retrieve their API key with this `POST` request...
```
/api/v1/sessions
```
... and this body:
```
{
  "email": "man@dude.com",
  "password": "abc.123"
}
```

### Forecast
This `GET` request will obtain weather forecast data for the `location` entered in the params. For example:
```
/api/v1/forecast?location=boise,id
```
The response will look like this:
```
{
    "data": {
        "id": "null",
        "type": "forecast",
        "attributes": {
            "location": {
                "city": "Boise",
                "state": "ID",
                "country": "US"
            },
            "current": {
                "date": "April 27",
                "description": "overcast clouds",
                "feels_like_temp": 49, # in degrees Farenheit
                "high_temp": 60, # in degrees Farenheit
                "humidity": 60, # percent
                "icon_url": "http://openweathermap.org/img/wn/04d@2x.png", # link to icon representing the conditions
                "low_temp": 42, #in degrees Farenheit
                "sunrise": "6:42 AM", # local time of today's sunrise
                "sunset": "8:41 PM", # local time of today's sunset
                "temperature": 52, #degrees Farenheit
                "time": "11:55 AM", # current local time
                "uv_index": 0,
                "uv_description": "low",
                "visibility": 6.2 # in miles
            },
            "hourly": [ # weather data for the next 48 hours
                {
                    "time": "11:00 AM",
                    "temperature": 52, 
                    "icon_url": "http://openweathermap.org/img/wn/04d@2x.png"
                },
                {...},
            ],
            "daily": [ # weather data for the next 8 days
                {
                    "name": "Wednesday",
                    "description": "broken clouds",
                    "high_temp": 60,
                    "icon_url": "http://openweathermap.org/img/wn/04d@2x.png",
                    "low_temp": 42,
                    "precip_amount": 0.0, # in millimeters
                    "precip_chance": 9 # percent
                },
                {...},
            ]
        }
    }
}
```

### Background Image
Use this `GET` request to obtain a link to a relevant image to be used for the forecast background of the city specified in the `location` param. For example:
```
/api/v1/backgrounds?location=grandjunction,co
```
The response will look like this:
```
{
    "data": {
        "id": "null",
        "type": "image",
        "attributes": {
            "image": {
                "url": "https://images.unsplash.com/photo-1602980045401-3f4479127ad5?crop=entropy&cs=srgb&fm=jpg&ixid=MnwzMjIxNjF8MHwxfHNlYXJjaHwxfHxncmFuZGp1bmN0aW9uJTJDY298ZW58MHx8fHwxNjUxMDgyODY5&ixlib=rb-1.2.1&q=85",
                "alt_text": null
            },
            "credits": {
                "source_name": "Malachi Brooks",
                "source_url": "https://unsplash.com/@mebrooks01",
                "unsplash_url": "https://unsplash.com/?utm_source=sweater_weather&utm_medium=referral"
            }
        }
    }
}
```
*** You MUST credit photos according to the Unsplash API [guidelines](https://unsplash.com/documentation#guidelines--crediting). 

### Munchies
This `GET` request will provide a restaurant at your destination, along with the local forecast for the day of your arrival. It requires parameters for `start` and `destination` locations, along with a `food` type search query, such as "Mexican" or "BBQ". Example:
```
/api/v1/munchies?start=lafayette,in&destination=nashville,tn&food=bbq
```
Response:
```
{
    "data": {
        "id": "null",
        "type": "munchie",
        "attributes": {
            "destination_city": "Nashville, TN",
            "travel_time": "5 hours 20 minutes",
            "forecast": {
                "summary": "clear sky",
                "temperature": "67" # degrees Farenheit
            },
            "restaurant": {
                "name": "Peg Leg Porker",
                "address": "903 Gleaves St, Nashville, TN 37203"
            }
        }
    }
}
```

### Road Trip
A `POST` request. Supply an `origin` and `destination` to obtain the travel time and local weather forecast data for the arrival time and destination. Example:
```
/api/v1/road_trip
```
Include the locations, along with your Sweater Weather `api_key`, in the body of your request like so:
```
{
  "origin": "seattle, wa",
  "destination": "louisville, ky",
  "api_key": "TZRAZA4QI0E3HW3T61U2H3VW06F32KYR2KAOST070DD0XIY1Z0OXHUCRBEN7AGLIXKFAX"
}
```
The response will look like this:
```
{
    "data": {
        "id": "null",
        "type": "roadtrip",
        "attributes": {
            "start_city": "Seattle, WA",
            "end_city": "Louisville, KY",
            "travel_time": "33 hours 25 minutes",
            "weather_at_eta": {
                "temperature": 55,
                "conditions": "overcast clouds"
            }
        }
    }
}
```

### Style test

Checks if the best practices and the right coding style has been used.

    Give an example

## Deployment

Add additional notes to deploy this on a live system

## Built With

  - [Contributor Covenant](https://www.contributor-covenant.org/) - Used
    for the Code of Conduct
  - [Creative Commons](https://creativecommons.org/) - Used to choose
    the license

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code
of conduct, and the process for submitting pull requests to us.

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For the versions
available, see the [tags on this
repository](https://github.com/PurpleBooth/a-good-readme-template/tags).

## Authors

  - **Billie Thompson** - *Provided README Template* -
    [PurpleBooth](https://github.com/PurpleBooth)

See also the list of
[contributors](https://github.com/PurpleBooth/a-good-readme-template/contributors)
who participated in this project.

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details

## Acknowledgments

  - Hat tip to anyone whose code is used
  - Inspiration
  - etc
