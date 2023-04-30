
\c service duser;

CREATE SCHEMA operations;
ALTER ROLE duser SET search_path = 'operations';

\c service_test duser;

CREATE SCHEMA operations;
ALTER ROLE duser SET search_path = 'operations';

\c gitea duser;

CREATE SCHEMA operations;
ALTER ROLE duser SET search_path = 'operations';

