/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

ALTER TABLE aviate_invoice_sequences RENAME kb_account_id TO account_id;
ALTER TABLE aviate_invoice_sequences RENAME kb_tenant_id TO tenant_id;

ALTER TABLE aviate_billing_accounts RENAME kb_account_id TO account_id;
ALTER TABLE aviate_billing_accounts RENAME kb_tenant_id TO tenant_id;

ALTER TABLE aviate_orders RENAME kb_tenant_id TO tenant_id;
ALTER TABLE aviate_orders add account_id varchar(36) default null;

ALTER TABLE aviate_quotes RENAME kb_tenant_id TO tenant_id;
ALTER TABLE aviate_quotes add account_id varchar(36) default null;

ALTER TABLE aviate_tax_registrations RENAME kb_tenant_id TO tenant_id;
ALTER TABLE aviate_tax_registrations add account_id varchar(36) default null;

ALTER TABLE aviate_order_subscriptions RENAME kb_tenant_id TO tenant_id;
ALTER TABLE aviate_order_subscriptions add account_id varchar(36) default null;

ALTER TABLE aviate_quote_items RENAME kb_tenant_id TO tenant_id;
ALTER TABLE aviate_quote_items add account_id varchar(36) default null;
