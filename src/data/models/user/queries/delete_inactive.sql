-- Delete users who haven't been updated since a given timestamp
DELETE FROM users
WHERE updated_at < $1
RETURNING id, name, email
