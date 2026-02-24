/*
 * Copyright 2021-2024 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

create table aviate_catalog_usages (
    record_id serial unique,
    name varchar (255) not null,
    pretty_name varchar(255) not null,
    billing_mode varchar(12) not null,
    usage_type varchar(12) not null,
    billing_period varchar(50),
    plan_phase_record_id bigint /*! unsigned */ not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
create index aviate_catalog_usages_tenant_account_idx on aviate_catalog_usages(tenant_id, account_id);


create table aviate_catalog_tier_blocks (
    record_id serial unique,
    billing_meter_code varchar(50) not null,
    max_value numeric(15,9) not null,
    size_value int not null,
    tier_number int not null,
    usage_record_id bigint /*! unsigned */ not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
create index aviate_catalog_tier_blocks_tenant_account_idx on aviate_catalog_tier_blocks(tenant_id, account_id);

/* Add foreign key to aviate_catalog_tier_blocks when price_type='USAGE' */
alter table aviate_catalog_prices add column tier_blocks_record_id bigint /* unsigned */ default null;

