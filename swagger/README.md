# Kill Bill Swagger documentation

[Swagger UI](http://swagger.io/swagger-ui/) is available within Kill Bill at http://127.0.0.1:8080/api.html. We also provide a public instance at http://killbill.io/api/ but it may not reflect the latest version (or the one you are running).

Static file is also provided here for convenience (it can be used to integrate with other tools like [Postman](https://github.com/killbill/killbill-docs/tree/v3/postman) for example).

## Build

To regenerate the Swagger file, start Kill Bill then run:

```
curl "http://127.0.0.1:8080/swagger.json" > $PWD/file/swagger.json
```
