require "test_helper"

module Workarea
  class MailChimp::GroupTest < Workarea::SystemTest
    def new_group(interest)
      Workarea::MailChimp::Group.new(_id: 1, interests: { interest + "id" => interest })
    end

    def test_invalid_without__id_or_name
      refute(Workarea::MailChimp::Group.new(interests: { "id" => "foo" }).valid?)
    end

    def test_valid_with_just__id
      assert(Workarea::MailChimp::Group.new(_id: 1).valid?)
    end

    def test_valid_with_just_name
      assert(Workarea::MailChimp::Group.new(name: "foo").valid?)
    end

    def test_equality_of_groups
      group_1 = Workarea::MailChimp::Group.new(name: "foo", interests: { "id" => "foo" })
      group_2 = Workarea::MailChimp::Group.new(name: "foo", interests: { "id" => "foo" })
      group_3 = Workarea::MailChimp::Group.new(name: "foo", interests: { "id" => "bar" })
      group_4 = Workarea::MailChimp::Group.new(name: "bar", interests: { "id" => "bar" })

      assert(group_1 == (group_1))
      assert(group_1 == (group_2))
      refute(group_1 == (group_3))
      refute(group_3 == (group_4))
    end
  end
end
