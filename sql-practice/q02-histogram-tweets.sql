SELECT tweet_bucket, count(user_id) as users_num
From (

SELECT user_id, count(user_id) as tweet_bucket
FROM tweets
WHERE "tweet_date" BETWEEN '2022/01/01' and '2022/12/31'
GROUP BY user_id
)
as table2 /*labelling new table*/

GROUP BY tweet_bucket
