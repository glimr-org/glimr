-- Find other comments on the same post as a given comment (self-referential via post)
SELECT c2.id, c2.body, c2.user_id, c2.created_at
FROM comments c1
INNER JOIN comments c2 ON c2.post_id = c1.post_id AND c2.id != c1.id
WHERE c1.id = $1
ORDER BY c2.created_at ASC
