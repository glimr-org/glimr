-- Upsert a user by email (insert or update if email exists)
INSERT INTO users (name, email, bio, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (email) DO UPDATE SET
  name = $1,
  bio = $3,
  updated_at = $5
RETURNING *
