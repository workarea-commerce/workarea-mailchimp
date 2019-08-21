require "test_helper"

module Workarea
  class MailChimp::SubscriptionTest < Workarea::IntegrationTest
    setup :users

    def users
      @user ||= create_user
      @user.update_attributes(email_signup: true)
      @user
    end

    def updated_params
      @updated_params ||= { groups: [email_interests_hash] }
    end

    def test_groups_is_set_to_default_groups
      assert_equal(User.default_groups, users.groups)
    end

    def test_groups_is_not_set_to_default_groups_when_groups_are_set
      groups = [Workarea::MailChimp::Group.new(email_interests_hash)]
      users.update_attributes(groups: groups)

      assert_equal(groups, users.groups)
    end

    def test_group_updated_when_group_exists
      params = { groups: [email_interests_hash] }
      group = Workarea::MailChimp::Group.new(params[:groups].first)
      updated_group = Workarea::MailChimp::Group.new(updated_params[:groups].first)
      users.update_attributes(params)

      assert_equal(users.groups[0], group)
      users.update_attributes(updated_params)
      assert_equal(users.groups[0], updated_group)
    end

    def test_user_email_signup_true_when_email_signup_exists_with_matching_email_address
      user_email = "mailchimp-test@weblinc.com"
      Email::Signup.new(email: user_email).save

      post storefront.users_account_path,
          params: {
            email: user_email,
            password: "W3bl1nc!"
          }

      assert(User.find_by(email: user_email).email_signup?)
    end
  end
end
