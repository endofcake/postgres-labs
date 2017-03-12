-- We can use psql metacommands - in this instance we're connecting to a specific database
-- before executing CREATE TABLE
\c audit

CREATE SEQUENCE IF NOT EXISTS logs.access_log_sq MINVALUE 0 START 1 NO CYCLE;

CREATE TABLE logs.access_log (
  id                               BIGINT        NOT NULL DEFAULT nextval('logs.access_log_sq') PRIMARY KEY,
  ip                               INET          NULL,
  content                          JSONB         NOT NULL,
  token_valid                      TSTZRANGE     NOT NULL,
  time_stamp                       TIMESTAMPTZ   NOT NULL DEFAULT (now())
);

-- Example of using time-series tables, which inherit from parent table
CREATE TABLE logs.access_log_2016 (
    PRIMARY KEY (id)
  )
  INHERITS (logs.access_log);

ALTER TABLE logs.access_log_2016
  ADD CONSTRAINT chk_y2016
  CHECK (
    time_stamp >= '2016-1-1'::timestamptz AND time_stamp < '2017-1-1'::timestamptz
  );
