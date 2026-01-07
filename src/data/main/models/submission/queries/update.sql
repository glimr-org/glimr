UPDATE submissions
SET name = $2
SET email = $3
SET avatar = $4
SET message = $5
SET updated_at = $6
WHERE id = $1
RETURNING *
