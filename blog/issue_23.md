testing for issueblogger|this is just to apply and reaplly the blog tag|

A good solution would be to use the "git tag" command to apply and reapply the "blog" tag. This can be done by running the following commands:

1. `git tag -a blog <commit_id>` - This creates a new tag with the name "blog" and attaches it to the specified commit.
2. `git push origin --tags` - This will push all tags to the remote repository.
3. `git tag -d blog` - This will delete the tag "blog".
4. `git push origin :refs/tags/blog` - This will delete the tag "blog" from the remote repository.|no i mean the gh cli with gh issue edit $ISSUE_NUMBER --add-label blog|but i think this is almost complete? lets try once more