/*
 * Copyright 2021-2025 The Billing Project, LLC - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

CREATE INDEX aviate_idx_chunks_kind_valid_end_start ON aviate_timeline_chunks (sample_kind_id, not_valid, end_time, start_time);
