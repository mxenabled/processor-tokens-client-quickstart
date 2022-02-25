# frozen_string_literal: true

require 'mx-platform-ruby'
require 'test_helper'

class MxHelperTest < ActiveSupport::TestCase
  test 'the truth' do
    assert true
  end

  test 'name comes from metadata json' do
    api_user = ::MxPlatformRuby::UserResponse.new
    api_user.email = 'testemail'
    api_user.metadata = '{"name":"testname"}'
    api_user.guid = 'testguid'

    userInstance = ::MxHelper::UserAdapter.apiUserToModel(api_user)

    assert_equal userInstance.name, 'testname', 'User name came from api user metadata'
    assert_equal userInstance.email, 'testemail', 'User email transferred from api'
    assert_equal userInstance.guid, 'testguid', 'User guid transferred from api'
  end

  test 'name is blank when metadata has no name field' do
    api_user = ::MxPlatformRuby::UserResponse.new
    api_user.email = 'testemail'
    api_user.metadata = '{}'
    api_user.guid = 'testguid'

    userInstance = ::MxHelper::UserAdapter.apiUserToModel(api_user)

    assert_equal userInstance.name, '', "User name was not provided from api user's metadat"
  end

  test 'handles bad json gracefully' do
    api_user = ::MxPlatformRuby::UserResponse.new
    api_user.email = 'testemail'
    api_user.metadata = 'testname'
    api_user.guid = 'testguid'

    userInstance = ::MxHelper::UserAdapter.apiUserToModel(api_user)

    assert_equal userInstance.name, '', 'metadata needs to be json'
  end
end
