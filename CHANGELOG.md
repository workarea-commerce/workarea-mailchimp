Workarea Mail Chimp 3.0.3 (2019-10-16)
--------------------------------------------------------------------------------

*   Fix MailChimp Test Credentials

    Update the MailChimp API Key to properly pass the client-side validation
    that prevents `Gibbon` from making the calls needed in the tests for
    MailChimp. Previously, this was a scrubbed credential and was one
    character, which apparently doesn't fly for MailChimp and it caused the
    client to block sending out requests, which was the reason behind the
    tests failing. The API Key has been regenerated with a
    `SecureRandom.hex` string and properly base64-encoded into the VCR
    cassettes, which allow the tests to pass now.

    MAILCHIMP-1
    Tom Scott

*   Update README

    Matt Duffy



Workarea Mail Chimp 3.0.3 (2019-08-22)
--------------------------------------------------------------------------------

*   Open Source! For real!



Workarea Mail Chimp 3.0.2 (2019-08-21)
--------------------------------------------------------------------------------

*   Open Source! lol jk



Workarea Mail Chimp 3.0.1 (2018-09-19)
--------------------------------------------------------------------------------

*   Pass default group as first element of an array of groups

    MAILCHIMP-13
    Jake Beresford

*   Use safe navigation operator to update attributes on user if present, and proceed if user was removed

    * Fixes failing test Workarea::Admin::EmailSignupsIntegrationTest#test_destroy

    MAILCHIMP-14
    Jake Beresford

*   Guard against nil default_group in subscribe argument builder

    * Refactor code to remove unnecessary argument passing

    MAILCHIMP-13
    Jake Beresford

*   Strip invalid characters from interest when building checkbox ID

    * Fixes bug where checkboxes cannot be selected due to presence of invalid characters.

    MAILCHIMP-12
    Jake Beresford



Workarea Mail Chimp v3.0.0 (2018-03-06)
--------------------------------------------------------------------------------

*   Correct gemserver credentials in release task

    Jake Beresford

*   Update User.email_signup in unsubscribe callback worker

    MAILCHIMP-6
    Jake Beresford

*   Unsubscribe from mailchimp should unsignup email address in Workarea

    * Additional UI for unsubscribing is unnecessary, should use existing UI and user#update logic.
    * Use a callback worker to perform ListUnsubscriber job on Email::Signup destroy
    * Remove redundant Mailchimp controller, unsubscribe action, and route

    MAILCHIMP-6
    Jake Beresford

*   Reconcile existing Email signup when creating a new account

    MAILCHIMP-7
    Jake Beresford

*   Fix checking equity between 2 group objects

    Some of this code was removed during the v3 compatibility upgrade, this caused a bug with editing preferences in the user account.

    * Re-write == method for groups, reduce complexity of this function to make it more readable
    * Iterate over all group interests and compare to current_user groups
    * Add SubscriptionEdit callback worker to update Mailchimp with changes to groups
    * Do not enqueue worker unless user is subscribed to emails
    * Update decorated email_signup? method to call super

    MAILCHIMP-5
    Jake Beresford

*   Account footer subscription should include all interest groups

    * If a user isn't passed, merge all groups in to the subscribe arguments
    * Add unit test for subscription interest groups
    * Update VCR casettes

    Unrelated changes:
    * Add instructions to get list & list preference IDs from mailchimp to README

    MAILCHIMP-4
    Jake Beresford

*   Fix error on account creation

    Account creation triggers the list_subscriber job, account_created_email_subscriber was redundant and causing the UserAlreadySubscribed to be raised.

    * Workarea will not allow multiple Email::Subscriptions to save, removed custom error as it is also redundant.
    * Rubocop wanted some love

    MAILCHIMP-3
    Jake Beresford

*   * Allow sidekiq retry for all workers * Raise custom error if a user is already subscribed

    MAILCHIMP-1
    Jake Beresford

