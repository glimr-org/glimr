-- Create a new post
INSERT INTO posts (user_id, title, body, status, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *
