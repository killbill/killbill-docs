---
name: killbill
description: Use when working with the Kill Bill open source billing and payments platform, or with Aviate, Kill Bill's premium enterprise control plane. This skill helps with subscriptions, invoices, payments, catalog configuration, plugins, APIs, Kaui administration, tenant configuration, Java plugin development, and Aviate setup/configuration.
metadata:
  version: "1.0"
---

# Kill Bill Skill

## Product summary

Kill Bill is an open-source subscription billing and payments platform. It handles account management, subscription/entitlement lifecycles, catalog-driven pricing, usage-based billing, invoicing, payments, and overdue/dunning. Kill Bill is highly extensible through plugins and supports multiple payment gateways, tax providers, notification systems, and custom business logic. Agents use Kill Bill to create and manage accounts, subscriptions, invoices, payments, and usage data.

Kaui is the companion admin UI for Kill Bill, used for day-to-day billing operations. 

Aviate is Kill Bill's premium companion control plane, used to configure catalogs, taxes, plugins, invoice/email templates, tenant settings, and to monitor deployment health. 

| Component | Role |
| --- | --- |
| **Kill Bill** | The billing engine — manages accounts, subscriptions, invoices, payments, and taxes under the hood |
| **Aviate** | The **setup** layer — configure catalogs, taxes, invoice templates, and tenant settings; monitor system health |
| **Kaui** | The **operations** layer — day-to-day actions: creating customers, managing subscriptions, reviewing invoices |

In short: **use Aviate to set things up, use Kaui to run billing operations.**

**Key entry points:**
- REST API: `http://<host>:8080/1.0/kb` (self-hosted; no shared public sandbox URL)
- Admin UI (Kaui): typically deployed at `http://<host>:9090`
- Client libraries: `killbill-client-java`, `killbill-client-python`, `killbill-client-ruby`, `killbill-client-js`
- Plugin manager (KPM): Used to install plugins using `kpm install_java_plugin <plugin-name>`
- Docker: `killbill/killbill` and `killbill/kaui` images
- Aviate UI: `https://aviate.killbill.io` — premium enterprise control plane for catalog, tax, and health configuration
- MCP server: `https://apidocs-mcp.killbill.io/mcp` — provides direct access to Kill Bill API documentation; can generate accurate, up-to-date API usage examples and scripts

**Authentication:** HTTP Basic Auth (`-u <username>:<password>`) plus required multi-tenancy headers `X-Killbill-ApiKey` and `X-Killbill-ApiSecret`. Every mutating call should also include `X-Killbill-CreatedBy` (and optionally `X-Killbill-Reason` / `X-Killbill-Comment`). Aviate endpoints require a JWT ID token (`Authorization: Bearer ${ID_TOKEN}`) in addition to standard tenant headers.


**Primary docs:** 
- https://docs.killbill.io
- https://apidocs.killbill.io

---

## When to use

Use this skill whenever users ask about:

- **Kill Bill installation or deployment** - Install Kill Bill in Tomcat, Docker or AWS
- **Account management** - Add new accounts, update billing information, manage addresses, currency, and payment methods
- **Subscription lifecycle** - Create bundles/subscriptions against catalog plans, handle plan changes, cancellations, pause/resume bundles/subscriptions
- **Catalog configuration** - Define products, plans, price lists, phases, and usage tiers via Kill Bill XML or the Aviate Catalog UI
- **Invoices and invoice adjustments** - Trigger invoice runs, generate dry-run invoices, adjust/credit invoices, manage invoice items
- **Payments, payment methods and payment retries** - Configure payment plugins (Braintree, Stripe, Adyen, etc.), trigger payments/refunds, manage payment methods, payment retries
- **Usage billing** - Configure tiered usage in the catalog, record usage via the usage API
- **Tags and custom fields** — Attach system tags (e.g. `AUTO_INVOICING_OFF`) to control system behavior, or custom fields to store additional metadata on accounts, subscriptions, and invoices
- **Tenant configuration** — Set up per-tenant catalog, overdue, invoice and payment configuration; manage API keys/secrets and tenant-level feature flags
- **Handling overdue/dunning** — Configure overdue XML rules, enforce overdue logic
- **Querying billing data** — Look up accounts, bundles, subscriptions, invoices, payments, and audit history
- **Administering via Kaui** — Manage tenants, accounts, subscriptions, invoices, payments, users, permissions, and catalogs through the Kaui web UI
- **Administering via Aviate** — Configure catalogs, taxes, invoice templates, and tenant settings through the Aviate UI; manage multiple Kill Bill deployments from one place; monitor billing health via the Aviate Health dashboard
- **Aviate wallet and metering** — Set up prepaid credit wallets with automatic top-off, or record raw usage events via Aviate metering for usage-based billing
- **Extending via plugins** — Write or configure OSGI/Java plugins, notification plugins, payment plugins or other custom plugins
- **REST API usage** — Authenticate, construct multi-tenant headers, and call Kill Bill endpoints directly for custom integrations
- **Java client library** — Generate or use `killbill-client-java` to interact with the API from Java applications instead of raw HTTP calls
- **Troubleshooting Kill Bill behavior** — Diagnose unexpected invoice, payment, or subscription states using audit logs, bus events, and plugin logs

---

## General guidance

When answering questions:

1. On loading this skill, check whether an MCP connector for `https://apidocs-mcp.killbill.io/mcp` is available/connected. If it is not connected, ask the user whether they'd like to connect it before proceeding — it provides direct, current API documentation and can generate accurate code snippets, reducing reliance on this skill's own static examples or on web search.
2. Prefer official Kill Bill documentation over assumptions.
3. Mention version-specific behavior when relevant.
4. If multiple approaches exist, recommend the simplest supported approach first.
5. Prefer configuration over custom code when possible.
6. When discussing plugins, clearly distinguish between:
   - Kill Bill core
   - Kaui
   - Payment plugins
   - Notification plugins
   - Open source plugins (Like Stripe, Adyen, Braintree, etc.)
   - Private/Custom plugins
   - Aviate
7. Use official REST API endpoints whenever applicable.
8. For Java development, prefer the supported Kill Bill plugin APIs rather than internal implementation classes.

---


## Quick reference

### API authentication

```bash
# Basic Auth + multi-tenancy headers
curl -u admin:password \
  -H "X-Killbill-ApiKey: bob" \
  -H "X-Killbill-ApiSecret: lazar" \
  http://127.0.0.1:8080/1.0/kb/accounts

# Mutating calls also need CreatedBy
curl -X POST -u admin:password \
  -H "X-Killbill-ApiKey: bob" \
  -H "X-Killbill-ApiSecret: lazar" \
  -H "X-Killbill-CreatedBy: reshma" \
  -H "Content-Type: application/json" \
  -d '{"name": "Acme", "currency": "USD"}' \
  http://127.0.0.1:8080/1.0/kb/accounts
  
# aviate endpoints (requires a JWT ID token - `Authorization: Bearer ${ID_TOKEN}`)
curl -X GET \
-H"Authorization: Bearer ${ID_TOKEN}" \
-H 'Content-Type: application/json' \
-H 'X-killbill-apiKey: bob' \
-H 'X-killbill-apisecret: lazar' \
'http://127.0.0.1:8080/plugins/aviate-plugin/v1/catalog/product/all' 
  
```



### Core resources and endpoints

| Resource | Common operations |
| --- | --- |
| **Accounts** | `POST /1.0/kb/accounts`, `GET /1.0/kb/accounts/{accountId}`, `PUT /1.0/kb/accounts/{accountId}` |
| **Bundles/Subscriptions** | `POST /1.0/kb/subscriptions`, `GET /1.0/kb/subscriptions/{subscriptionId}`, `DELETE /1.0/kb/subscriptions/{subscriptionId}` |
| **Invoices** | `GET /1.0/kb/invoices/{invoiceId}`, `POST /1.0/kb/invoices?dryRun=true`, `POST /1.0/kb/invoices/template` |
| **Payments** | `POST /1.0/kb/accounts/{accountId}/payments`, `GET /1.0/kb/payments/{paymentId}`, `POST /1.0/kb/payments/{paymentId}/refunds` |
| **Payment methods** | `POST /1.0/kb/accounts/{accountId}/paymentMethods`, `GET /1.0/kb/accounts/{accountId}/paymentMethods` |
| **Usage** | `POST /1.0/kb/usages`, `GET /1.0/kb/usages/{subscriptionId}` |
| **Catalog** | `POST /1.0/kb/catalog/xml`, `GET /1.0/kb/catalog` |
| **Tags / Custom fields** | `POST /1.0/kb/accounts/{accountId}/tags`, `POST /1.0/kb/accounts/{accountId}/customFields` |
| **Tenants** | `POST /1.0/kb/tenants`, `POST /1.0/kb/tenants/{tenantId}/uploadPerTenantConfig` |

### Aviate resources and endpoints (Premium)

Base path: `/plugins/aviate-plugin/v1/...`. Requires a JWT ID token (`Authorization: Bearer ${ID_TOKEN}`) in addition to standard tenant headers.

| Resource | Common operations                                                                                                                                                                                                                                                                    |
| --- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Wallet** | `POST /wallet`, `GET /wallet/{accountId}`, `PUT /wallet/{walletId}/credit`, `PUT /wallet/{walletId}/topOffConfig`                                                                                                                                                                    |
| **Metering** | `POST /metering/billingMeters`, `POST /metering/billing/{accountId}`, `GET /metering/{metercode}/billingMeter`, `DELETE metering/{meterCode}/billingMeter`                                                                                                                           |
| **Catalog — Products** | `GET /catalog/product/all`, `GET /catalog/{productName}/plansPerProduct`, `DELETE /catalog/product/{productName}/deleteProduct?force=true`                                                                                                                                           |
| **Catalog — Plans** | `POST /catalog/inputData` (create plan+product+pricelist together), `POST /catalog/plan`, `GET /catalog/plan/all`, `GET /catalog/{planName}/plan`, `PUT /catalog/{planName}/updatePlan`, `DELETE /catalog/{planName}/retirePlan`, `DELETE /catalog/{planName}/deletePlan?force=true` |
| **Catalog — Info** | `GET /catalog/info` — returns whether tenant uses `CATALOG_STATE_XML` or `CATALOG_STATE_AVIATE`                                                                                                                                                                                      |
| **Health** | `GET /health/data`, `GET /health/metrics`, `GET /health/bus/failed`, `GET /health/notifications/failed`, `GET /health/diagnostic`, `PUT health/bus/failed`, `PUT health/notifications/failed`                                                                                        |
| **Coupons** | `POST /coupon`, `GET /coupon`, `GET /coupon/redemptionCode/{redemptionCode}`, `PUT /coupon/{redemptionCode}/archive`                                                                                                                                                                 |
| **Tax config** | `POST /1.0/kb/tenants/uploadPluginConfig/aviate-plugin` (core endpoint, `Content-Type: text/plain`, YAML body)                                                                                                                                                                       | 

### CLI / tooling quick commands

```bash
# Plugin installation via KPM
kpm install_java_plugin killbill-stripe --destination=/var/tmp/bundles

# Generating diagnostic file via kpm
kpm diagnostic --killbill-api-credentials=bob lazar --killbill-credentials admin password --account-export=ACCOUNT_ID

# Docker quick start
docker compose up
```

### Kill Bill setup

