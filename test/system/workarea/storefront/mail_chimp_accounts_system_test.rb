require 'test_helper'

module Workarea
  module Storefront
    class MailChimpAccountsSystemTest < Workarea::SystemTest
      setup :set_user

      def test_editing_mail_chimp_interests
        set_current_user(@user)
        visit storefront.edit_users_account_path

        interests = MailChimp.gateway.interests.map(&:interests).reduce(:merge).values.sample(3)

        within '#info_form' do
          interests.each do |interest|
            check interest
          end
         click_button t('workarea.storefront.forms.save')
        end

        @user.reload

        assert_equal interests.sort, @user.groups.map(&:interests).reduce(&:merge).values.sort

        old_interests = interests.sample 2
        new_interests = interests - old_interests

        visit storefront.edit_users_account_path

        within '#info_form' do
          old_interests.each do |interest|
            uncheck interest
          end
         click_button t('workarea.storefront.forms.save')
        end

        @user.reload

        assert_equal new_interests.sort, @user.groups.map(&:interests).reduce(&:merge).values.sort
      end

      def test_saving_without_editing_mail_chimp_interests
        set_current_user(@user)

        interests = MailChimp.gateway.interests.map(&:interests).reduce(:merge).values.sample(3)

        visit storefront.edit_users_account_path
        within '#info_form' do
          interests.each do |interest|
            check interest
          end
         click_button t('workarea.storefront.forms.save')
        end

        @user.reload

        assert_equal interests.sort, @user.groups.map(&:interests).reduce(&:merge).values.sort

        visit storefront.edit_users_account_path
        within '#info_form' do
         click_button t('workarea.storefront.forms.save')
        end

        @user.reload
        assert_equal interests.sort, @user.groups.map(&:interests).reduce(&:merge).values.sort
      end

      private

        def set_user
          @user = create_user(
            email: 'bcrouse@workarea.com',
            password: 'W3bl1nc!',
            name: 'Ben Crouse'
          )
        end
    end
  end
end
