-- Upsert a post by user_id and title combination
INSERT INTO posts (user_id, title, body, status, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT (user_id, title) DO UPDATE SET
  body = $3,
  status = $4,
  updated_at = $6
RETURNING *
