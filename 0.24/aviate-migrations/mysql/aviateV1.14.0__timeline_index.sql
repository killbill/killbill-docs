/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

CREATE INDEX by_host_kind_start_end ON aviate_timeline_chunks (host_id, sample_kind_id, start_time, end_time);
CREATE INDEX by_host_kind_end_start ON aviate_timeline_chunks (host_id, sample_kind_id, end_time, start_time);
