\c audit

INSERT INTO logs.access_log_2016 (ip, content, token_valid, time_stamp)
VALUES
(
  '192.168.1.1'::INET,
  '{"user": "local_user", "action": "read"}',
  '(2016-06-15 12:15 PM NZDT, 2016-06-15 1:15 PM NZDT]'::TSTZRANGE,
  '2016-06-15 12:15 PM NZDT'::TIMESTAMPTZ
),
(
  '127.0.0.1'::INET,
  '{"user": "admin", "action": "drop"}',
  '(-infinity, infinity]'::TSTZRANGE,
  '2016-11-20 1:01 AM NZDT'::TIMESTAMPTZ
);
