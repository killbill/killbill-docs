/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

create table aviate_notifications (
  record_id serial unique
, class_name varchar(256) not null
, event_json varchar(2048) not null
, user_token varchar(36)
, created_date datetime not null
, creating_owner varchar(50) not null
, processing_owner varchar(50) default null
, processing_available_date datetime default null
, processing_state varchar(14) default 'AVAILABLE'
, error_count int /*! unsigned */ DEFAULT 0
, search_key1 int /*! unsigned */ default null
, search_key2 int /*! unsigned */ default null
, queue_name varchar(64) not null
, effective_date datetime not null
, future_user_token varchar(36)
, primary key(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
create index aviate_notifications_comp_where on aviate_notifications(effective_date, processing_state, processing_owner, processing_available_date);
create index aviate_notifications_update on aviate_notifications(processing_state,processing_owner,processing_available_date);
create index aviate_notifications_get_ready on aviate_notifications(effective_date,created_date);
create index aviate_notifications_search_keys on aviate_notifications(search_key2, search_key1);

create table aviate_notifications_history (
  record_id serial unique
, class_name varchar(256) not null
, event_json varchar(2048) not null
, user_token varchar(36)
, created_date datetime not null
, creating_owner varchar(50) not null
, processing_owner varchar(50) default null
, processing_available_date datetime default null
, processing_state varchar(14) default 'AVAILABLE'
, error_count int /*! unsigned */ DEFAULT 0
, search_key1 int /*! unsigned */ default null
, search_key2 int /*! unsigned */ default null
, queue_name varchar(64) not null
, effective_date datetime not null
, future_user_token varchar(36)
, primary key(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
