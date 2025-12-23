-- Delete all posts by a specific user
DELETE FROM posts
WHERE user_id = $1
RETURNING id, title
