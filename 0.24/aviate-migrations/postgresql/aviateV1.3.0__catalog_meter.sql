/*
 * Copyright 2021-2024 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

create table aviate_billing_meters (
    record_id serial unique,
    name varchar (255) not null,
    code varchar(255) not null,
    event_key varchar(255) not null,
    event_filters varchar(255) default null,
    aggregation_type varchar(50) not null,
    created_by varchar(50) not null,
    created_date datetime not null,
    account_id varchar(36),
    tenant_id varchar(36) not null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
create index aviate_billing_meters_tenant_account_idx on aviate_billing_meters(tenant_id, account_id);
create unique index aviate_billing_meters_code_idx on aviate_billing_meters(tenant_id, code);
