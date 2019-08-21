module Workarea
  module MailChimp
    class ListSubscriber
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options(
        enqueue_on: { Email::Signup => [:save] },
        queue: "low",
        retry: true
      )

      def perform(email_signup_id)
        signup = Email::Signup.find(email_signup_id)
        @user = User.find_by(email: signup.email) rescue nil

        if @user
          Workarea::MailChimp.gateway.subscribe(@user.email, user: @user)
          update_user_subscription
        else
          Workarea::MailChimp.gateway.subscribe(signup.email)
        end
      end

      def update_user_subscription
        @user.update_attributes(email_signup: true)
      end
    end
  end
end
