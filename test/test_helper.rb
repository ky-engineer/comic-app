ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) <- テストを実施できるようにするためにコメントアウト（並行テストを実行させないようにするらしい）
  parallelize(workers: 1)
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include SessionsHelper

  def log_in(user)
    post sessions_path, params: { session: { email: user.email, password: "password" } }
  end

end
