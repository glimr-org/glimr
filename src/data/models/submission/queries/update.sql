UPDATE submissions
SET name = $2, email = $3, avatar = $4, message = $5, updated_at = $6
WHERE id = $1
RETURNING *
