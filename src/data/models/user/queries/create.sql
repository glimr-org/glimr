-- Create a new user
INSERT INTO users (name, email, bio, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5)
RETURNING *
