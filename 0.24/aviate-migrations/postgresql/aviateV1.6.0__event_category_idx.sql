DROP INDEX event_category_unq;
CREATE UNIQUE INDEX event_category_unq ON aviate_event_categories(event_category);
