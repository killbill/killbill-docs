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
