#!/bin/bash
set -e

echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD=$FORGEJO_DB_PASS psql -h "$FORGEJO_DB_HOST" -U "$FORGEJO_DB_USER" -d "$FORGEJO_DB_NAME" -c "SELECT 1" &> /dev/null; do
  sleep 3
done

echo "Waiting for application migrations to complete..."
until PGPASSWORD=$FORGEJO_DB_PASS psql -h "$FORGEJO_DB_HOST" -U "$FORGEJO_DB_USER" -d "$FORGEJO_DB_NAME" -c "SELECT 1 FROM information_schema.tables WHERE table_name = 'user'" | grep -q 1; do
  sleep 3
done

echo "Database migrations detected. Checking initial user..."
EXISTING_HASH_ALGO=$(PGPASSWORD=$FORGEJO_DB_PASS psql -h "$FORGEJO_DB_HOST" -U "$FORGEJO_DB_USER" -d "$FORGEJO_DB_NAME" -t -c "SELECT passwd_hash_algo FROM \"user\" WHERE id = 1;" | tr -d '[:space:]')

if [ -z "$EXISTING_HASH_ALGO" ]; then
  echo "Inserting root user..."
  PGPASSWORD=$FORGEJO_DB_PASS psql -h "$FORGEJO_DB_HOST" -U "$FORGEJO_DB_USER" -d "$FORGEJO_DB_NAME" -c "
  INSERT INTO \"user\" (
      \"id\", \"lower_name\", \"name\", \"full_name\", \"email\", \"keep_email_private\",
      \"email_notifications_preference\", \"passwd\", \"passwd_hash_algo\",
      \"must_change_password\", \"login_type\", \"login_source\", \"login_name\", \"type\",
      \"location\", \"website\", \"pronouns\", \"rands\", \"salt\", \"language\",
      \"description\", \"created_unix\", \"updated_unix\", \"last_login_unix\",
      \"last_repo_visibility\", \"max_repo_creation\", \"is_active\", \"is_admin\",
      \"is_restricted\", \"allow_git_hook\", \"allow_import_local\",
      \"allow_create_organization\", \"prohibit_login\", \"avatar\",
      \"avatar_email\", \"use_custom_avatar\", \"normalized_federated_uri\",
      \"num_followers\", \"num_following\", \"num_stars\", \"num_repos\",
      \"num_teams\", \"num_members\", \"visibility\", \"repo_admin_change_team_access\",
      \"diff_view_style\", \"theme\", \"keep_activity_private\",
      \"keep_pronouns_private\", \"enable_repo_unit_hints\"
  ) VALUES (
      1, 'root', 'root', '', 'root@gmail.com', false, 'enabled',
      '34eb96b98a2578b159ea90978826b62c70e3020e16c72f710162a943022286408f864a117c052bc72d6c1bc55a65d730430c',
      'pbkdf2$320000$50', false, 0, 0, '', 0, '', '', '',
      '8a982bc34e80d4dab80ed1decb1cb1dc', '2a07a52e718d7d4217606b922716fdc3',
      'uk-UA', '', 1739868626, 1739868865, 1739868865, false, -1, true, true,
      false, false, false, true, false,
      'c2525a7f58ae3776070e44c106c48e15', 'root@gmail.com', false, '',
      0, 0, 0, 0, 0, 0, 0, false, '', 'forgejo-auto', false, false, false
  )
  ON CONFLICT (id) DO UPDATE SET
      passwd_hash_algo = EXCLUDED.passwd_hash_algo;
  "
else
  echo "User already exists with passwd_hash_algo: $EXISTING_HASH_ALGO"
  if [ "$EXISTING_HASH_ALGO" != "pbkdf2$320000$50" ]; then
    echo "Updating passwd_hash_algo to correct value..."
    PGPASSWORD=$FORGEJO_DB_PASS psql -h "$FORGEJO_DB_HOST" -U "$FORGEJO_DB_USER" -d "$FORGEJO_DB_NAME" -c "
    UPDATE \"user\" SET passwd_hash_algo = 'pbkdf2$320000$50'
    WHERE id = 1;"
  fi
fi

echo "Forcing correct passwd_hash_algo..."
PGPASSWORD=$FORGEJO_DB_PASS psql -h "$FORGEJO_DB_HOST" -U "$FORGEJO_DB_USER" -d "$FORGEJO_DB_NAME" -c "
UPDATE \"user\" SET passwd_hash_algo = 'pbkdf2$320000$50'
WHERE id = 1 AND passwd_hash_algo != 'pbkdf2$320000$50';"

echo "Root user setup complete."
