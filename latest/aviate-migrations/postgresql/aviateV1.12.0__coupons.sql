/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

create table aviate_coupons (
    record_id serial,
    redemption_code varchar(255) not null,
    reusable boolean not null default false,
    max_use int not null,
    discount_type varchar(24) not null,
    discount_price numeric(15,9) default null,
    discount_currency varchar(3) default null,
    discount_percentage numeric(15,9) default null,
    expiration_date datetime default null,
    plan_list text default null,
    archived boolean not null default false,
    created_date datetime not null,
    updated_date datetime not null,
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
);
create unique index aviate_coupons_redemption_code_idx on aviate_coupons(tenant_id, redemption_code);

create table aviate_coupon_mappings (
    record_id serial,
    redemption_code varchar(255) not null,
    subscription_ext varchar(255) not null,
    created_date datetime not null,
    updated_date datetime not null,
    account_id varchar(36) not null,
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
);
create index aviate_coupon_mappings_tenant_account_idx on aviate_coupon_mappings(tenant_id, account_id);
create index aviate_coupon_mappings_redemption_code_idx on aviate_coupon_mappings(tenant_id, redemption_code);
create index aviate_coupon_mappings_subscription_ext_idx on aviate_coupon_mappings(tenant_id, subscription_ext);
