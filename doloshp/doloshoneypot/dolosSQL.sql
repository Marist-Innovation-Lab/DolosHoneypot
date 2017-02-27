CREATE TABLE userinfo (
  uid           serial   NOT NULL,
  username      text     NOT NULL,
  password      text     NOT NULL,
  infoAttempts  integer  NOT NULL DEFAULT 1,
  PRIMARY KEY (uid)
);

CREATE TABLE loginattempts (
  lid         serial      NOT NULL,
  time_stamp  timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  uid         serial      NOT NULL,
  ip_address  text        NOT NULL,
  PRIMARY KEY (lid),
  FOREIGN KEY (uid) REFERENCES userinfo(uid)
);
