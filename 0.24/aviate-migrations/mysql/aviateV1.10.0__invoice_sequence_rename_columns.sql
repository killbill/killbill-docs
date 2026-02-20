/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

ALTER TABLE aviate_invoice_sequences CHANGE kb_account_id account_id char(36);
ALTER TABLE aviate_invoice_sequences CHANGE kb_tenant_id tenant_id char(36);

ALTER TABLE aviate_billing_accounts CHANGE kb_account_id account_id char(36);
ALTER TABLE aviate_billing_accounts CHANGE kb_tenant_id tenant_id char(36);

ALTER TABLE aviate_orders CHANGE kb_tenant_id tenant_id char(36);
ALTER TABLE aviate_orders add account_id char(36) default null;

ALTER TABLE aviate_quotes CHANGE kb_tenant_id tenant_id char(36);
ALTER TABLE aviate_quotes add account_id char(36) default null;

ALTER TABLE aviate_tax_registrations  CHANGE kb_tenant_id tenant_id char(36);
ALTER TABLE aviate_tax_registrations add account_id char(36) default null;

ALTER TABLE aviate_order_subscriptions  CHANGE kb_tenant_id tenant_id char(36);
ALTER TABLE aviate_order_subscriptions add account_id char(36) default null;

ALTER TABLE aviate_quote_items  CHANGE kb_tenant_id tenant_id char(36);
ALTER TABLE aviate_quote_items add account_id char(36) default null;