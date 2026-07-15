SELECT pages.page_id
FROM pages
LEFT JOIN Page_likes
ON Pages.page_id = Page_likes.page_id
WHERE liked_date is NULL
ORDER BY page_id
