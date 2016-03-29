# Kill Bill Swagger documentation

[Swagger UI](http://swagger.io/swagger-ui/) is available within Kill Bill at http://127.0.0.1:8080/api.html. We also provide a public instance at http://killbill.io/api/ but it may not reflect the latest version (or the one you are running).

Static files are also provided here for convenience (they can be used to integrate with other tools like [Postman](https://github.com/killbill/killbill-docs/tree/v3/postman) for example).

## Build

To regenerate the Swagger files, start Kill Bill then run:

```
for api in \
    accounts \
    admin \
    bundles \
    catalog \
    credits \
    customFields \
    export \
    invoicePayments \
    invoices \
    nodesInfo \
    overdue \
    paymentGateways \
    paymentMethods \
    paymentTransactions \
    payments \
    pluginsInfo \
    security \
    subscriptions \
    tagDefinitions \
    tags \
    tenants \
    test \
    usages; do
  curl -H 'Accept: application/json' \
       -H 'Authorization: Basic YWRtaW46cGFzc3dvcmQ=' \
       -H 'X-Killbill-Apikey: bob' \
       -H 'X-Killbill-Apisecret: lazar' \
       "http://127.0.0.1:8080/api-docs/1.0/kb/$api" | python -m json.tool > $PWD/files/$api.json
done
```
