module Workarea
  module MailChimp
    class SubscriptionEdit
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options(
        enqueue_on: {
          User => [:save],
          ignore_if: -> { !SubscriptionEdit.should_enqueue?(id) }
        },
        queue: "low",
        retry: true
      )

      def self.should_enqueue?(id)
        user = User.find(id)
        user.email_signup
      end

      def perform(id)
        user = User.find(id)

        Workarea::MailChimp.gateway.subscribe(user.email, user: user)
      end
    end
  end
end
