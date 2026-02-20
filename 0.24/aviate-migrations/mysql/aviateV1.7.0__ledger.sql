/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */


create table aviate_wallets (
    record_id serial,
    wallet_id varchar(36) not null,
    currency varchar(3) default null,
    live_balance numeric(15,9) not null,
    top_off_type varchar(24) not null,
    top_off_watermark numeric(15,9) not null,
    top_off_amount numeric(15,9) not null,
    top_off_exp_duration_unit varchar(30),
    top_off_exp_duration_length int default null,
    created_date datetime not null,
    updated_date datetime not null,
    account_id varchar(36) not null,
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
);
create index aviate_wallets_idx on aviate_wallets(tenant_id, account_id);
create unique index aviate_wallets_id_idx on aviate_wallets(wallet_id);

 create table aviate_ledger_entries (
    record_id serial,
    wallet_record_id bigint not null,
    origin_amount numeric(15,9) not null,
    remain_amount numeric(15,9) not null,
    credit_type varchar(24) not null,
    description varchar(255),
    expires_date datetime default null,
    parent_record_id bigint default null,
    kb_invoice_id char(36) default null,
    kb_payment_id char(36) default null,
    created_date datetime not null,
    updated_date datetime not null,
    account_id varchar(36) not null,
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
);
create index aviate_ledger_entries_idx on aviate_ledger_entries(tenant_id, account_id);
create index aviate_ledger_entries_parent_idx on aviate_ledger_entries(parent_record_id);
create index aviate_ledger_entries_kb_invoice_not_null_idx on aviate_ledger_entries(kb_invoice_id) /* regular index although kb_invoice_id may be null */;

