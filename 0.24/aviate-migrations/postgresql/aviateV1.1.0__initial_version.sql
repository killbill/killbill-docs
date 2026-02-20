/*
 * Copyright 2021-2022 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

/* This should already be installed by the main Kill Bill DDL */
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'datetime') THEN
        CREATE DOMAIN datetime AS timestamp without time zone;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'mediumtext') THEN
        CREATE DOMAIN mediumtext AS text;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'longtext') THEN
        CREATE DOMAIN longtext AS text;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'mediumblob') THEN
        CREATE DOMAIN mediumblob AS bytea;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'blob') THEN
        CREATE DOMAIN blob AS bytea;
    END IF;
END$$;

create table aviate_hosts (
  host_id serial
, host_name varchar(256) not null
, created_dt integer not null default 0 /* set default 0 for postgres*/
);
create unique index host_name_unq on aviate_hosts(host_name);
create index created_dt_host_id_dx on aviate_hosts(created_dt, host_id);

create table aviate_event_categories (
  event_category_id serial
, event_group varchar(256) not null
, event_category varchar(256) not null
);
create unique index event_category_unq on aviate_event_categories(event_group, event_category);

create table aviate_sample_kinds (
  sample_kind_id serial
, event_category_id integer not null
, sample_kind varchar(256) not null
);
create unique index sample_kind_unq on aviate_sample_kinds(event_category_id, sample_kind);

create table aviate_timeline_chunks (
  chunk_id serial
, host_id integer not null
, sample_kind_id integer not null
, sample_count integer not null
, start_time integer not null
, end_time integer not null
, not_valid smallint default 0
, aggregation_level smallint default 0
, dont_aggregate smallint default 0
, in_row_samples bytea default null /* changed varbinary(400) to bytea for Postgres.*/
, blob_samples bytea default null /* changed mediumblob to bytea for Postgres.*/
);
create unique index host_id_timeline_chunk_sample_kind_idx on aviate_timeline_chunks(host_id, sample_kind_id, start_time, aggregation_level);
create index valid_agg_host_start_time on aviate_timeline_chunks(not_valid, aggregation_level, host_id, sample_kind_id, start_time);

create table aviate_orders (
  record_id serial
, order_id char(36) not null
, billing_account_id char(36) not null
, quote_id char(36) not null
, po char(36) default null
, created_at datetime not null
, updated_at datetime not null
, kb_tenant_id char(36) not null
, primary key(record_id)
);
create index aviate_orders_order_id on aviate_orders(order_id);
create index aviate_orders_billing_account_id on aviate_orders(billing_account_id);

create table aviate_order_subscriptions (
  record_id serial
, order_subscription_id char(36) not null
, order_id char(36) not null
, quote_item_id char(36) not null
, subscription_id char(36) not null
, consumed_credit numeric(15,9) default null
, created_at datetime not null
, updated_at datetime not null
, kb_tenant_id char(36) not null
, primary key(record_id)
);
create index aviate_order_subscriptions_order_subscription_id on aviate_order_subscriptions(order_subscription_id);
create index aviate_order_subscriptions_order_id on aviate_order_subscriptions(order_id);
create index aviate_order_subscriptions_quote_item_id on aviate_order_subscriptions(quote_item_id);
create index aviate_order_subscriptions_subscription_id on aviate_order_subscriptions(subscription_id);

create table aviate_quotes (
  record_id serial
, quote_id char(36) not null
, billing_account_id char(36) not null
, status varchar(255) not null
, header longtext default null
, footer longtext default null
, expires_at datetime default null
, sent_at datetime default null
, accepted_at datetime default null
, canceled_at datetime default null
, net_terms_period char(36) default null
, created_at datetime not null
, updated_at datetime not null
, kb_tenant_id char(36) not null
, primary key(record_id)
);
create index aviate_quotes_quote_id on aviate_quotes(quote_id);
create index aviate_quotes_billing_account_id on aviate_quotes(billing_account_id);

create table aviate_quote_items (
  record_id serial
, quote_item_id char(36) not null
, quote_id char(36) not null
, product_name varchar(255) default null
, plan_name varchar(255) default null
, billing_period varchar(255) default null
, price numeric(15,9) not null
, currency varchar(3) not null
, price_list varchar(255) default null
, quantity int default null
, bcd int default null
, entitlement_effective_date datetime default null
, billing_effective_date datetime default null
, term_period varchar(255) default null
, auto_renew bool default true
, renewal_period varchar(255) default null
, cancellation_notice_period varchar(255) default null
, initial_credit numeric(15,9) default null
, recurring_credit numeric(15,9) default null
, recurring_credit_period varchar(255) default null
, recurring_credit_term varchar(255) default null
, created_at datetime not null
, updated_at datetime not null
, kb_tenant_id char(36) not null
, primary key(record_id)
);
create index aviate_quote_items_quote_item_id on aviate_quote_items(quote_item_id);
create index aviate_quote_items_quote_id on aviate_quote_items(quote_id);

