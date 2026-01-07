INSERT INTO submissions (name, email, avatar, message, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *
