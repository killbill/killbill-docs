/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

create table aviate_health_reports (
    record_id serial unique,
    creating_owner varchar(50) not null,
    report_data_gz blob not null,
    created_date datetime not null,
    updated_date datetime not null,
    PRIMARY KEY(record_id)
);

create unique index aviate_health_reports_owner_idx on aviate_health_reports(creating_owner);
