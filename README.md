This app was created as an exercise. The following requirements where given:

 * This will be a forum where users go to the root of the site to see the most recent posts. Non-members will see all public posts by default while members will see just their own posts when they explicitly go to posts/index, but will also have the option to click a “View All Posts” link
 * Posts have a title (75 character max) , a body and a public field.
 * Public posts and any of their comments can be viewed by members and non-members alike
 * Users must sign up to become a member
 * Users must enter a username, an email address and a password to become a member
 * Members can log in and out
 * Members can edit their email and password
 * Members have the ability to view just their own posts if they choose
 * Members can edit or delete their own posts only
 * Private posts and their comments can only be viewed by members
 * Only members can post or comment on posts
 * The titles and bodies of posts can be searched
    * When a non-member searches all posts are searched, but just the titles are displayed..
 * Posts can be sorted by days old (default), number of comments,  or title
 * Each member’s posts will display their username 
 * Wherever usernames are displayed they should be links which when clicked show all the posts (and responses?) the user has created
 * When posts are over a certain length they get truncated with a link that allows the rest of it to be displayed (in page) and re-hidden
 * The number of comments is displayed for each post
 * Look and Feel
    * Should be simple & clean with subtly bright colors
    * Use slightly rounded corners where possible
    * Shouldn’t appear too formal

Enter new posts
 1. Visit root of site ("/")
 2. Click on "Become a member"
 3. Enter Username, Email and Password
 4. Create User

Click "Create new Post"
 5. Enter a title and some body text (try pasting in over 255 chars on one)
 6. Check Public for at least one and uncheck for at least one
 7. Submit Post
 8. Repeat a few times

Member Viewing Posts
 9. Click "View all Posts"
 10. Should see all posts ordered by age descending
 11. Try other Sort by fields
 12. Fill in search with a word or part of a word that appears in the title or body of posts and press enter
 13. Click on the remove icon to clear the search results

Member adding Comments to a post
 14. Click on the "add a comment" link in one of the posts
 15. Enter over 255 characters
 16. Add Comment
 17. Should see a more link where there is over 255 characters
 18. Click on "[more]" and "[less]" to test the truncation fucntionality

Member manages Posts
 19. Click on the "View your Posts" link
 20. Edit and/or delete some of your posts

Member manages settings
 21. Click on your username in the top left
 22. Edit your info

Member Logs out
 23. Click the "Member log out" link in the top right

Non-member views posts:
 1. Visit root of site ("/")
 2. Should only see public posts
 3. Click on "add comment" (should get a message that you need to be logged in)
 4. Click on "posted by " Username to see the public posts from that user only
 5. Search will return results from both public and private posts, but provate posts won't show the body

   (rom README.md)