*   Remove eql method from MailChimp::Group

    * Method was not necessary and could cause unwanted side-effects

    MAILCHIMP-1
    Jake Beresford

*   Use bogus gateway and remove conditions to check for gateway presence

    MAILCHIMP-1
    Jake Beresford

*   Compose all interests from all groups for user

    MAILCHIMP-1
    Jake Beresford

*   Fix implementation of user_params to correctly apply group interests

    Jake Beresford

*   Use ignore_if to prevent sidekiq job being enqueued if it should not be performed.

    MAILCHIMP-1
    Jake Beresford

*   Merge user account permitted params with super

    MAILCHIMP-1
    Jake Beresford

*   Upgrade for v3 compatibility

    * Rename to workarea & storefront
    * Convert decorators into .decorator files
    * Convert rspec to minitest
    * Add test/dummy and test_helper
    * Add bin/rails
    * Add dotfiles
    * Install rubocop and get all cops passing with rails defaults
    * remove some redundant files
    * before_filter -> before_action
    * Loosen version dependency on workarea
    * Cleanup redundant airbrake notifications
    * move appends to initializer
    * Update markup of user account views & add translations to storefront
    * Use email_signup instead of email_subscribe to match user model
    * Add callback worker for email subscription on account creation
    * Move unsubscriber action to mail chimp controller and update user account page UI to make more sense
    * Get default preferences working properly
    * Update where email interest groups are displayed for proximity to edit interface
    * Fix incorrect hash property accessors in group.rb
    * Set default_groups to empty array if no gateway is defined, like in test

    MAILCHIMP-1
    Jake Beresford



Workarea Mail Chimp v2.0.2 (2016-06-28)
--------------------------------------------------------------------------------

*   Minor Mailchimp tweaks to workaround unavoidable errors

    Add 500 and 400 to acceptable error codes and set retries to false for the workers
    Refactor the listener for Email::Signups to work properly
    David Freiman



Workarea Mail Chimp v2.0.1 (2016-04-29)
--------------------------------------------------------------------------------

*   Bugfix callback ensures it has valid data

    Bump version and better syntax
    David Freiman



Workarea Mail Chimp v2.0.0 (2016-04-26)
--------------------------------------------------------------------------------

*   Update Rakefile to reflect the standard

    Remove strict version dependancy on Gibbon
    David Freiman

*   Mailchimp Engine upgrade to MC API3

    Change api adapter to use Gibbon instead of Feralchimp and update dependencies
    Need to modify the gateway to call specific http methods on the wrapper. Began with modifying the lists
    and members gateways. Still much modification to be done but proof of concept with subscribe, unsubscribe
    and fetch single member details already complete

    Update gateway to V3 API - all specs passing

    Need to ensure workflow works with groups
    Changed all api calls to go through the perform request as an output point
    added spec to ensure the lists interests function is working
    lists interests needs two calls - one to get all categories, another to get details of each category

    Rework Error handling

    Only raise error for unacceptable errors - 404s should return an error hash
    Update specs to use expect syntax instead of should
    all tests passing

    Mailchimp Listener Fixes

    Refactor listener to work with updated flow, and send the proper subscribe, unsubscribe info
    Rework partials to display on the correct append points
    update readme
    all specs passing

    Update subscribe call to pass proper name fields

    Modified doubles in the spec to use the proper format and fields sent to v3 api are slightly different.

    Mailchimp interests now sending succesfully

    limitation - not sending when a user's interests are modified only when the interest itself is modified
    Refactored groups to store interests as a hash and modified all mock data accordingly
    Sending interests to MC in updated API v3 requires sending interest_id so updated the builder to handle that logic
    All tests passing

    Mailchimp interest integration updates

    allowed a user to modify their interests and have deselected interest reflect in mailchimp
    currently not firing when interests changed, only when user is updated

    updated code style to match tailor standards

    Interests sending on update

    update to ensure interests send whenever a user is updated
    remove old code from builders where unneccessary

    Update Return value of lists to return empty array in case of error
    David Freiman
