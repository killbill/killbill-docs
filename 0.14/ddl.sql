use killbill;

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    external_key varchar(128) NULL,
    email varchar(128) NOT NULL,
    name varchar(100) NOT NULL,
    first_name_length int NOT NULL,
    currency char(3) DEFAULT NULL,
    billing_cycle_day_local int DEFAULT NULL,
    payment_method_id char(36) DEFAULT NULL,
    time_zone varchar(50) DEFAULT NULL,
    locale varchar(5) DEFAULT NULL,
    address1 varchar(100) DEFAULT NULL,
    address2 varchar(100) DEFAULT NULL,
    company_name varchar(50) DEFAULT NULL,
    city varchar(50) DEFAULT NULL,
    state_or_province varchar(50) DEFAULT NULL,
    country varchar(50) DEFAULT NULL,
    postal_code varchar(16) DEFAULT NULL,
    phone varchar(25) DEFAULT NULL,
    migrated bool DEFAULT false,
    is_notified_for_invoices boolean NOT NULL,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    updated_date datetime DEFAULT NULL,
    updated_by varchar(50) DEFAULT NULL,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX accounts_id ON accounts(id);
CREATE UNIQUE INDEX accounts_external_key ON accounts(external_key, tenant_record_id);
CREATE INDEX accounts_tenant_record_id ON accounts(tenant_record_id);

DROP TABLE IF EXISTS account_history;
CREATE TABLE account_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    external_key varchar(128) NULL,
    email varchar(128) NOT NULL,
    name varchar(100) NOT NULL,
    first_name_length int NOT NULL,
    currency char(3) DEFAULT NULL,
    billing_cycle_day_local int DEFAULT NULL,
    payment_method_id char(36) DEFAULT NULL,
    time_zone varchar(50) DEFAULT NULL,
    locale varchar(5) DEFAULT NULL,
    address1 varchar(100) DEFAULT NULL,
    address2 varchar(100) DEFAULT NULL,
    company_name varchar(50) DEFAULT NULL,
    city varchar(50) DEFAULT NULL,
    state_or_province varchar(50) DEFAULT NULL,
    country varchar(50) DEFAULT NULL,
    postal_code varchar(16) DEFAULT NULL,
    phone varchar(25) DEFAULT NULL,
    migrated bool DEFAULT false,
    is_notified_for_invoices boolean NOT NULL,
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX account_history_target_record_id ON account_history(target_record_id);
CREATE INDEX account_history_tenant_record_id ON account_history(tenant_record_id);

