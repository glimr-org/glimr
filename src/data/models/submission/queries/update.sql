UPDATE submissions
SET name = $1, email = $2, avatar = $3, message = $4, updated_at = $5
WHERE id = $6
RETURNING *
