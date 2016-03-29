[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/1f8e4deb2319137e8867#?env%5BKill%20Bill%5D=W3sia2V5IjoiaG9zdCIsInZhbHVlIjoiMTI3LjAuMC4xIiwidHlwZSI6InRleHQiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6InBvcnQiLCJ2YWx1ZSI6IjgwODAiLCJ0eXBlIjoidGV4dCIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoidXNlcm5hbWUiLCJ2YWx1ZSI6ImFkbWluIiwidHlwZSI6InRleHQiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6InBhc3N3b3JkIiwidmFsdWUiOiJwYXNzd29yZCIsInR5cGUiOiJ0ZXh0IiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJhcGlfa2V5IiwidmFsdWUiOiJib2IiLCJ0eXBlIjoidGV4dCIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYXBpX3NlY3JldCIsInZhbHVlIjoibGF6YXIiLCJ0eXBlIjoidGV4dCIsImVuYWJsZWQiOnRydWV9XQ==)


== Building

To regenerate the [Kill Bill collection](https://www.getpostman.com/docs/collections), make sure the Swagger files are up-to-date then run:

```
ruby generate.rb > killbill.json
```

To [validate](https://www.getpostman.com/docs/validating_json_collections) it:

```
node validate.js
```
