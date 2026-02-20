/*
 * Copyright 2021-2024 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

create table aviate_invoice_sequences (
  record_id serial
, invoice_sequence integer not null
, kb_invoice_id char(36) not null
, kb_account_id char(36) not null
, prefix varchar(255) default null
, suffix varchar(255) default null
, retired bool default false
, created_at datetime not null
, updated_at datetime not null
, kb_tenant_id char(36) not null
, primary key(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_invoice_sequences_kb_tenant_id on aviate_invoice_sequences(kb_tenant_id);
create index aviate_invoice_sequences_kb_tenant_account_id on aviate_invoice_sequences(kb_tenant_id, kb_account_id);
create unique index aviate_invoice_sequences_kb_tenant_invoice_id on aviate_invoice_sequences(kb_tenant_id, kb_invoice_id);
