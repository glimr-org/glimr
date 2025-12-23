-- Create or update a comment (upsert)
INSERT INTO comments (id, user_id, post_id, body, is_approved, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6, $7)
ON CONFLICT (id) DO UPDATE SET
    body = $4,
    is_approved = $5,
    updated_at = $7
RETURNING id, body, user_id, post_id, is_approved, created_at, updated_at