Kill Bill can be installed in several ways depending on the environment: a single-tier AWS AMI (quick trial/experimentation), a multi-tier AWS setup or CloudFormation templates (recommended for production), Docker/Docker Compose (local or cloud), or a manual Tomcat installation. See the [Getting Started guide](https://docs.killbill.io/latest/getting_started) for the install options and database DDL/setup steps. For the AWS setup options, see the [AWS doc](https://docs.killbill.io/latest/aws).  
Kill Bill needs a database, MySQL is the most commonly used/tested, PostgreSQL and MariaDB are also supported. For Docker Compose and the AWS options, this is typically handled by the provided compose file/AMI rather than done manually. For Tomcat installs, the Kill Bill schema needs to be created manually using [this DDL](https://docs.killbill.io/latest/ddl.sql) for the schema creation and table setup.

---

### Kaui setup

Kaui runs as a separate Rails-based admin app in front of the Kill Bill server. It needs its own database tables. For Docker Compose and the AWS options, this is typically handled by the provided compose file/AMI. In case of manul Tomcat installation, it can be created using [this DDL](https://github.com/killbill/killbill-admin-ui/blob/master/db/ddl.sql) . Kaui also needs to be configured to point to the Kill Bill API URL, and the Kaui database.
See the [Getting Started guide](https://docs.killbill.io/latest/getting_started) for full install/config steps (WAR setup, database DDL, environment variables).

---

### Aviate setup

Once Kill Bill (and Kaui) are running, connecting the instance to Aviate is optional.

Aviate is available in multiple plan tiers (Entourage, Growth, Flock, Finance), each unlocking progressively more capability — but for setup purposes, the key distinction is simpler: **shared sandbox vs. self-hosted deployment**.

- **Free/sandbox users** get access to a shared Aviate sandbox with the plugin already installed and running — no setup required, just log in at [aviate.killbill.io](https://aviate.killbill.io) and start configuring.
- **Paid tier users** (Growth and above, since the Aviate plugin runtime itself is a Growth-tier-and-up capability) connect their own Kill Bill deployment instead: add a custom deployment (URL + credentials) via the Aviate UI, then install the Aviate plugin onto that instance directly from the UI. See [Aviate Deployment Management Guide](https://docs.killbill.io/latest/aviate-deployment-management)
---

### Environments

| Environment | Typical use | Notes |
| --- | --- | --- |
| **Local** | Development, quick experimentation, plugin testing | Manual Tomcat install with an H2 or MySQL/PostgreSQL backend |
| **Docker** | Development, faster setup, plugin testing | Uses `killbill/killbill` + `killbill/kaui` images via Docker/Docker Compose, typically with a MySQL/MariaDB container |
| **AWS single-tier** | Trial / experimentation | Everything (Kill Bill + Kaui + DB + nginx) bundled on one EC2 instance via AMI; fastest to spin up, not recommended for production |
| **AWS multi-tier** | Production | AMI-based, components split across tiers; more setup than CloudFormation but more control over the deployment |
| **AWS CloudFormation** | Production | Templated production deployment; less setup than multi-tier, less control in exchange |


---

## Aviate Features

### Catalog UI

The Aviate Catalog UI lets you create individual catalog entries (products, plans, price lists) directly — a finer-grained, more dynamic alternative to Kill Bill's open-source model, which requires a full new catalog version for any change.

**Behavioral notes:**
- **Create Product, Plan, Pricelist** creates all three together in one flow — product name, plan definition, and price.
- **Edit Plan** only updates a plan's *price* — other attributes like phase duration can't be changed this way — and always creates a new plan version; existing subscriptions stay on the old version.
- **Archive Plan** blocks new subscriptions on that plan but leaves existing subscriptions running.
- **Delete Plan / Delete Product** permanently removes it from the database — only safe for erroneously-created plans/products with no active subscriptions.
- **Duplicate Plan / Duplicate Product** clones an existing plan/product as a starting point that can be edited freely before saving as new — the way around Edit's price-only restriction.
- **Creating Usage Plans** involves defining a billing meter (how usage is tracked), configuring tiers/blocks, and assigning usage-based prices per block.

See [Aviate Catalog Guide](https://docs.killbill.io/latest/aviate-catalog-guide).


### Tax configuration

The Aviate Tax feature enables tax functionality within the Aviate plugin. It allows configuring country-specific tax codes, each tax code has a validity window. These tax codes can then be assigned to different products. When a subscription is created for a product with an associated tax code, the system automatically generates a tax invoice item based on the configured tax rate. 

**Behavioral notes:** 
- Aviate tax requires some tenant level configuration as documented [here](https://docs.killbill.io/latest/aviate-tax#_enabling_aviate_tax). This can be done via Aviate UI or using the plugin config API.
- Once configured, the Aviate Tax module resolves the applicable tax code by evaluating the invoice item's end date and the billing account's tax registration country. 
- For each product, multiple tax codes can be configured with different validity periods. 
- At invoice generation time, Aviate selects the tax code whose validity window includes the invoice item's end date and whose configured country matches the billing account's tax registration country. 
- If no matching tax code is found, no tax is applied. 

See [Aviate Tax](https://docs.killbill.io/latest/aviate-tax).

### Custom Invoice Sequencing

Replaces Kill Bill's default sequential invoice numbering (shared across accounts/tenants) with a configurable scheme. Also allows custom preview/suffix in HTML invoices/emails. 

**Behavioral notes:**
- Custom invoice sequencing requires some tenant level configuration as documented [here](https://docs.killbill.io/latest/aviate-custom-invoice-sequencing#_tenant_level_configuration). This can be done via Aviate UI or using the plugin config API.
- Once configured, subsequently generated invoices pick up the custom sequence automatically — no per-invoice action needed.
- If prefix/suffix is configured, it allows customization of the invoice number format. For example, a prefix of "INV-" and a suffix of "-2024" would result in invoice numbers like "INV-0001-2024" in the HTML invoice/emails.

See [Custom Invoice Sequencing](https://docs.killbill.io/latest/aviate-custom-invoice-sequencing).

### Wallet

A per-account prepaid credit pool. Configuration/management is done via **Kaui** (not the Aviate UI) or the API — there's no dedicated Wallet screen in Aviate itself.

**Behavioral notes:**
- Wallet can be created either via the `POST /plugins/aviate-plugin/v1/wallet` endpoint or via Kaui.
- Wallet credits can be added via the `PUT /plugins/aviate-plugin/v1/wallet/{walletId}/credit` endpoint.
- Wallet credits are consumed by usage-based invoicing.

**Other Notes:**
- `balance` vs. `liveBalance` — `liveBalance` is `balance` minus credits reserved for an invoice currently being generated; the two briefly diverge during invoicing and reconverge once it finalizes
- Credit Type can be `CREDIT_FREE` (credits given at no charge - no invoice or payment generated), `CREDIT_PAID` (credits purchased by the customer) and `CREDIT_USED` (credits consumed by usage-based invoicing).
- Top off modes can be `TOP_OFF_FIXED` (adds a fixed amount of credits regardless of the current balance) and `TOP_OFF_TARGET` (adds enough credits to bring the balance up to a target amount)

See [Aviate Wallet](https://docs.killbill.io/latest/aviate-wallet).

### Metering

Lets you record raw (non-aggregated) usage events, which Aviate queues, aggregates, and validates before feeding into Kill Bill's usage store for invoicing — an alternative to the core Kill Bill Usage API, which only accepts pre-aggregated data.

**Behavioral notes:**
- Billing meter can be created via the Aviate Catalog UI, as part of "Creating Usage Plans" (define the meter → configure tiers/blocks → assign prices → save), or directly via `POST /v1/metering/billingMeters` for a standalone meter.
- Usage events can be recorded via `POST /v1/metering/billing/{accountId}` or via Kaui.
- `aggregationType` defines how events roll up within a billing period — currently only `SUM` is supported.

**Other Notes:**
- Events within a single submission must have **ascending timestamps** — out-of-order events are rejected outright, and all usage points for a subscription must be submitted sequentially, not concurrently.
- `trackingId` on each event provides idempotency — resubmitting an event with the same `trackingId` is safe.
- Use **either** core Kill Bill Usage APIs (pre-aggregated) **or** Aviate Metering (raw events) per subscription — not both.
- Usage events are recorded regardless, but produce **no invoice line item** unless a catalog plan actually references the meter's code — this fails silently, not loudly.
- Deleting a meter that already has usage events requires `force=true`; without it, the API returns an error.

See [Aviate Metering](https://docs.killbill.io/latest/aviate-metering).

### Coupons

Reusable discount codes (fixed-amount or percentage-based) that customers redeem at subscription creation, applied automatically to the resulting invoice. API-only — no UI support currently.

**Behavioral notes:**
- Coupon can be created via `POST /coupon` endpoint
- Coupon can be redeemed by passing the coupon's `redemptionCode` as a `pluginProperty` (key **must** be exactly `aviate-redemption-code`) on the standard Kill Bill subscription creation call — there's no separate "redeem" endpoint.

**Other Notes:**
- `discountType` is `DISCOUNT_TYPE_FIXED` (requires `discountPrice` + `discountCurrency`) or `DISCOUNT_TYPE_PERCENTAGE` (requires `discountPercentage`) — omitting the required pair for the chosen type returns `400`.
- `planList` optionally scopes a coupon to specific plans; if a coupon is applied to a subscription whose plan isn't in the list, the coupon is **silently ignored** — no error, no discount, no line item.
- Coupons are archived (soft-deleted via `PUT /coupon/{code}/archive`), not hard-deleted.
- Only **one coupon applies per subscription** — applying multiple doesn't stack; combine into a single coupon or use Wallet credits instead if you need to stack discounts.
- Expired (`expirationDate` passed) or archived coupons are rejected at redemption time with an error — unlike the plan-mismatch case above, this one fails loudly.

See [Aviate Coupons](https://docs.killbill.io/latest/aviate-coupons).

### Managing deployments in the Aviate UI

Aviate can manage one or more Kill Bill instances ("deployments") from a single UI — add a deployment by providing its URL and credentials, and edit or delete it later as needed. Within a deployment, tenants can be added/removed. Once a deployment/tenant is added, catalog, tax, plugin, and other configuration for that instance can happen visually instead of via raw API calls. 

See [Aviate Deployment Management Guide](https://docs.killbill.io/latest/aviate-deployment-management).

### Plugin configuration UI

The Aviate UI's **Plugins** screen lets you configure installed plugins (e.g. payment gateways like Adyen) visually — select a plugin, fill in its config fields, save. 

### Health dashboard UI

Aviate Health is a purpose-built observability dashboard for billing operations (invoice failures, parked accounts, queue health) — not generic infrastructure monitoring. See the live dashboard for current metrics and visualizations; the underlying data is also available via API as documented in the Aviate resources and endpoints table. 

See [Aviate Health](https://docs.killbill.io/latest/aviate-health).


## Example scripts

Example end-to-end script(s) an agent can adapt and run, parameterized so the same script works across local, Docker, or deployed environments. Intended as a starting point for quick demos/scaffolding — review and harden (secret handling, idempotency, error recovery) before using in any shared or production environment.

### End-to-end: tenant → account → catalog plan → subscription → invoice check

**Parameters:**
- **Env**
   - `KB_URL` — Kill Bill base URL (e.g. `http://127.0.0.1:8080`)
   - `KB_USER` / `PASSWORD` — admin credentials for Basic Auth
   - `API_KEY` / `API_SECRET` — tenant credentials (chosen by the caller, not pre-existing)
- **Plan**
   - `PRODUCT_NAME` — product name (e.g. `Standard`)
   - `PLAN_NAME` — plan name (e.g. `gold-monthly`)
   - `CURRENCY` — billing currency (e.g. `USD`)
   - `PRICE` — recurring price (e.g. `10.00`)
   - `BILLING_PERIOD` — billing frequency (e.g. `MONTHLY`)

```bash
#!/usr/bin/env bash
set -euo pipefail

# --- Params ---
KB_URL="${KB_URL:-http://127.0.0.1:8080}"
KB_USER="${KB_USER:-admin}"
PASSWORD="${PASSWORD:-password}"
API_KEY="${API_KEY:-demo-tenant}"
API_SECRET="${API_SECRET:-demo-secret}"

PLAN_NAME="${PLAN_NAME:-standard-monthly}"
PRODUCT_NAME="${PRODUCT_NAME:-Standard}"
PRICE="${PRICE:-10.00}"
CURRENCY="${CURRENCY:-USD}"
BILLING_PERIOD="${BILLING_PERIOD:-MONTHLY}"

AUTH=(-u "${KB_USER}:${PASSWORD}")
TENANT_HEADERS=(-H "X-Killbill-ApiKey: ${API_KEY}" -H "X-Killbill-ApiSecret: ${API_SECRET}")
CREATED_BY=(-H "X-Killbill-CreatedBy: setup-script")

echo "=== Step 1: Create tenant (${API_KEY}) ==="
set +e
STATUS=$(curl -s -o /tmp/tenant_response.json -w "%{http_code}" -X POST "${AUTH[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"apiKey\": \"${API_KEY}\", \"apiSecret\": \"${API_SECRET}\"}" \
  "${KB_URL}/1.0/kb/tenants")
CURL_EXIT=$?
set -e
if [[ "${CURL_EXIT}" -ne 0 ]]; then
  echo "ERROR: curl failed to connect (exit code ${CURL_EXIT}). Is Kill Bill running and reachable at ${KB_URL}?"
  exit 1
fi
echo "HTTP status: ${STATUS}"
cat /tmp/tenant_response.json
echo
if [[ "${STATUS}" != "201" ]]; then
  echo "WARNING: expected 201 Created, got ${STATUS}. Response body above may explain why (e.g. tenant already exists)."
fi

echo
echo "=== Step 2: Create simple plan (${PLAN_NAME}) ==="
set +e
STATUS=$(curl -s -o /tmp/catalog_response.json -w "%{http_code}" -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"planId\": \"${PLAN_NAME}\", \"productName\": \"${PRODUCT_NAME}\", \"productCategory\": \"BASE\", \"currency\": \"${CURRENCY}\", \"amount\": ${PRICE}, \"billingPeriod\": \"${BILLING_PERIOD}\", \"trialLength\": 0, \"trialTimeUnit\": \"UNLIMITED\"}" \
  "${KB_URL}/1.0/kb/catalog/simplePlan")
CURL_EXIT=$?
set -e
if [[ "${CURL_EXIT}" -ne 0 ]]; then
  echo "ERROR: curl failed to connect (exit code ${CURL_EXIT})."
  exit 1
fi
echo "HTTP status: ${STATUS}"
cat /tmp/catalog_response.json
echo
if [[ "${STATUS}" != "201" ]]; then
  echo "WARNING: expected 201 Created, got ${STATUS}. Check the response above."
fi

echo
echo "=== Step 3: Create account ==="
set +e
STATUS=$(curl -s -D /tmp/account_headers.txt -o /tmp/account_response.json -w "%{http_code}" -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"Demo Customer\", \"currency\": \"${CURRENCY}\"}" \
  "${KB_URL}/1.0/kb/accounts")
CURL_EXIT=$?
set -e
if [[ "${CURL_EXIT}" -ne 0 ]]; then
  echo "ERROR: curl failed to connect (exit code ${CURL_EXIT})."
  exit 1
fi
echo "HTTP status: ${STATUS}"
cat /tmp/account_response.json
echo
ACCOUNT_ID=$(grep -i "^Location:" /tmp/account_headers.txt | sed -E 's#.*/accounts/([a-f0-9-]+).*#\1#i' | tr -d '\r')
if [[ -z "${ACCOUNT_ID}" ]]; then
  echo "ERROR: could not extract accountId. Aborting."
  exit 1
fi
echo "Created account: ${ACCOUNT_ID}"

echo
echo "=== Step 4: Create subscription (plan: ${PLAN_NAME}) ==="
set +e
STATUS=$(curl -s -o /tmp/sub_response.json -w "%{http_code}" -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"accountId\": \"${ACCOUNT_ID}\", \"planName\": \"${PLAN_NAME}\"}" \
  "${KB_URL}/1.0/kb/subscriptions")
CURL_EXIT=$?
set -e
if [[ "${CURL_EXIT}" -ne 0 ]]; then
  echo "ERROR: curl failed to connect (exit code ${CURL_EXIT})."
  exit 1
fi
echo "HTTP status: ${STATUS}"
cat /tmp/sub_response.json
echo
if [[ "${STATUS}" != "201" ]]; then
  echo "WARNING: expected 201 Created, got ${STATUS}. Subscription may not have been created."
fi

echo
echo "=== Step 5: Check invoices for account ${ACCOUNT_ID} ==="
sleep 2
curl -s "${AUTH[@]}" "${TENANT_HEADERS[@]}" \
  "${KB_URL}/1.0/kb/accounts/${ACCOUNT_ID}/invoices" | jq .

echo
echo "=== Done ==="
```

### Usage billing: tenant → usage-based catalog plan → account → subscription → record usage → dry-run invoice

**Parameters:**
- **Env**
    - `KB_URL` — Kill Bill base URL (e.g. `http://127.0.0.1:8080`)
    - `KB_USER` / `PASSWORD` — admin credentials for Basic Auth
    - `API_KEY` / `API_SECRET` — tenant credentials (chosen by the caller, not pre-existing)
- **Plan**
    - `PRODUCT_NAME` — product name (e.g. `ApiAccess`)
    - `PLAN_NAME` — plan name (e.g. `api-monthly`)
    - `CURRENCY` — billing currency (e.g. `USD`)
    - `BASE_PRICE` — flat recurring price charged regardless of usage (e.g. `20.00`)
    - `BILLING_PERIOD` — billing frequency (e.g. `MONTHLY`)
- **Usage**
    - `UNIT_NAME` — the metered unit type

````bash
#!/usr/bin/env bash
set -euo pipefail

# --- Params: Env ---
KB_URL="${KB_URL:-http://127.0.0.1:8080}"
KB_USER="${KB_USER:-admin}"
PASSWORD="${PASSWORD:-password}"
API_KEY="${API_KEY:-demo-usage-tenant}"
API_SECRET="${API_SECRET:-demo-secret}"

# --- Params: Plan ---
PLAN_NAME="${PLAN_NAME:-api-monthly}"
PRODUCT_NAME="${PRODUCT_NAME:-ApiAccess}"
CURRENCY="${CURRENCY:-USD}"
BASE_PRICE="${BASE_PRICE:-20.00}"
BILLING_PERIOD="${BILLING_PERIOD:-MONTHLY}"

# --- Params: Usage ---
UNIT_NAME="${UNIT_NAME:-api-calls}"
TIER1_MAX="${TIER1_MAX:-1000}"       # units included in the cheaper tier
TIER1_PRICE="${TIER1_PRICE:-0.01}"   # price per unit up to TIER1_MAX
TIER2_PRICE="${TIER2_PRICE:-0.005}"  # price per unit beyond TIER1_MAX

AUTH=(-u "${KB_USER}:${PASSWORD}")
TENANT_HEADERS=(-H "X-Killbill-ApiKey: ${API_KEY}" -H "X-Killbill-ApiSecret: ${API_SECRET}")
CREATED_BY=(-H "X-Killbill-CreatedBy: usage-demo-script")

# Helper: run a curl call, capture status + body, warn if not the expected code
run_curl() {
  local expected_status="$1"; shift
  local out_file="$1"; shift
  set +e
  local status
  status=$(curl -s -o "${out_file}" -w "%{http_code}" "$@")
  local exit_code=$?
  set -e
  if [[ "${exit_code}" -ne 0 ]]; then
    echo "ERROR: curl failed to connect (exit code ${exit_code}). Is Kill Bill running and reachable at ${KB_URL}?"
    exit 1
  fi
  echo "HTTP status: ${status}"
  cat "${out_file}"
  echo
  if [[ "${status}" != "${expected_status}" ]]; then
    echo "WARNING: expected ${expected_status}, got ${status}. See response above."
  fi
}

echo "=== Step 1: Create tenant (${API_KEY}) ==="
run_curl 201 /tmp/tenant_response.json \
  -X POST "${AUTH[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"apiKey\": \"${API_KEY}\", \"apiSecret\": \"${API_SECRET}\"}" \
  "${KB_URL}/1.0/kb/tenants"

echo
echo "=== Step 2: Upload catalog with usage plan (${PLAN_NAME}, unit: ${UNIT_NAME}) ==="
cat > /tmp/usage_catalog.xml <<XML_EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<catalog xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="CatalogSchema.xsd">
  <effectiveDate>2026-01-01T00:00:00+00:00</effectiveDate>
  <catalogName>UsageDemoCatalog</catalogName>
   <recurringBillingMode>IN_ARREAR</recurringBillingMode>
  <currencies>
    <currency>${CURRENCY}</currency>
  </currencies>
  <units>
    <unit name="${UNIT_NAME}"/>
  </units>
  <products>
    <product name="${PRODUCT_NAME}">
      <category>BASE</category>
    </product>
  </products>
  <rules>
    <changePolicy>
      <changePolicyCase>
        <policy>END_OF_TERM</policy>
      </changePolicyCase>
    </changePolicy>
    <cancelPolicy>
      <cancelPolicyCase>
        <policy>END_OF_TERM</policy>
      </cancelPolicyCase>
    </cancelPolicy>
   </rules>
  <plans>
    <plan name="${PLAN_NAME}">
      <product>${PRODUCT_NAME}</product>
	  <initialPhases></initialPhases>
      <finalPhase type="EVERGREEN">
        <duration>
          <unit>UNLIMITED</unit>
        </duration>
        <recurring>
          <billingPeriod>${BILLING_PERIOD}</billingPeriod>
          <recurringPrice>
            <price>
              <currency>${CURRENCY}</currency>
              <value>${BASE_PRICE}</value>
            </price>
          </recurringPrice>
        </recurring>
        <usages>
          <usage name="${PLAN_NAME}-usage" billingMode="IN_ARREAR" usageType="CONSUMABLE">
            <billingPeriod>${BILLING_PERIOD}</billingPeriod>
            <tiers>
              <tier>
                <blocks>
                  <tieredBlock>
                    <unit>${UNIT_NAME}</unit>
                    <size>1</size>
                    <prices>
                      <price>
                        <currency>${CURRENCY}</currency>
                        <value>${TIER1_PRICE}</value>
                      </price>
                    </prices>
                    <max>${TIER1_MAX}</max>
                  </tieredBlock>
                </blocks>
              </tier>
              <tier>
                <blocks>
                  <tieredBlock>
                    <unit>${UNIT_NAME}</unit>
                    <size>1</size>
                    <prices>
                      <price>
                        <currency>${CURRENCY}</currency>
                        <value>${TIER2_PRICE}</value>
                      </price>
                    </prices>
                    <max>10000000</max>
                  </tieredBlock>
                </blocks>
              </tier>
            </tiers>
          </usage>
        </usages>
      </finalPhase>
    </plan>
  </plans>
  <priceLists>
    <defaultPriceList name="DEFAULT">
      <plans>
        <plan>${PLAN_NAME}</plan>
      </plans>
    </defaultPriceList>
  </priceLists>
</catalog>
XML_EOF

run_curl 201 /tmp/catalog_response.json \
  -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: text/xml" \
  --data-binary @/tmp/usage_catalog.xml \
  "${KB_URL}/1.0/kb/catalog/xml"

echo
echo "=== Step 3: Create account ==="
STATUS_TMP=/tmp/account_headers.txt
set +e
STATUS=$(curl -s -D "${STATUS_TMP}" -o /tmp/account_response.json -w "%{http_code}" \
  -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"Usage Demo Customer\", \"currency\": \"${CURRENCY}\"}" \
  "${KB_URL}/1.0/kb/accounts")
CURL_EXIT=$?
set -e
if [[ "${CURL_EXIT}" -ne 0 ]]; then
  echo "ERROR: curl failed to connect (exit code ${CURL_EXIT})."
  exit 1
fi
echo "HTTP status: ${STATUS}"
cat /tmp/account_response.json
echo
ACCOUNT_ID=$(grep -i "^Location:" "${STATUS_TMP}" | sed -E 's#.*/accounts/([a-f0-9-]+).*#\1#i' | tr -d '\r')
if [[ -z "${ACCOUNT_ID}" ]]; then
  echo "ERROR: could not extract accountId. Aborting."
  exit 1
fi
echo "Created account: ${ACCOUNT_ID}"

echo
echo "=== Step 4: Create subscription (plan: ${PLAN_NAME}) ==="
run_curl 201 /tmp/sub_headers.json \
  -D /tmp/sub_headers.txt \
  -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"accountId\": \"${ACCOUNT_ID}\", \"planName\": \"${PLAN_NAME}\"}" \
  "${KB_URL}/1.0/kb/subscriptions"
SUBSCRIPTION_ID=$(grep -i "^Location:" /tmp/sub_headers.txt | sed -E 's#.*/subscriptions/([a-f0-9-]+).*#\1#i' | tr -d '\r')
echo "Created subscription: ${SUBSCRIPTION_ID}"

echo
echo "=== Step 5: Record usage events (unit: ${UNIT_NAME}) ==="
USAGE_AMOUNT="${USAGE_AMOUNT:-1200}"  # deliberately > TIER1_MAX to exercise both tiers
TODAY=$(date +%F)
run_curl 201 /tmp/usage_response.json \
  -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"subscriptionId\": \"${SUBSCRIPTION_ID}\", \"unitUsageRecords\": [{\"unitType\": \"${UNIT_NAME}\", \"usageRecords\": [{\"recordDate\": \"${TODAY}\", \"amount\": ${USAGE_AMOUNT}}]}]}" \
  "${KB_URL}/1.0/kb/usages"
echo "Recorded ${USAGE_AMOUNT} units of ${UNIT_NAME} on ${TODAY}"

echo
echo "=== Step 6: Dry-run invoice preview (shows accrued usage charge) ==="
curl -s "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  "${KB_URL}/1.0/kb/invoices/dryRun?accountId=${ACCOUNT_ID}&targetDate=$(date -d '+1 month' +%F 2>/dev/null || date -v+1m +%F)" \
  -X POST -H "Content-Type: application/json" -d "{\"dryRunType\": \"TARGET_DATE\"}" | jq .

echo
echo "=== Done ==="
echo "Note: the dry-run above may show \$0 usage if the current billing period hasn't closed yet;"
echo "consumable-in-arrear usage is only billed at the END of its billing period."
````

### Aviate Catalog: tenant -> aviate catalog plan -> account -> subscription -> invoice

````bash
#!/usr/bin/env bash
set -euo pipefail

# --- Params: Env ---
KB_URL="${KB_URL:-http://127.0.0.1:8080}"
KB_USER="${KB_USER:-admin}"
PASSWORD="${PASSWORD:-password}"
API_KEY="${API_KEY:-demo-aviate-tenant}"
API_SECRET="${API_SECRET:-demo-secret}"

# --- Params: Aviate account (used to obtain the JWT ID token) ---
AVIATE_EMAIL="${AVIATE_EMAIL:?Set AVIATE_EMAIL to your Aviate login email}"
AVIATE_PASSWORD="${AVIATE_PASSWORD:?Set AVIATE_PASSWORD to your Aviate login password}"

# --- Params: Plan ---
PLAN_NAME="${PLAN_NAME:-premium-monthly}"
PRODUCT_NAME="${PRODUCT_NAME:-Premium}"
PRICELIST_NAME="${PRICELIST_NAME:-DEFAULT}"
CURRENCY="${CURRENCY:-USD}"
PRICE="${PRICE:-15.00}"
BILLING_PERIOD="${BILLING_PERIOD:-MONTHLY}"

# NOTE: this script assumes the tenant/KB instance already has the Aviate
# Catalog plugin enabled (com.killbill.billing.plugin.aviate.enableCatalogApis=true
# set at KB startup) -- this is a system property, not something this script
# can toggle at runtime. See "Setting up Aviate" in the skill doc.

AUTH=(-u "${KB_USER}:${PASSWORD}")
TENANT_HEADERS=(-H "X-Killbill-ApiKey: ${API_KEY}" -H "X-Killbill-ApiSecret: ${API_SECRET}")
CREATED_BY=(-H "X-Killbill-CreatedBy: aviate-catalog-demo-script")

run_curl() {
  local expected_status="$1"; shift
  local out_file="$1"; shift
  set +e
  local status
  status=$(curl -s -o "${out_file}" -w "%{http_code}" "$@")
  local exit_code=$?
  set -e
  if [[ "${exit_code}" -ne 0 ]]; then
    echo "ERROR: curl failed to connect (exit code ${exit_code}). Is Kill Bill running and reachable at ${KB_URL}?"
    exit 1
  fi
  echo "HTTP status: ${status}"
  cat "${out_file}"
  echo
  if [[ "${status}" != "${expected_status}" ]]; then
    echo "WARNING: expected ${expected_status}, got ${status}. See response above."
  fi
}

echo "=== Step 1: Create tenant (${API_KEY}) ==="
run_curl 201 /tmp/tenant_response.json \
  -X POST "${AUTH[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"apiKey\": \"${API_KEY}\", \"apiSecret\": \"${API_SECRET}\"}" \
  "${KB_URL}/1.0/kb/tenants"

echo
echo "=== Step 2: Obtain Aviate JWT ID token ==="
set +e
STATUS=$(curl -s -o /tmp/auth_response.json -w "%{http_code}" \
  -X POST \
  -H "Content-Type: application/json" \
  -u "${AVIATE_EMAIL}:${AVIATE_PASSWORD}" \
  "${TENANT_HEADERS[@]}" \
  "${KB_URL}/plugins/aviate-plugin/v1/auth")
CURL_EXIT=$?
set -e
if [[ "${CURL_EXIT}" -ne 0 ]]; then
  echo "ERROR: curl failed to connect (exit code ${CURL_EXIT})."
  exit 1
fi
echo "HTTP status: ${STATUS}"
cat /tmp/auth_response.json
echo
if [[ "${STATUS}" != "200" ]]; then
  echo "ERROR: expected 200, got ${STATUS}. Cannot continue without a valid ID token."
  exit 1
fi
ID_TOKEN=$(grep -o '"token"[[:space:]]*:[[:space:]]*"[^"]*"' /tmp/auth_response.json | sed -E 's/.*"token"[[:space:]]*:[[:space:]]*"([^"]*)"/\1/')
if [[ -z "${ID_TOKEN}" ]]; then
  echo "ERROR: could not extract token from auth response. Aborting."
  exit 1
fi
echo "Obtained ID token (length: ${#ID_TOKEN} chars)"
AVIATE_AUTH_HEADER=(-H "Authorization: Bearer ${ID_TOKEN}")

echo
echo "=== Step 3: Create plan/product/pricelist via Aviate Catalog ==="
EFFECTIVE_DATE=$(date -u +%Y-%m-%dT%H:%M:%S+00:00)
cat > /tmp/aviate_catalog_input.json <<JSON_EOF
{
  "plans": [
    {
      "name": "${PLAN_NAME}",
      "prettyName": "${PLAN_NAME}",
      "recurringBillingMode": "IN_ADVANCE",
      "pricelistName": "${PRICELIST_NAME}",
      "productName": "${PRODUCT_NAME}",
      "effectiveDate": "${EFFECTIVE_DATE}",
      "phases": [
        {
          "prettyName": "${PLAN_NAME}-evergreen",
          "type": "EVERGREEN",
          "durationUnit": "UNLIMITED",
          "durationLength": -1,
          "recurringPrices": {
            "billingPeriod": "${BILLING_PERIOD}",
            "prices": [
              { "currency": "${CURRENCY}", "value": "${PRICE}" }
            ]
          }
        }
      ]
    }
  ],
  "products": [
    { "name": "${PRODUCT_NAME}", "category": "BASE" }
  ]
}
JSON_EOF

run_curl 201 /tmp/aviate_catalog_response.json \
  -X POST "${AVIATE_AUTH_HEADER[@]}" "${TENANT_HEADERS[@]}" \
  -H "Content-Type: application/json" \
  -d @/tmp/aviate_catalog_input.json \
  "${KB_URL}/plugins/aviate-plugin/v1/catalog/inputData"

echo
echo "=== Step 4: Create account ==="
STATUS_TMP=/tmp/account_headers.txt
set +e
STATUS=$(curl -s -D "${STATUS_TMP}" -o /tmp/account_response.json -w "%{http_code}" \
  -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"Aviate Catalog Demo Customer\", \"currency\": \"${CURRENCY}\"}" \
  "${KB_URL}/1.0/kb/accounts")
CURL_EXIT=$?
set -e
if [[ "${CURL_EXIT}" -ne 0 ]]; then
  echo "ERROR: curl failed to connect (exit code ${CURL_EXIT})."
  exit 1
fi
echo "HTTP status: ${STATUS}"
cat /tmp/account_response.json
echo
ACCOUNT_ID=$(grep -i "^Location:" "${STATUS_TMP}" | sed -E 's#.*/accounts/([a-f0-9-]+).*#\1#i' | tr -d '\r')
if [[ -z "${ACCOUNT_ID}" ]]; then
  echo "ERROR: could not extract accountId. Aborting."
  exit 1
fi
echo "Created account: ${ACCOUNT_ID}"

echo
echo "=== Step 5: Create subscription (plan: ${PLAN_NAME}) ==="
run_curl 201 /tmp/sub_response.json \
  -D /tmp/sub_headers.txt \
  -X POST "${AUTH[@]}" "${TENANT_HEADERS[@]}" "${CREATED_BY[@]}" \
  -H "Content-Type: application/json" \
  -d "{\"accountId\": \"${ACCOUNT_ID}\", \"planName\": \"${PLAN_NAME}\"}" \
  "${KB_URL}/1.0/kb/subscriptions"

echo
echo "=== Step 6: Verify invoice for account ${ACCOUNT_ID} ==="
sleep 2
curl -s "${AUTH[@]}" "${TENANT_HEADERS[@]}" \
  "${KB_URL}/1.0/kb/accounts/${ACCOUNT_ID}/invoices" | jq .

echo
echo "=== Done ==="
echo "Note: catalog retrieval always goes through the standard Kill Bill catalog"
echo "API (GET /1.0/kb/catalog), even for an Aviate-managed catalog -- there is"
echo "no separate Aviate endpoint for reading the full catalog back out."
````

## Decision guidance

### When to use API vs Kaui vs plugin

| Scenario | Use API | Use Kaui | Use Plugin |
| --- | --- | --- | --- |
| Programmatic integration, backend systems | ✓ | | |
| Manual admin tasks, support investigations | | ✓ | |
| Custom payment gateway integration | | | ✓ |
| Custom tax logic or external tax engine | | | ✓ |
| Scripting and automation | ✓ | | |
| One-off catalog or tenant config changes | ✓ | ✓ | |

### Core Kill Bill vs. Aviate (when both offer overlapping capability)

| Use case | Core Kill Bill | Aviate |
| --- | --- | --- |
| Catalog changes are infrequent, versioned as a whole | Catalog XML upload | |
| Catalog needs frequent, granular, per-plan changes without full re-versioning | | Catalog UI/API |
| Usage data arrives already pre-aggregated | Usage API (`/1.0/kb/usages`) | |
| Usage data arrives as raw, high-volume events needing aggregation | | Metering API |
| Account credit is a simple one-off adjustment | Invoice item credit | |
| Prepaid credit pool with auto top-off, expiration, and ledger tracking | | Wallet |
| Need reusable, redeemable discount codes | *(no core equivalent)* | Coupons |
| Plugin configuration is a one-off or scripted setup | Per-tenant config API / `killbill.properties` | |
| Plugin configuration is done interactively, across multiple plugins | | Plugin configuration UI |
| Default sequential invoice numbering, shared across accounts/tenant, is fine | Default behavior | |
| Need custom invoice numbering (prefix/suffix, per-account or per-tenant scope) | *(no core equivalent)* | Custom Invoice Sequencing |
| Need visibility into system health (invoice failures, parked accounts, queue health) | *(no core equivalent — no built-in dashboard)* | Health dashboard/API |
| Tax computed via an external tax provider/plugin (e.g. AvaTax) | Tax plugin | |
| Tax computed by a built-in engine with product-level code association | | Tax |

### When to use subscription vs one-off invoice item

| Use case | Subscription (catalog plan) | One-off invoice item |
| --- | --- | --- |
| Recurring monthly/annual billing | ✓ | |
| Fixed platform fee + usage charges | ✓ | |
| One-time onboarding or implementation fee | | ✓ |
| Ad-hoc credit or adjustment | | ✓ |
| Refund via credit note | | ✓ |


### Pricing models 

| Billing mode | Supported pricing models |
| --- | --- |
| **Usage — consumable (in-arrear)** | Tiered blocks, per-unit tiers |
| **Usage — capacity (in-advance)** | Fixed capacity tiers |
| **Recurring** | Fixed price, price list overrides |

---

## Workflow

### Installing Kill Bill

1. **Pick a deployment path** — Local Tomcat, Docker/Docker Compose, AWS single-tier, AWS multi-tier, AWS CloudFormation (see Environments table above)
2. **Provision the database** — Create the Kill Bill schema (MySQL recommended; PostgreSQL and MariaDB also supported) and load the Kill Bill DDL. For Docker Compose and the AWS options, this is typically handled by the provided compose file/AMI rather than done manually
3. **Configure the database connection** — Set `killbill.dao.url` / `KILLBILL_DAO_URL` (and user/password) via `killbill.properties`, environment variables, or Docker env vars
4. **Get the Kill Bill server running** — Tomcat installs need the WAR deployed explicitly; Docker uses the prebuilt `killbill/killbill` image directly; AWS AMI/CloudFormation options already bundle the server, so this step is just starting the stack
5. **Install required default bundles/plugins** — `kpm pull_defaultbundles`, plus any payment/tax/notification plugins needed (`kpm install_java_plugin <plugin-key>`); not needed if the AMI/image already includes them
6. **Configure payment plugins** — Set plugin-specific properties (API keys, merchant IDs) via per-tenant config or `killbill.properties`
7. **Set up Kaui** — For Tomcat: provision the separate Kaui database and deploy the Kaui WAR. For Docker: run the `killbill/kaui` image. For AWS: already bundled. In all cases, point Kaui at the Kill Bill API URL and admin credentials (see Kaui setup section)
8. **Start the platform** — Bring up Kill Bill, Kaui, and the database (in that dependency order for Docker Compose; already running as one stack for AWS AMI options)
9. **Create a tenant** — Either via Kaui's tenant screen or `POST /1.0/kb/tenants`, capturing the API key/secret
10. **Verify installation** — Confirm Kill Bill responds on `/1.0/kb/accounts`, Kaui logs in and shows the tenant, and a test account/subscription can be created end-to-end


### Managing subscriptions

1. **Create accounts** — `POST /1.0/kb/accounts` with name, currency, and country; verify with `GET`
2. **Create subscriptions** — `POST /1.0/kb/subscriptions` against a valid catalog `planName` (or `productName` + `billingPeriod` + `priceList`), tied to a bundle (`externalKey` optional)
3. **Change plans** — `PUT /1.0/kb/subscriptions/{subscriptionId}` with the new plan; specify `billingPolicy` (immediate vs. end-of-term) and confirm proration behavior against the catalog's change rules
4. **Cancel subscriptions** — `DELETE /1.0/kb/subscriptions/{subscriptionId}` with `entitlementPolicy`/`billingPolicy` (`IMMEDIATE` vs `END_OF_TERM`); note add-ons vs. base plan cancellation rules
5. **Pause or resume billing** — Use entitlement block/unblock APIs (`PUT /1.0/kb/subscriptions/{subscriptionId}/block`) or account-level blocking to suspend billing without cancelling the subscription
6. **Configure billing alignment** — Set `billingAlignment` (account, bundle, or subscription) in the catalog to control how billing dates line up across multiple subscriptions in a bundle
7. **Configure billing rules** — Define plan change rules, cancellation policies, and alignment rules in the catalog XML's `<planRules>` section


### Catalog configuration (XML)

1. **Create products** — Define `<product>` entries in the catalog XML with a name and category (base, add-on, standalone)
2. **Create plans** — Define `<plan>` entries linking a product to one or more phases (trial, discount, evergreen)
3. **Create phases** — Configure phase type, duration, and price for each plan phase
4. **Configure price lists** — Group plans into `<priceList>` blocks to support different pricing tiers for the same products
5. **Configure usage sections** — Add `<usage>` blocks (consumable/in-arrear or capacity/in-advance) with tiers and blocks for metered pricing
6. **Configure billing rules** — Set up `<planRules>` for allowed plan changes, cancellation policies, and billing alignment
7. **Validate XML catalogs** — Check the catalog via the Catalog validation API; test in sandbox first since catalog changes can affect subscriptions on active plans
8. **Upload the catalog** — `POST /1.0/kb/catalog/xml` per tenant, or use the Kaui catalog interface for simpler catalogs built directly in the UI

> If Aviate is available (Growth tier and above), steps 1–4, and 8 above can instead be done via the Aviate Catalog UI/API at the individual plan/product level without managing full catalog versions — see Aviate Features and the Core Kill Bill vs. Aviate decision table above.


### Payments

1. **Configure payment gateways** — Install and configure the relevant payment plugin (Stripe, Adyen, PayPal, etc.) via Aviate, KPM, or Kaui, setting gateway credentials in per-tenant or global config
2. **Add payment methods** — `POST /1.0/kb/accounts/{accountId}/paymentMethods`, marking one as default per account
3. **Process payments** — `POST /1.0/kb/accounts/{accountId}/payments` (or let invoicing trigger automatic payment against the default method)
4. **Retry failed payments** — Configure the payment retry rules so failed payments are automatically retried rather than left unresolved
5. **Configure payment control plugins** — Distinguish Payment Plugins (talk to the gateway) from Payment Control Plugins (intercept/authorize/route payment attempts before they reach the gateway, e.g. for fraud checks or custom routing like Evervault Relay)
6. **Troubleshoot payment failures** — Check the payment's transaction history and audit log, gateway-specific error codes, and plugin logs; confirm the payment method and account currency match


### Plugin development

1. **Build Java plugins** — Scaffold from the `killbill-plugin-framework-java`, implementing the relevant plugin API interface (Payment, Invoice, Currency, Notification, etc.)
2. **Implement plugin APIs** — Implement the specific OSGI service interface for your plugin type (e.g. `PaymentPluginApi`, `InvoicePluginApi`) and register it as an OSGI service
3. **Register servlets** — Expose custom HTTP endpoints by creating and registering a servlet
4. **Register listeners** — Create notification plugins by registering listeners that react to events like `INVOICE_CREATION`, `PAYMENT_SUCCESS`, or `OVERDUE_CHANGE`
5. **Register payment APIs** — Create payment plugins by registering classes that implement the `PaymentPluginApi`
6. **Configure OSGI bundles** — Package the plugin as an OSGI bundle with correct manifest metadata; deploy via Aviate, KPM (`kpm install_java_plugin`) or Kaui so it's picked up on Kill Bill startup
7. **Debug plugin issues** — Check plugin-specific logs, confirm correct tenant context resolution on each request (a common source of cross-tenant bugs), and verify the bundle registered successfully via `kpm inspect`

### REST APIs

1. **Identify the resource and operation** — Map the request to a Kill Bill resource (account, subscription, invoice, payment, etc.) and HTTP verb (`POST` create, `GET` read, `PUT` update, `DELETE` remove/cancel)
2. **Show the example request** — Include the full `curl` command with method, headers (`X-Killbill-ApiKey`, `X-Killbill-ApiSecret`, `X-Killbill-CreatedBy` for mutations), and JSON body where relevant
3. **Explain required path parameters** — Call out resource IDs (`{accountId}`, `{subscriptionId}`, `{invoiceId}`, etc.) and any required query parameters (e.g. `dryRun`, `targetDate`, `requestedDate`)
4. **Explain the request body** — Walk through required vs. optional fields (e.g. `name`/`currency` for accounts, `planName` vs. `productName`+`billingPeriod`+`priceList` for subscriptions)
5. **Explain the expected response** — Note the success status code (`200`/`201`/`204`), what's returned in the body vs. headers (e.g. new resource ID in the `Location` header), and common error codes (`400` bad request, `401` auth, `404` not found, `500` server/gateway error)
6. **Reference the appropriate API documentation** — Point to the specific endpoint page or the Swagger/REST API reference rather than restating the whole spec

---

### Setting up Aviate

**Path A — Sandbox (Free tier)**

1. **Log in** at [aviate.killbill.io](https://aviate.killbill.io) — shared sandbox instance, Aviate plugin pre-installed, no setup required
2. **Work through the Get Started checklist** — Company Settings → Catalog → Tax
3. **Switch to Kaui** for day-to-day billing operations

**Path B — Self-hosted (your own Kill Bill deployment)**

1. **Log in** at [aviate.killbill.io](https://aviate.killbill.io)
2. **Upgrade your plan:**
    - **Entourage** — add one local deployment; manage XML catalog and tenant settings via the Aviate UI (no Aviate plugin features)
    - **Growth or above** — add deployment(s), install the Aviate plugin, and unlock the full Aviate feature set (Catalog UI/API, Metering, Wallet, Coupons, Custom Invoice Sequencing, Health)
3. **Add a local deployment** — provide your Kill Bill instance's URL and credentials (API key, API secret, admin user) via the Aviate UI
4. **(Growth+ only) Install the Aviate plugin** — done directly from the Aviate UI once the deployment is added
5. **(Growth+ only) Verify** — confirm the plugin shows green/`RUNNING` via Kaui's plugins screen, and that the Health dashboard is reporting data
6. **Use Aviate features** — Entourage: XML catalog and tenant settings only. Growth+: Catalog UI/API, Usage/Metering, Wallet, Coupons, Custom Invoice Sequencing, Health dashboard/API

### Creating catalog products/plans via Aviate

1. **Confirm tier and feature flag** — requires Growth tier or above.
2. **Create product + plan + pricelist together** — via the Aviate UI's "Create Product, Plan, Pricelist" screen (or `POST /catalog/inputData`), entering product name, plan definition, and price in one flow
3. **Add additional plans to the product as needed** — via Aviate UI's "Add New Plan," screen or the `/POST/catalog/plan` API. Configure appropriate phases (`DISCOUNT`, `EVERGREEN`, etc.)
4. **For usage-based plans** — define a billing meter, configure tiers/blocks, and assign usage-based prices per block
5. **Update a plan's price later** — via "Edit Plan"; note this only changes price (not phase duration or other attributes), and always creates a new plan version — existing subscriptions stay on the old version
6. **For changes beyond price** — use "Duplicate Plan/Product" to clone as a starting point, edit freely, then save as new, rather than trying to force it through Edit
7. **Retire a plan that's no longer sold** — use "Archive Plan"; blocks new subscriptions while existing ones keep running (reversible in spirit, unlike delete)
8. **Remove an erroneously-created plan/product with no active subscriptions** — use "Delete Plan/Product"; this is a hard, irreversible deletion from the database
9. **Verify** — retrieval always goes through the standard Kill Bill catalog API (`GET /1.0/kb/catalog`), even for an Aviate-managed catalog (see Aviate gotchas — there's no separate Aviate endpoint for full catalog reads)

### Configuring and using Aviate Tax

1. **Confirm tier and feature flag** — requires Growth tier or above.
2. **Configure tax codes and products** — via the Aviate UI or the per-tenant config API; define codes (`rate`, `startingOn`/`stoppingOn`, `country`) and associate each with the relevant products
3. **Create the account** — ensure the account's tax registration country is set correctly; tax only applies if it matches a code's `country`
4. **Create the subscription** — for a product with associated tax codes; the tax invoice item is generated automatically, no separate tax API call needed
5. **Verify** — check the generated invoice for the tax line item; if missing, check product-code association first (see Aviate gotchas — untaxed products fail silently, not loudly)

### Recording usage via Aviate Metering

1. **Confirm tier and feature flag** — requires Growth tier or above.
2. **Create a billing meter** — via the Aviate Catalog UI (as part of "Creating Usage Plans") or `POST /v1/metering/billingMeters`
3. **Create a catalog plan referencing the meter's code** — via the Catalog workflow above; without this, events record but nothing invoices
4. **Create the account and subscription** — standard flow, on the usage-based plan
5. **Record usage events** — `POST /v1/metering/billing/{accountId}`, events within a submission must have ascending timestamps
6. **Verify** — meter appears in `GET /v1/metering/billingMeters/all`; after the billing period closes, invoice shows a `USAGE` line item with the aggregated total (see Aviate Metering gotchas — usage recorded ≠ invoiced if the plan doesn't reference the meter)

## Common terminology

Understand these common Kill Bill concepts:

- **Account** — The top-level entity representing a customer; holds currency, billing address, and payment methods
- **Bundle** — A container grouping a base subscription and its add-ons together for billing/entitlement purposes
- **Subscription** — A single instance of a plan a customer is subscribed to, within a bundle
- **Entitlement** — The access/usage rights a customer has, tracked separately from billing; a subscription can lose billing (blocked) while entitlement continues, or vice versa
- **Product** — A sellable offering defined in the catalog (e.g. "Gold")
- **Plan** — A specific pricing/billing configuration for a product (e.g. "gold-monthly")
- **Phase** — A stage within a plan's lifecycle (trial, discount, evergreen), each with its own duration and price
- **Price List** — A named grouping of plans in the catalog, used to offer different pricing tiers for the same products
- **Catalog** — The XML configuration defining products, plans, phases, price lists, and business rules
- **BCD (Bill Cycle Day)** — The day of the month that invoice is created for an account. This is applicable only for month based billing periods (like `MONTHLY`, `QAUATERLY`, `ANNUAL`, etc.). It can be configured at the account level or overridden at the subscription level. 
- **Invoice** — A billing document generated for an account, composed of invoice items
- **Invoice Item** — A single line item on an invoice (recurring charge, usage charge, credit, adjustment, etc.)
- **Payment** — A transaction record representing money collected against one or more invoices
- **Payment Transaction** — A specific step within a payment (authorize, capture, purchase, refund, etc.)
- **Payment Method** — A stored, tokenized way to charge a customer (card, ACH, etc.) via a payment plugin
- **Tenant** — A logically isolated set of data/config within a Kill Bill instance, identified by API key/secret
- **Plugin** — An OSGI extension point for custom payment, invoice, tax, notification, or catalog logic
- **Overdue** — The state machine governing dunning/collection actions when invoices go unpaid
- **Usage Pricing** — Pricing a service or item based on its consumption or usage. 
- **Blocking State** — A mechanism to suspend entitlement/billing on an account, bundle, or subscription without cancelling it
- **Custom Field** — Arbitrary key/value metadata attached to a Kill Bill resource like account, bundle, subscription
- **Tag** — A property that can be added to objects (such as accounts, bundles or subscriptions)
- **Audit Log** — The history of who changed a resource, when, and why (via `CreatedBy`/`Reason`/`Comment`)
- **Aviate Deployment** — A Kill Bill instance connected to and managed through the Aviate UI (added via URL + credentials); Aviate can manage multiple deployments from one place
- **ID Token** — The JWT (`Authorization: Bearer ${ID_TOKEN}`) required by Aviate-specific API endpoints, in addition to standard Kill Bill tenant headers; obtained via the Aviate Auth API
- **Billing Meter** — An Aviate Metering concept defining what's measured for usage-based billing (name, code, `eventKey`, aggregation type); usage-based catalog plans reference a meter's code to pick up recorded events
- **Tax Code (Aviate)** — A country-scoped, time-bound tax rate definition (`rate`, `startingOn`/`stoppingOn`, `country`) associated with one or more products; the applicable code for a given invoice item is resolved automatically by matching the account country and item's end date against the tax code.
- **Wallet Balance** — A per-account prepaid credit pool (Aviate feature). Tracked as `balance` (total stored credits) and `liveBalance` (balance minus credits reserved for an invoice currently being generated — the two briefly diverge during invoicing and reconverge once it finalizes). 
- **Coupon** — A reusable, redeemable discount code (Aviate feature), applied at subscription creation or mid-cycle. Supports fixed-amount or percentage discounts, redemption limits, and optional scoping to specific plans; removed via archiving rather than hard deletion.

---

## Common gotchas

- **Multi-tenancy header mismatch** — Every request needs matching `X-Killbill-ApiKey` / `X-Killbill-ApiSecret` for the tenant; mixing tenants causes 401s or "resource not found" errors even when the ID is valid.
- **Missing `X-Killbill-CreatedBy`** — Mutating calls (POST/PUT/DELETE) fail without this header; it's required for audit logging.
- **Catalog validation errors on upload** — Catalog XML must be validated, otherwise it can break existing subscriptions on active plans.
- **Subscription not invoicing** — Verify the subscription is not blocked by a blocking state or overdue condition, has a valid catalog plan, and the billing/target date has actually passed.
- **Usage events outside the metering period** — Usage recorded with a timestamp outside the current billing period for the subscription won't appear on the current invoice.
- **Plugin tenant resolution issues** — Plugins must correctly resolve tenant context from request headers; missing tenant context causes cross-tenant data leaks or 404s.
- **Kaui pointing at wrong Kill Bill URL** — Kaui must be configured with the correct backend URL.
- **Catalog changes are versioned, not overwritten** — Uploading a new catalog creates a new version rather than mutating history; existing subscriptions keep the pricing/rules from the catalog version they were created under, so historical invoices aren't retroactively affected by later catalog edits.
- **Many configuration changes are tenant-specific** — Catalog, overdue rules, invoice/payment properties, and plugin config can all be set per-tenant via `uploadPerTenantConfig`; a change made under one tenant's API key/secret won't apply to others, and global `killbill.properties` values only act as a fallback when no per-tenant override exists.
- **Plugins execute independently from Kill Bill core** — OSGI plugins run in their own bundle context and can be installed/upgraded/restarted without redeploying the core server; a plugin crashing or misbehaving doesn't necessarily take down core Kill Bill functionality, but a plugin hanging (e.g. a slow payment gateway call) can block the request that invoked it.
- **Payment behavior depends on the configured payment plugin** — Retry logic, supported transaction types (authorize/capture vs. purchase), refund handling, and error code mapping all vary by which payment plugin is installed (Stripe, Adyen, Braintree, etc.); don't assume behavior that's specific to one gateway/plugin generalizes to another.
- **Invoice generation and payment processing are separate operations** — An invoice can be created without a payment being triggered (e.g. `AUTO_PAY_OFF`/`MANUAL_PAY` tags, no default payment method), and conversely a payment can be recorded manually against an invoice outside of the automatic flow; don't assume one implies the other completed.
- **Subscription changes may generate repair adjustments** — Plan changes or cancellations that fall mid-billing-cycle can trigger automatic invoice repair (credits/debits) to reconcile what was already invoiced against the new billing state, governed by the catalog's billing alignment and change rules; check the resulting invoice rather than assuming a clean prorated charge.
- **Always verify whether a feature belongs to Kill Bill core or requires a plugin** — Some capabilities that seem "built in" (tax calculation, certain payment retry strategies, invoice grouping, advanced usage aggregation) actually require a specific plugin to be installed and configured; check the plugin's own docs/config rather than assuming core Kill Bill provides it out of the box.
- **Aviate: catalog writes and reads use different endpoints** — once the Aviate Catalog plugin is enabled for a tenant, catalog *writes* go through Aviate endpoints (`/plugins/aviate-plugin/v1/catalog/...`), but catalog *reads* still always go through the standard Kill Bill catalog APIs (`GET /1.0/kb/catalog`) — there's no separate Aviate endpoint for full catalog retrieval.
- **Aviate: don't mix core Usage APIs and Metering for the same subscription** — use either the core Kill Bill Usage API (pre-aggregated data) *or* Aviate Metering (raw events) per subscription, not both; mixing them produces inconsistent or duplicated usage data.
- **Aviate: ID token required in addition to tenant headers** — Aviate-specific endpoints (Wallet, Metering, Health, Coupons, Catalog) need a JWT `Authorization: Bearer ${ID_TOKEN}` on top of the standard `X-Killbill-ApiKey`/`X-Killbill-ApiSecret` headers; a request with valid tenant headers but no token will still fail.
- **Aviate: Edit Plan requires resending every phase's price, not just the changed one** — the Modify Plan API (and its UI counterpart) requires all fixed and recurring prices to be resent for every phase on the plan, even ones that aren't changing; omitting an unchanged phase's price can unintentionally clear it.
- **Aviate: a missing feature may just be a tier limit, not a bug** — capabilities like Health monitoring, Wallet/Coupons, or quote-to-cash workflows are gated by plan tier (Entourage/Growth/Flock/Finance); check tier availability before assuming something is broken or missing.
- **Aviate Plugin fails to start after install** — a common cause is missing Aviate database tables; if using Flyway for migrations, check for migration errors first
- **Catalog plugin precedence** — Once the aviate plugin is installed, the Aviate-served catalog takes priority over anything created via the plain `/1.0/kb/catalog` APIs — don't assume standard catalog-upload behavior still applies.
- **Aviate: tax silently generates nothing if a product has no associated tax code** — unlike a validation error, an untaxed product just produces no tax invoice item; if tax seems "not working," check the `products` mapping in the tax config before assuming the rate/country/date logic is at fault.
- **Aviate: uploading tenant plugin config may overwrite unrelated settings** — Tax config and Custom Invoice Sequencing are both configured via the same `POST /1.0/kb/tenants/uploadPluginConfig/aviate-plugin` endpoint. Per Kill Bill's general per-tenant config behavior, each call replaces the *entire* config for that plugin, not just the section you're updating — updating tax config without also including existing invoice-sequencing config in the same payload risks wiping it.
- **Aviate Health can take remediation action, not just report** — beyond read-only metrics, Health exposes `PUT` endpoints to reinsert failed bus events/notifications back into the processing queue; treat these as mutating operations (test carefully, don't run against production data casually) rather than assuming the whole Health surface is passive monitoring.
---

## Verification checklist

Before submitting work:

- [ ] **Version-dependent behavior** — Confirm the behavior/endpoint in question is consistent with the Kill Bill version in use, since API and defaults can shift across versions
- [ ] **Required fields** — Account currency is valid, subscription plan/price list are set explicitly
- [ ] **Payment method** — Account has a default payment method if automatic charging is expected
- [ ] **Tags** — `AUTO_INVOICING_OFF`/`AUTO_INVOICING_DRAFT` tags are added/removed intentionally, not left over from testing
- [ ] **Response validation** — Check HTTP status (2xx success, 4xx client error, 5xx server error) and inspect audit logs for unexpected state

---

## Resources

**Comprehensive navigation:** https://docs.killbill.io

**Critical documentation pages:**
- [Getting started](https://docs.killbill.io/latest/getting_started)
- [Subscription and entitlement overview](https://docs.killbill.io/latest/userguide_subscription)
- [Plugin development](https://docs.killbill.io/latest/plugin_development)
- [Kaui admin UI](https://docs.killbill.io/latest/userguide_kaui)
- [Rest API Reference](https://apidocs.killbill.io)
- [Source Code](https://github.com/killbill)
- [Community](https://groups.google.com/g/killbilling-users)
- [Documentation Index](https://docs.killbill.io/llms.txt)

** Aviate Documentation:**

- [What is Aviate?](https://docs.killbill.io/latest/what_is_aviate)
- [Getting Started](https://docs.killbill.io/latest/aviate-getting-started)
- [How to Install the Aviate Plugin](https://docs.killbill.io/latest/how-to-install-the-aviate-plugin)
- [Aviate Catalog Guide](https://docs.killbill.io/latest/aviate-catalog-guide)
- [Aviate Metering](https://docs.killbill.io/latest/aviate-metering)
- [Aviate Wallet](https://docs.killbill.io/latest/aviate-wallet)
- [Aviate Tax](https://docs.killbill.io/latest/aviate-tax)
- [Aviate Health](https://docs.killbill.io/latest/aviate-health)
- [Aviate Changelog](https://docs.killbill.io/latest/aviate-changelog)
- [Usage Tutorial (AI use case)](https://docs.killbill.io/latest/aviate-usage-ai-tutorial)
- [Aviate Tax Tutorial](https://docs.killbill.io/latest/aviate-tax-tutorial)

---

