---
name: Kill Bill
description: Use when working with the Kill Bill open source billing and payments platform. This skill helps with subscriptions, invoices, payments, catalog configuration, plugins, APIs, Kaui administration, tenant configuration, and Java plugin development.
metadata:
  version: "1.0"
---

# Kill Bill Skill

## Product summary

Kill Bill is an open-source subscription billing and payments platform. It handles account management, subscription/entitlement lifecycles, catalog-driven pricing, usage-based billing, invoicing, payments, and overdue/dunning. Kill Bill is highly extensible through plugins and supports multiple payment gateways, tax providers, notification systems, and custom business logic. Kaui is the companion admin UI for Kill Bill. Agents use Kill Bill to create and manage accounts, subscriptions, invoices, payments, and usage data through the REST API, the `killbill-client-java` (or other language) client libraries, or Kaui.

**Key entry points:**
- REST API: `http://<host>:8080/1.0/kb` (self-hosted; no shared public sandbox URL)
- Admin UI (Kaui): typically deployed at `http://<host>:9090`
- Client libraries: `killbill-client-java`, `killbill-client-python`, `killbill-client-ruby`, `killbill-client-js`
- Plugin manager (KPM): Used to install plugins using `kpm install_java_plugin <plugin-name>`
- Docker: `killbill/killbill` and `killbill/kaui` images
- - MCP server: `apidocs-mcp.killbill.io` — provides direct access to Kill Bill API documentation; can generate accurate, up-to-date API usage examples and scripts

**Authentication:** HTTP Basic Auth (`-u <username>:<password>`) plus required multi-tenancy headers `X-Killbill-ApiKey` and `X-Killbill-ApiSecret`. Every mutating call should also include `X-Killbill-CreatedBy` (and optionally `X-Killbill-Reason` / `X-Killbill-Comment`).

**Primary docs:** 
- https://docs.killbill.io
- https://apidocs.killbill.io

---

## When to use

Use this skill whenever users ask about:

- **Kill Bill installation or deployment** - Install Kill Bill in Tomcat, Docker or AWS
- **Account management** - Add new accounts, update billing information, manage addresses, currency, and payment methods
- **Subscription lifecycle** - Create bundles/subscriptions against catalog plans, handle plan changes, cancellations, pause/resume bundles/subscriptions
- **Catalog configuration** - Define products, plans, price lists, phases, and usage tiers in Kill Bill XML or Aviate catalog 
- **Invoices and invoice adjustments** - Trigger invoice runs, generate dry-run invoices, adjust/credit invoices, manage invoice items
- **Payments, payment methods and payment retries** - Configure payment plugins (Braintree, Stripe, Adyen, etc.), trigger payments/refunds, manage payment methods, payment retries
- **Usage billing** - Configure tiered usage in the catalog, record usage via the usage API
- **Tags and custom fields** — Attach system tags (e.g. `AUTO_INVOICING_OFF`) to control system behavior, or custom fields to store additional metadata on accounts, subscriptions, and invoices
- **Tenant configuration** — Set up per-tenant catalog, overdue, invoice and payment configuration; manage API keys/secrets and tenant-level feature flags
- **Handling overdue/dunning** — Configure overdue XML rules, enforce overdue logic
- **Querying billing data** — Look up accounts, bundles, subscriptions, invoices, payments, and audit history
- **Administering via Kaui** — Manage tenants, accounts, subscriptions, invoices, payments, users, permissions, and catalogs through the Kaui web UI
- **Extending via plugins** — Write or configure OSGI/Java plugins, notification plugins, payment plugins or other custom plugins
- **REST API usage** — Authenticate, construct multi-tenant headers, and call Kill Bill endpoints directly for custom integrations
- **Java client library** — Generate or use `killbill-client-java` to interact with the API from Java applications instead of raw HTTP calls
- **Troubleshooting Kill Bill behavior** — Diagnose unexpected invoice, payment, or subscription states using audit logs, bus events, and plugin logs


---

## General guidance

When answering questions:

1. On loading this skill, check whether an MCP connector for `apidocs-mcp.killbill.io` is available/connected. If it is not connected, ask the user whether they'd like to connect it before proceeding — it provides direct, current API documentation and can generate accurate code snippets, reducing reliance on this skill's own static examples or on web search.
2. Prefer official Kill Bill documentation over assumptions.
2. Mention version-specific behavior when relevant.
3. If multiple approaches exist, recommend the simplest supported approach first.
4. Prefer configuration over custom code when possible.
5. When discussing plugins, clearly distinguish between:
   - Kill Bill core
   - Kaui
   - Payment plugins
   - Notification plugins
   - Open source plugins (Like Stripe, Adyen, Braintree, etc.)
   - Private/Custom plugins
6. Use official REST API endpoints whenever applicable.
7. For Java development, prefer the supported Kill Bill plugin APIs rather than internal implementation classes.

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

### Environments

| Environment | Typical use | Notes |
| --- | --- | --- |
| **Local** | Development, quick experimentation, plugin testing | Manual Tomcat install with an H2 or MySQL/PostgreSQL backend |
| **Docker** | Development, faster setup, plugin testing | Uses `killbill/killbill` + `killbill/kaui` images via Docker/Docker Compose, typically with a MySQL/MariaDB container |
| **AWS single-tier** | Trial / experimentation | Everything (Kill Bill + Kaui + DB + nginx) bundled on one EC2 instance via AMI; fastest to spin up, not recommended for production |
| **AWS multi-tier** | Production | AMI-based, components split across tiers; more setup than CloudFormation but more control over the deployment |
| **AWS CloudFormation** | Production | Templated production deployment; less setup than multi-tier, less control in exchange |


---

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


### Catalog configuration

1. **Create products** — Define `<product>` entries in the catalog XML with a name and category (base, add-on, standalone)
2. **Create plans** — Define `<plan>` entries linking a product to one or more phases (trial, discount, evergreen)
3. **Create phases** — Configure phase type, duration, and price for each plan phase
4. **Configure price lists** — Group plans into `<priceList>` blocks to support different pricing tiers for the same products
5. **Configure usage sections** — Add `<usage>` blocks (consumable/in-arrear or capacity/in-advance) with tiers and blocks for metered pricing
6. **Configure billing rules** — Set up `<planRules>` for allowed plan changes, cancellation policies, and billing alignment
7. **Validate XML catalogs** — Check the catalog via the Catalog validation API; test in sandbox first since catalog changes can affect subscriptions on active plans
8. **Upload the catalog** — `POST /1.0/kb/catalog/xml` per tenant, or use the Kaui catalog interface for simpler catalogs built directly in the UI


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

---

