require "test_helper"

class Workarea::MailChimp::GatewayTest < Workarea::SystemTest
  include Workarea::MailChimpApiConfig

  setup :gateway

  def gateway
    @gateway ||= Workarea::MailChimp.gateway
  end

  def vcr_args
    @vcr_args ||= { record: :once, match_requests_on: [:method, :uri, :body] }
  end

  def user
    @user ||= Workarea::User.new(
      id: "1",
      first_name: "Michael",
      last_name: "Dalton",
      groups: []
    )
  end

  def test_new_subscriptions_when_subscribing_with_just_an_email_address
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      email = "jyucis-mailchimp@workarea.com"

      response = VCR.use_cassette("subscribe_to_default_list", vcr_args) do
                   @gateway.subscribe email
                 end

      assert(response)

      if response.is_a? Hash
        refute(response.key?("error"))
      end
    end
  end

  def test_subscribing_with_just_an_email_address_adds_all_interest_groups
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      email = "jyucis-mailchimp@workarea.com"

      response = VCR.use_cassette("subscribe_to_default_list_interest_groups", vcr_args) do
                   @gateway.subscribe email
                 end

      assert(response.body["interests"].present?)
      assert(response.body["interests"].length == 4)
    end
  end

  def test_new_subscriptions_when_subscribing_with_an_email_address_and_user_details
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      email = "jyucis-mailchimp-2@workarea.com"

      response = VCR.use_cassette("subscribe_to_default_list_with_user_details", vcr_args) do
                   @gateway.subscribe email, user: user
                 end

      assert(response)

      if response.is_a? Hash
        refute(response.key?("error"))
      end
    end
  end

  def test_new_subscriptions_when_subscribing_with_an_email_address_and_groupings
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      email = "jyucis-mailchimp-3@workarea.com"

      response = VCR.use_cassette("subscribe_to_default_list_with_groupings", vcr_args) do
                   @gateway.subscribe email, user: user
                 end

      assert(response)

      if response.is_a? Hash
        refute(response.key?("error"))
      end
    end
  end

  def test_udpates_to_subscriptions_when_updating_email_address
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      current_email = "jyucis-mailchimp-2@workarea.com"
      new_email = "jyucis-mailchimp-4@workarea.com"

      response = VCR.use_cassette("update_member_on_default_list_change_email", vcr_args) do
                   @gateway.subscribe current_email, new_email: new_email
                 end

      assert(response)

      if response.is_a? Hash
        refute(response.key?("error"))
      end
    end
  end

  def test_udpates_to_subscriptions_when_udpating_groupings
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      email = "jyucis-mailchimp-3@workarea.com"

      response = VCR.use_cassette("update_member_on_default_list_change_groupings", vcr_args) do
                   @gateway.subscribe email, user: user
                 end

      assert(response)

      if response.is_a? Hash
        refute(response.key?("error"))
      end
    end
  end

  def test_unsubscribe_from_default_list
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      email = "jyucis-mailchimp@workarea.com"

      response = VCR.use_cassette("unsubscribe_from_default_list", vcr_args) do
                   @gateway.unsubscribe email
                 end

      assert(response)

      if response.is_a? Hash
        refute(response.key?("error"))
      end
    end
  end

  def test_list_returns_groups
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      groups = [Workarea::MailChimp::Group.new(email_all_interests_hash)]

      response = VCR.use_cassette("get_default_list_interests", vcr_args) do
                   @gateway.list.interests
                 end

      assert_match(groups.first[:name], response.first[:name])

      assert_match(groups.first[:interests]["7ca6cc1d86"], response.first[:interests]["7ca6cc1d86"])
      assert_match(groups.first[:interests]["8911545594"], response.first[:interests]["8911545594"])
      assert_match(groups.first[:interests]["542a7ec7bb"], response.first[:interests]["542a7ec7bb"])
      assert_match(groups.first[:interests]["6908d70674"], response.first[:interests]["6908d70674"])
    end
  end

  def test_get_member_details_returns_nil_when_email_does_not_exist_in_mailchimp
    Workarea.with_config do |config|
      config.mail_chimp.default_list_id = 'fcd2925136'
      config.mail_chimp.email_interests_id = '443f5598e4'

      response = VCR.use_cassette("get_member_details_no_match", vcr_args) do
                   @gateway.members.details("mdalton-doesnotexist@workarea.com")
                 end

      assert_nil(response)
    end
  end

  def test_get_member_details_returns_nil_when_email_has_unsubscribed_in_mailchimp
    response = VCR.use_cassette("get_member_details_unsubscribed", vcr_args) do
                 @gateway.members.details("test-unsubscribed@workarea.com")
               end

    assert_nil(response)
  end
end