create table aviate_billing_accounts (
  record_id serial
, billing_account_id char(36) not null
, kb_account_id char(36) not null
, company_name varchar(255) default null
, contact_name varchar(255) default null
, email varchar(255) default null
, telephone varchar(255) default null
, currency varchar(3) default null
, address_line1 varchar(255) default null
, address_line2 varchar(255) default null
, city varchar(255) default null
, state varchar(255) default null
, country varchar(255) default null
, postal_code varchar(255) default null
, created_at datetime not null
, updated_at datetime not null
, kb_tenant_id char(36) not null
, primary key(record_id)
);
create index aviate_billing_accounts_billing_account_id on aviate_billing_accounts(billing_account_id);
create index aviate_billing_accounts_kb_account_id on aviate_billing_accounts(kb_account_id);

create table aviate_tax_registrations (
  record_id serial
, tax_registration_id char(36) not null
, billing_account_id char(36) not null
, name varchar(255) default null
, exempt boolean default false
, trn varchar(255) default null
, address_line1 varchar(255) default null
, address_line2 varchar(255) default null
, city varchar(255) default null
, state varchar(255) default null
, country varchar(255) default null
, postal_code varchar(255) default null
, created_at datetime not null
, updated_at datetime not null
, kb_tenant_id char(36) not null
, primary key(record_id)
);
create index aviate_tax_registrations_tax_registration_id on aviate_tax_registrations(tax_registration_id);
create index aviate_tax_registrations_billing_account_id on aviate_tax_registrations(billing_account_id);


create table aviate_catalog_pricelists (
    record_id serial unique,
    name varchar (255) not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_catalog_pricelists_idx on aviate_catalog_pricelists(tenant_id, account_id);
create unique index aviate_catalog_pricelists_name_idx on aviate_catalog_pricelists(tenant_id, name);

create table aviate_catalog_products (
    record_id serial unique,
    name varchar (255) not null,
    pretty_name varchar(255) not null,
    category varchar(12) not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_catalog_products_idx on aviate_catalog_products(tenant_id, account_id);
create unique index aviate_catalog_products_name_idx on aviate_catalog_products(tenant_id, name);

create table aviate_catalog_products_add_ons (
    record_id serial unique,
    product_base_record_id bigint /*! unsigned */ not null,
    product_add_on_record_id bigint /*! unsigned */ not null,
    included bool null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_catalog_products_add_ons_idx on aviate_catalog_products_add_ons(tenant_id, account_id);
create index aviate_catalog_products_add_ons_base_idx on aviate_catalog_products_add_ons(product_base_record_id);
create index aviate_catalog_products_add_ons_addon_idx on aviate_catalog_products_add_ons(product_add_on_record_id);
create unique index aviate_catalog_products_add_ons_base_addon_idx on aviate_catalog_products_add_ons(product_base_record_id, product_add_on_record_id, tenant_id);

create table aviate_catalog_plan_shapes (
    record_id serial unique,
    name varchar (255) not null,
    pretty_name varchar(255) not null,
    recurring_billing_mode varchar(15) not null,
    products_record_id bigint not null,
    pricelists_record_id bigint not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_catalog_plan_shapes_tenant_account_idx on aviate_catalog_plan_shapes(tenant_id, account_id);
create unique index aviate_catalog_plan_shapes_name_idx on aviate_catalog_plan_shapes(tenant_id, name);
create index aviate_catalog_plan_shapes_products_idx on aviate_catalog_plan_shapes(products_record_id);


create table aviate_catalog_plan_phases (
    record_id serial unique,
    pretty_name varchar(255) not null,
    type varchar(18) not null,
    duration_unit varchar(30) not null,
    duration_length int not null,
    recurring_billing_period varchar(50),
    plan_shapes_record_id bigint not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_catalog_plan_phases_tenant_account_idx on aviate_catalog_plan_phases(tenant_id, account_id);
create index aviate_catalog_plan_phases_plan_shapes_idx on aviate_catalog_plan_phases(plan_shapes_record_id);

create table aviate_catalog_prices (
    record_id serial unique,
    currency varchar(3) not null,
    value numeric(15,9) not null,
    price_type varchar(12) not null,
    plan_phase_id bigint /*! unsigned */ not null,
    plan_record_id bigint /*! unsigned */ not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_catalog_prices_tenant_account_idx on aviate_catalog_prices(tenant_id, account_id);
create index aviate_catalog_prices_plan_phase_idx on aviate_catalog_prices(plan_phase_id);
create index aviate_catalog_prices_plan_record_idx on aviate_catalog_prices(plan_record_id);

create table aviate_catalog_plans (
    record_id serial unique,
    eff_date datetime not null,
    eff_date_for_existing_subs datetime default null,
    plan_shapes_record_id bigint not null,
    pricelists_record_id bigint not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    retired boolean default false,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_catalog_plans_tenant_account_idx on aviate_catalog_plans(tenant_id, account_id);
create unique index aviate_catalog_plans_plan_shapes_idx on aviate_catalog_plans(tenant_id, plan_shapes_record_id, eff_date);

create or replace procedure create_aviate_calendar(calendar_from date, calendar_to date)
language plpgsql as $$
declare
    d date;
begin
    d := calendar_from;

    drop table if exists calendar_aviate;
    create table calendar_aviate(d date primary key);
    while d <= calendar_to loop
            insert into calendar_aviate(d) values (d);
            d := d + INTERVAL '1 day';
        end loop;
end;
$$;

CALL create_aviate_calendar(('2010-01-01')::date, (CURRENT_DATE + INTERVAL '10 year')::date);