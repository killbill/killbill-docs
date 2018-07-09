# [Kill Bill](http://killbill.io) collection for Postman

## Installation

This repository contains a collection for [Postman](https://www.getpostman.com/). To get started:

1. Install [Postman Native App](https://www.getpostman.com/apps) 
2. Get the latest version of the collection from this repository:
   * Click Import
   * Select the killbill.json file from this repository
   * Either import it as a new collection or overwrite an existing collection

A few [environment variables](https://www.getpostman.com/docs/environments) are required:

* `host`: Kill Bill host (e.g. 127.0.0.1)
* `port`: Kill Bill port (e.g. 8080)
* `username`: Kill Bill username (e.g. admin)
* `password`: Kill Bill password (e.g. password)
* `api_key`: Tenant api key (e.g. bob)
* `api_secret`: Tenant api secret (e.g. lazar)

To import the example environment `killbill.env.json`, go to Manage Environments in Postman and import the file.

## Usage

To execute an API call, simply browse to the API call in the Sidebar and select it. Update the request in the right pane (the Request Builder) as needed (add body, change query parameters, etc.) and click Send.

## Build

To regenerate the [Kill Bill collection](https://www.getpostman.com/docs/collections), make sure the Swagger files are up-to-date then run:

```
ruby generate.rb > killbill.json
```

To [validate](https://www.getpostman.com/docs/validating_json_collections) it:

```
node validate.js
```
