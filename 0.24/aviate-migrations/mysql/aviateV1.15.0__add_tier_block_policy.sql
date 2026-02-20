/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
alter table aviate_catalog_usages add column tier_block_policy varchar(12) not null default 'ALL_TIERS' after billing_period;