-- Create a new comment
INSERT INTO comments (user_id, post_id, body, is_approved, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *
