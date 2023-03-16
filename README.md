Playing with AWS' cli MFA Authentication

## Todos

- [ ] The login function currently takes user input for access keys and region. It may be better to instead take these as arguments when initializing the class, so that the user does not need to enter them each time they want to authenticate.
- [ ] The pause function could be made more robust by checking for any key press instead of just any key.
- [ ] Make variable names more descriptive, e.g. awsDirectory instead of AWS_DIRECTORY.
- [ ] Add error handling to the class, so that if an error occurs during authentication, the user is given a helpful error message.

....
