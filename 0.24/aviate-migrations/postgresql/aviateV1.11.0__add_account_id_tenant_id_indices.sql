ALTER TABLE aviate_invoice_sequences RENAME kb_invoice_id TO invoice_id;
drop index aviate_invoice_sequences_kb_tenant_account_id;
create index aviate_invoice_sequences_tenant_account_idx on aviate_invoice_sequences(tenant_id, account_id);
drop index aviate_invoice_sequences_kb_tenant_id;
drop index aviate_invoice_sequences_kb_tenant_invoice_id;
create unique index aviate_invoice_sequences_tenant_id_invoice_id_idx on aviate_invoice_sequences(tenant_id, invoice_id);
drop index aviate_billing_accounts_kb_account_id;
create index aviate_billing_accounts_tenant_account_idx on aviate_billing_accounts(tenant_id, account_id);
create index aviate_orders_tenant_account_idx on aviate_orders(tenant_id, account_id);
create index aviate_quotes_tenant_account_idx on aviate_quotes(tenant_id, account_id);
create index aviate_tax_registrations_tenant_account_idx on aviate_tax_registrations(tenant_id, account_id);
create index aviate_order_subscriptions_tenant_account_idx on aviate_order_subscriptions(tenant_id, account_id);
create index aviate_quote_items_tenant_account_idx on aviate_quote_items(tenant_id, account_id);

ALTER TABLE aviate_invoice_sequences alter column account_id set not null;
ALTER TABLE aviate_invoice_sequences alter column tenant_id set not null;

ALTER TABLE aviate_billing_accounts alter column account_id set not null;
ALTER TABLE aviate_billing_accounts alter column tenant_id set not null;

ALTER TABLE aviate_orders alter column tenant_id set not null;
ALTER TABLE aviate_quotes alter column tenant_id set not null;
ALTER TABLE aviate_tax_registrations alter column tenant_id set not null;
ALTER TABLE aviate_order_subscriptions alter column tenant_id set not null;
ALTER TABLE aviate_quote_items alter column tenant_id set not null;