DROP TABLE IF EXISTS account_emails;
CREATE TABLE account_emails (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    account_id char(36) NOT NULL,
    email varchar(128) NOT NULL,
    is_active bool DEFAULT true,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX account_email_id ON account_emails(id);
CREATE INDEX account_email_account_id_email ON account_emails(account_id, email);
CREATE INDEX account_emails_tenant_account_record_id ON account_emails(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS account_email_history;
CREATE TABLE account_email_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    account_id char(36) NOT NULL,
    email varchar(128) NOT NULL,
    is_active bool DEFAULT true,
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX account_email_target_record_id ON account_email_history(target_record_id);
CREATE INDEX account_email_history_tenant_account_record_id ON account_email_history(tenant_record_id, account_record_id);

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS bus_ext_events;
CREATE TABLE bus_ext_events (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    class_name varchar(128) NOT NULL,
    event_json varchar(2048) NOT NULL,
    user_token char(36),
    created_date datetime NOT NULL,
    creating_owner char(50) NOT NULL,
    processing_owner char(50) DEFAULT NULL,
    processing_available_date datetime DEFAULT NULL,
    processing_state varchar(14) DEFAULT 'AVAILABLE',
    error_count int(11) unsigned DEFAULT 0,
    search_key1 int(11) unsigned default null,
    search_key2 int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX  `idx_bus_ext_where` ON bus_ext_events (`processing_state`,`processing_owner`,`processing_available_date`);
CREATE INDEX bus_ext_events_tenant_account_record_id ON bus_ext_events(search_key2, search_key1);

DROP TABLE IF EXISTS bus_ext_events_history;
CREATE TABLE bus_ext_events_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    class_name varchar(128) NOT NULL,
    event_json varchar(2048) NOT NULL,
    user_token char(36),
    created_date datetime NOT NULL,
    creating_owner char(50) NOT NULL,
    processing_owner char(50) DEFAULT NULL,
    processing_available_date datetime DEFAULT NULL,
    processing_state varchar(14) DEFAULT 'AVAILABLE',
    error_count int(11) unsigned DEFAULT 0,
    search_key1 int(11) unsigned default null,
    search_key2 int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS catalog_override_plan_definition;
CREATE TABLE catalog_override_plan_definition (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    parent_plan_name varchar(255) NOT NULL,
    effective_date datetime NOT NULL,
    is_active bool DEFAULT 1,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX catalog_override_plan_definition_tenant_record_id ON catalog_override_plan_definition(tenant_record_id);


DROP TABLE IF EXISTS catalog_override_phase_definition;
CREATE TABLE catalog_override_phase_definition (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    parent_phase_name varchar(255) NOT NULL,
    currency char(3) NOT NULL,
    fixed_price numeric(15,9) NULL,
    recurring_price numeric(15,9) NULL,
    effective_date datetime NOT NULL,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX catalog_override_phase_definition_idx ON catalog_override_phase_definition(tenant_record_id, parent_phase_name, currency);

DROP TABLE IF EXISTS catalog_override_plan_phase;
CREATE TABLE catalog_override_plan_phase (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    phase_number tinyint(3) unsigned NOT NULL,
    phase_def_record_id int(11) unsigned NOT NULL,
    target_plan_def_record_id int(11) unsigned NOT NULL,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX catalog_override_plan_phase_idx ON catalog_override_plan_phase(tenant_record_id, phase_number, phase_def_record_id);

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS subscription_events;
CREATE TABLE subscription_events (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    event_type varchar(9) NOT NULL,
    user_type varchar(25) DEFAULT NULL,
    requested_date datetime NOT NULL,
    effective_date datetime NOT NULL,
    subscription_id char(36) NOT NULL,
    plan_name varchar(64) DEFAULT NULL,
    phase_name varchar(128) DEFAULT NULL,
    price_list_name varchar(64) DEFAULT NULL,
    current_version int(11) DEFAULT 1,
    is_active bool DEFAULT 1,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX subscription_events_id ON subscription_events(id);
CREATE INDEX idx_ent_1 ON subscription_events(subscription_id, is_active, effective_date);
CREATE INDEX idx_ent_2 ON subscription_events(subscription_id, effective_date, created_date, requested_date,id);
CREATE INDEX subscription_events_tenant_account_record_id ON subscription_events(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS subscriptions;
CREATE TABLE subscriptions (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    bundle_id char(36) NOT NULL,
    category varchar(32) NOT NULL,
    start_date datetime NOT NULL,
    bundle_start_date datetime NOT NULL,
    active_version int(11) DEFAULT 1,
    charged_through_date datetime DEFAULT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX subscriptions_id ON subscriptions(id);
CREATE INDEX subscriptions_bundle_id ON subscriptions(bundle_id);
CREATE INDEX subscriptions_tenant_account_record_id ON subscriptions(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS bundles;
CREATE TABLE bundles (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    external_key varchar(64) NOT NULL,
    account_id char(36) NOT NULL,
    last_sys_update_date datetime,
    original_created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX bundles_id ON bundles(id);
CREATE INDEX bundles_key ON bundles(external_key);
CREATE INDEX bundles_account ON bundles(account_id);
CREATE INDEX bundles_tenant_account_record_id ON bundles(tenant_record_id, account_record_id);


/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS blocking_states;
CREATE TABLE blocking_states (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    blockable_id char(36) NOT NULL,
    type varchar(20) NOT NULL,
    state varchar(50) NOT NULL,
    service varchar(20) NOT NULL,
    block_change bool NOT NULL,
    block_entitlement bool NOT NULL,
    block_billing bool NOT NULL,
    effective_date datetime NOT NULL,
    is_active bool DEFAULT 1,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    updated_date datetime DEFAULT NULL,
    updated_by varchar(50) DEFAULT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX blocking_states_id ON blocking_states(blockable_id);
CREATE INDEX blocking_states_tenant_account_record_id ON blocking_states(tenant_record_id, account_record_id);

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS invoice_items;
CREATE TABLE invoice_items (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    type varchar(24) NOT NULL,
    invoice_id char(36) NOT NULL,
    account_id char(36) NOT NULL,
    bundle_id char(36),
    subscription_id char(36),
    description varchar(255),
    plan_name varchar(50),
    phase_name varchar(50),
    usage_name varchar(50),
    start_date date NOT NULL,
    end_date date,
    amount numeric(15,9) NOT NULL,
    rate numeric(15,9) NULL,
    currency char(3) NOT NULL,
    linked_item_id char(36),
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX invoice_items_id ON invoice_items(id);
CREATE INDEX invoice_items_subscription_id ON invoice_items(subscription_id ASC);
CREATE INDEX invoice_items_invoice_id ON invoice_items(invoice_id ASC);
CREATE INDEX invoice_items_account_id ON invoice_items(account_id ASC);
CREATE INDEX invoice_items_tenant_account_record_id ON invoice_items(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS invoices;
CREATE TABLE invoices (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    account_id char(36) NOT NULL,
    invoice_date date NOT NULL,
    target_date date NOT NULL,
    currency char(3) NOT NULL,
    migrated bool NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX invoices_id ON invoices(id);
CREATE INDEX invoices_account_target ON invoices(account_id ASC, target_date);
CREATE INDEX invoices_tenant_account_record_id ON invoices(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS invoice_payments;
CREATE TABLE invoice_payments (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    type varchar(24) NOT NULL,
    invoice_id char(36) NOT NULL,
    payment_id char(36),
    payment_date datetime NOT NULL,
    amount numeric(15,9) NOT NULL,
    currency char(3) NOT NULL,
    processed_currency char(3) NOT NULL,
    payment_cookie_id varchar(255) DEFAULT NULL,
    linked_invoice_payment_id char(36) DEFAULT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX invoice_payments_id ON invoice_payments(id);
CREATE UNIQUE INDEX invoice_payments ON invoice_payments(payment_id, type);
CREATE INDEX invoice_payments_invoice_id ON invoice_payments(invoice_id);
CREATE INDEX invoice_payments_reversals ON invoice_payments(linked_invoice_payment_id);
CREATE INDEX invoice_payments_tenant_account_record_id ON invoice_payments(tenant_record_id, account_record_id);

/*! SET storage_engine=INNODB */;


DROP TABLE IF EXISTS payment_attempts;
CREATE TABLE payment_attempts (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    account_id char(36) NOT NULL,
    payment_method_id char(36) DEFAULT NULL,
    payment_external_key char(128) NOT NULL,
    transaction_id char(36),
    transaction_external_key char(128) NOT NULL,
    transaction_type varchar(32) NOT NULL,
    state_name varchar(32) NOT NULL,
    amount numeric(15,9),
    currency char(3),
    plugin_name varchar(1024) NOT NULL,
    plugin_properties blob(8194),
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY (record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX payment_attempts_id ON payment_attempts(id);
CREATE INDEX payment_attempts_payment ON payment_attempts(transaction_id);
CREATE INDEX payment_attempts_payment_key ON payment_attempts(payment_external_key);
CREATE INDEX payment_attempts_payment_state ON payment_attempts(state_name);
CREATE INDEX payment_attempts_payment_transaction_key ON payment_attempts(transaction_external_key);
CREATE INDEX payment_attempts_tenant_account_record_id ON payment_attempts(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS payment_attempt_history;
CREATE TABLE payment_attempt_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    account_id char(36) NOT NULL,
    payment_method_id char(36) DEFAULT NULL,
    payment_external_key char(128) NOT NULL,
    transaction_id char(36),
    transaction_external_key char(128) NOT NULL,
    transaction_type varchar(32) NOT NULL,
    state_name varchar(32) NOT NULL,
    amount numeric(15,9),
    currency char(3),
    plugin_name varchar(1024) NOT NULL,
    plugin_properties blob(8194),
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX payment_attempt_history_target_record_id ON payment_attempt_history(target_record_id);
CREATE INDEX payment_attempt_history_tenant_account_record_id ON payment_attempt_history(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS payment_methods;
CREATE TABLE payment_methods (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    external_key varchar(255) NOT NULL,
    account_id char(36) NOT NULL,
    plugin_name varchar(50) NOT NULL,
    is_active bool DEFAULT true,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY (record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX payment_methods_id ON payment_methods(id);
CREATE UNIQUE INDEX payment_methods_external_key ON payment_methods(external_key, tenant_record_id);
CREATE INDEX payment_methods_plugin_name ON payment_methods(plugin_name);
CREATE INDEX payment_methods_active_accnt ON payment_methods(is_active, account_id);
CREATE INDEX payment_methods_tenant_account_record_id ON payment_methods(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS payment_method_history;
CREATE TABLE payment_method_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    external_key varchar(255) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    account_id char(36) NOT NULL,
    plugin_name varchar(50) NOT NULL,
    is_active bool DEFAULT true,
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX payment_method_history_target_record_id ON payment_method_history(target_record_id);
CREATE INDEX payment_method_history_tenant_account_record_id ON payment_method_history(tenant_record_id, account_record_id);


DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    account_id char(36) NOT NULL,
    payment_method_id char(36) NOT NULL,
    external_key varchar(255) NOT NULL,
    state_name varchar(64) DEFAULT NULL,
    last_success_state_name varchar(64) DEFAULT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY (record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX payments_id ON payments(id);
CREATE UNIQUE INDEX payments_key ON payments(external_key, tenant_record_id);
CREATE INDEX payments_accnt ON payments(account_id);
CREATE INDEX payments_tenant_account_record_id ON payments(tenant_record_id, account_record_id);


DROP TABLE IF EXISTS payment_history;
CREATE TABLE payment_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    account_id char(36) NOT NULL,
    payment_method_id char(36) NOT NULL,
    external_key varchar(255) NOT NULL,
    state_name varchar(64) DEFAULT NULL,
    last_success_state_name varchar(64) DEFAULT NULL,
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX payment_history_target_record_id ON payment_history(target_record_id);
CREATE INDEX payment_history_tenant_account_record_id ON payment_history(tenant_record_id, account_record_id);


DROP TABLE IF EXISTS payment_transactions;
CREATE TABLE payment_transactions (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    attempt_id char(36) DEFAULT NULL,
    transaction_external_key varchar(255) NOT NULL,
    transaction_type varchar(32) NOT NULL,
    effective_date datetime NOT NULL,
    transaction_status varchar(50) NOT NULL,
    amount numeric(15,9),
    currency char(3),
    processed_amount numeric(15,9),
    processed_currency char(3),
    payment_id char(36) NOT NULL,
    gateway_error_code varchar(32),
    gateway_error_msg varchar(256),
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY (record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX transactions_id ON payment_transactions(id);
CREATE INDEX transactions_payment_id ON payment_transactions(payment_id);
CREATE INDEX transactions_key ON payment_transactions(transaction_external_key);
CREATE INDEX transactions_status ON payment_transactions(transaction_status);
CREATE INDEX transactions_tenant_account_record_id ON payment_transactions(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS payment_transaction_history;
CREATE TABLE payment_transaction_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    attempt_id char(36) DEFAULT NULL,
    transaction_external_key varchar(255) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    transaction_type varchar(32) NOT NULL,
    effective_date datetime NOT NULL,
    transaction_status varchar(50) NOT NULL,
    amount numeric(15,9),
    currency char(3),
    processed_amount numeric(15,9),
    processed_currency char(3),
    payment_id char(36) NOT NULL,
    gateway_error_code varchar(32),
    gateway_error_msg varchar(256),
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned DEFAULT NULL,
    tenant_record_id int(11) unsigned DEFAULT NULL,
    PRIMARY KEY (record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX transaction_history_target_record_id ON payment_transaction_history(target_record_id);
CREATE INDEX transaction_history_tenant_account_record_id ON payment_transaction_history(tenant_record_id, account_record_id);


/*  PaymentControlPlugin lives  here until this becomes a first class citizen plugin */
DROP TABLE IF EXISTS _invoice_payment_control_plugin_auto_pay_off;
CREATE TABLE _invoice_payment_control_plugin_auto_pay_off (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    attempt_id char(36) NOT NULL,
    payment_external_key varchar(255) NOT NULL,
    transaction_external_key varchar(255) NOT NULL,
    account_id char(36) NOT NULL,
    plugin_name varchar(50) NOT NULL,
    payment_id char(36),
    payment_method_id char(36) NOT NULL,
    amount numeric(15,9),
    currency char(3),
    is_active bool DEFAULT true,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    PRIMARY KEY (record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX _invoice_payment_control_plugin_auto_pay_off_account ON _invoice_payment_control_plugin_auto_pay_off(account_id);

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS rolled_up_usage;
CREATE TABLE rolled_up_usage (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    subscription_id char(36),
    unit_type varchar(50),
    record_date date NOT NULL,
    amount bigint NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX rolled_up_usage_id ON rolled_up_usage(id);
CREATE INDEX rolled_up_usage_subscription_id ON rolled_up_usage(subscription_id ASC);
CREATE INDEX rolled_up_usage_tenant_account_record_id ON rolled_up_usage(tenant_record_id, account_record_id);
CREATE INDEX rolled_up_usage_account_record_id ON rolled_up_usage(account_record_id);

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS custom_fields;
CREATE TABLE custom_fields (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    object_id char(36) NOT NULL,
    object_type varchar(30) NOT NULL,
    is_active bool DEFAULT true,
    field_name varchar(30) NOT NULL,
    field_value varchar(255),
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) DEFAULT NULL,
    updated_date datetime DEFAULT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX custom_fields_id ON custom_fields(id);
CREATE INDEX custom_fields_object_id_object_type ON custom_fields(object_id, object_type);
CREATE INDEX custom_fields_tenant_account_record_id ON custom_fields(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS custom_field_history;
CREATE TABLE custom_field_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    object_id char(36) NOT NULL,
    object_type varchar(30) NOT NULL,
    is_active bool DEFAULT true,
    field_name varchar(30),
    field_value varchar(255),
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX custom_field_history_target_record_id ON custom_field_history(target_record_id);
CREATE INDEX custom_field_history_object_id_object_type ON custom_fields(object_id, object_type);
CREATE INDEX custom_field_history_tenant_account_record_id ON custom_field_history(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS tag_definitions;
CREATE TABLE tag_definitions (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    name varchar(20) NOT NULL,
    description varchar(200) NOT NULL,
    is_active bool DEFAULT true,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX tag_definitions_id ON tag_definitions(id);
CREATE INDEX tag_definitions_tenant_record_id ON tag_definitions(tenant_record_id);

DROP TABLE IF EXISTS tag_definition_history;
CREATE TABLE tag_definition_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    name varchar(30) NOT NULL,
    description varchar(200),
    is_active bool DEFAULT true,
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX tag_definition_history_id ON tag_definition_history(id);
CREATE INDEX tag_definition_history_target_record_id ON tag_definition_history(target_record_id);
CREATE INDEX tag_definition_history_name ON tag_definition_history(name);
CREATE INDEX tag_definition_history_tenant_record_id ON tag_definition_history(tenant_record_id);

DROP TABLE IF EXISTS tags;
CREATE TABLE tags (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    tag_definition_id char(36) NOT NULL,
    object_id char(36) NOT NULL,
    object_type varchar(30) NOT NULL,
    is_active bool DEFAULT true,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX tags_id ON tags(id);
CREATE INDEX tags_by_object ON tags(object_id);
CREATE INDEX tags_tenant_account_record_id ON tags(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS tag_history;
CREATE TABLE tag_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) unsigned NOT NULL,
    object_id char(36) NOT NULL,
    object_type varchar(30) NOT NULL,
    tag_definition_id char(36) NOT NULL,
    is_active bool DEFAULT true,
    change_type char(6) NOT NULL,
    created_by varchar(50) NOT NULL,
    created_date datetime NOT NULL,
    updated_by varchar(50) NOT NULL,
    updated_date datetime NOT NULL,
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX tag_history_target_record_id ON tag_history(target_record_id);
CREATE INDEX tag_history_by_object ON tags(object_id);
CREATE INDEX tag_history_tenant_account_record_id ON tag_history(tenant_record_id, account_record_id);

DROP TABLE IF EXISTS audit_log;
CREATE TABLE audit_log (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    target_record_id int(11) NOT NULL,
    table_name varchar(50) NOT NULL,
    change_type char(6) NOT NULL,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    reason_code varchar(255) DEFAULT NULL,
    comments varchar(255) DEFAULT NULL,
    user_token char(36),
    account_record_id int(11) unsigned default null,
    tenant_record_id int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX audit_log_fetch_target_record_id ON audit_log(table_name, target_record_id);
CREATE INDEX audit_log_user_name ON audit_log(created_by);
CREATE INDEX audit_log_tenant_account_record_id ON audit_log(tenant_record_id, account_record_id);
CREATE INDEX audit_log_via_history ON audit_log(target_record_id, table_name, tenant_record_id);



DROP TABLE IF EXISTS notifications;
CREATE TABLE notifications (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    class_name varchar(256) NOT NULL,
    event_json varchar(2048) NOT NULL,
    user_token char(36),
    created_date datetime NOT NULL,
    creating_owner char(50) NOT NULL,
    processing_owner char(50) DEFAULT NULL,
    processing_available_date datetime DEFAULT NULL,
    processing_state varchar(14) DEFAULT 'AVAILABLE',
    error_count int(11) unsigned DEFAULT 0,
    search_key1 int(11) unsigned default null,
    search_key2 int(11) unsigned default null,
    queue_name char(64) NOT NULL,
    effective_date datetime NOT NULL,
    future_user_token char(36),
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX  `idx_comp_where` ON notifications (`effective_date`, `processing_state`,`processing_owner`,`processing_available_date`);
CREATE INDEX  `idx_update` ON notifications (`processing_state`,`processing_owner`,`processing_available_date`);
CREATE INDEX  `idx_get_ready` ON notifications (`effective_date`,`created_date`);
CREATE INDEX notifications_tenant_account_record_id ON notifications(search_key2, search_key1);

DROP TABLE IF EXISTS notifications_history;
CREATE TABLE notifications_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    class_name varchar(256) NOT NULL,
    event_json varchar(2048) NOT NULL,
    user_token char(36),
    created_date datetime NOT NULL,
    creating_owner char(50) NOT NULL,
    processing_owner char(50) DEFAULT NULL,
    processing_available_date datetime DEFAULT NULL,
    processing_state varchar(14) DEFAULT 'AVAILABLE',
    error_count int(11) unsigned DEFAULT 0,
    search_key1 int(11) unsigned default null,
    search_key2 int(11) unsigned default null,
    queue_name char(64) NOT NULL,
    effective_date datetime NOT NULL,
    future_user_token char(36),
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;

DROP TABLE IF EXISTS bus_events;
CREATE TABLE bus_events (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    class_name varchar(128) NOT NULL,
    event_json varchar(2048) NOT NULL,
    user_token char(36),
    created_date datetime NOT NULL,
    creating_owner char(50) NOT NULL,
    processing_owner char(50) DEFAULT NULL,
    processing_available_date datetime DEFAULT NULL,
    processing_state varchar(14) DEFAULT 'AVAILABLE',
    error_count int(11) unsigned DEFAULT 0,
    search_key1 int(11) unsigned default null,
    search_key2 int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX  `idx_bus_where` ON bus_events (`processing_state`,`processing_owner`,`processing_available_date`);
CREATE INDEX bus_events_tenant_account_record_id ON bus_events(search_key2, search_key1);

DROP TABLE IF EXISTS bus_events_history;
CREATE TABLE bus_events_history (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    class_name varchar(128) NOT NULL,
    event_json varchar(2048) NOT NULL,
    user_token char(36),
    created_date datetime NOT NULL,
    creating_owner char(50) NOT NULL,
    processing_owner char(50) DEFAULT NULL,
    processing_available_date datetime DEFAULT NULL,
    processing_state varchar(14) DEFAULT 'AVAILABLE',
    error_count int(11) unsigned DEFAULT 0,
    search_key1 int(11) unsigned default null,
    search_key2 int(11) unsigned default null,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;

drop table if exists sessions;
create table sessions (
  record_id int(11) unsigned not null auto_increment
, start_timestamp datetime not null
, last_access_time datetime default null
, timeout int(11)
, host varchar(100) default null
, session_data mediumblob default null
, primary key(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    username varchar(128) NULL,
    password varchar(128) NULL,
    password_salt varchar(128) NULL,
    is_active bool DEFAULT 1,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    updated_date datetime DEFAULT NULL,
    updated_by varchar(50) DEFAULT NULL,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX users_username ON users(username);


DROP TABLE IF EXISTS user_roles;
CREATE TABLE user_roles (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    username varchar(128) NULL,
    role_name varchar(128) NULL,
    is_active bool DEFAULT 1,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    updated_date datetime DEFAULT NULL,
    updated_by varchar(50) DEFAULT NULL,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX user_roles_idx ON user_roles(username, role_name);


DROP TABLE IF EXISTS roles_permissions;
CREATE TABLE roles_permissions (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    role_name varchar(128) NULL,
    permission varchar(128) NULL,
    is_active bool DEFAULT 1,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    updated_date datetime DEFAULT NULL,
    updated_by varchar(50) DEFAULT NULL,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX roles_permissions_idx ON roles_permissions(role_name, permission);

/*! SET storage_engine=INNODB */;

DROP TABLE IF EXISTS tenants;
CREATE TABLE tenants (
    record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id char(36) NOT NULL,
    external_key varchar(128) NULL,
    api_key varchar(128) NULL,
    api_secret varchar(128) NULL,
    api_salt varchar(128) NULL,
    created_date datetime NOT NULL,
    created_by varchar(50) NOT NULL,
    updated_date datetime DEFAULT NULL,
    updated_by varchar(50) DEFAULT NULL,
    PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE UNIQUE INDEX tenants_id ON tenants(id);
CREATE UNIQUE INDEX tenants_api_key ON tenants(api_key);


DROP TABLE IF EXISTS tenant_kvs;
CREATE TABLE tenant_kvs (
   record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
   id char(36) NOT NULL,
   tenant_record_id int(11) unsigned NOT NULL,
   tenant_key varchar(255) NOT NULL,
   tenant_value mediumtext NOT NULL,
   is_active bool DEFAULT 1,
   created_date datetime NOT NULL,
   created_by varchar(50) NOT NULL,
   updated_date datetime DEFAULT NULL,
   updated_by varchar(50) DEFAULT NULL,
   PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX tenant_kvs_key ON tenant_kvs(tenant_key);


DROP TABLE IF EXISTS tenant_broadcasts;
CREATE TABLE tenant_broadcasts (
   record_id int(11) unsigned NOT NULL AUTO_INCREMENT,
   id char(36) NOT NULL,
   target_record_id int(11) unsigned,
   target_table_name varchar(50) NOT NULL,
   tenant_record_id int(11) unsigned NOT NULL,
   type varchar(64) NOT NULL,
   user_token char(36),
   created_date datetime NOT NULL,
   created_by varchar(50) NOT NULL,
   updated_date datetime DEFAULT NULL,
   updated_by varchar(50) DEFAULT NULL,
   PRIMARY KEY(record_id)
) /*! CHARACTER SET utf8 COLLATE utf8_bin */;
CREATE INDEX tenant_broadcasts_key ON tenant_broadcasts(tenant_record_id);

