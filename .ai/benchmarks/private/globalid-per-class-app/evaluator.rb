# frozen_string_literal: true
# Coordinator-only evaluator. Run from the candidate repository after it has stopped.
require 'bundler/setup'
require 'global_id'
require 'minitest/autorun'

module AppContractFixture
  class Record
    include GlobalID::Identification
    attr_reader :id
    def initialize
      @id = 37
    end
  end

  class Configured < Record; end
  class Child < Configured; end

  class MethodOverride < Configured
    def to_global_id(options = {})
      super({ app: 'method-app' }.merge(options))
    end

    def to_signed_global_id(options = {})
      super({ app: 'signed-method-app' }.merge(options))
    end
  end
end

class PerClassAppContract < Minitest::Test
  def setup
    GlobalID.app = 'global-default'
    SignedGlobalID.verifier = ActiveSupport::MessageVerifier.new('isolated-evaluator-secret')
  end

  def configured
    AppContractFixture::Configured.global_id_app = 'class-default'
    AppContractFixture::Configured.new
  end

  def test_unconfigured_class_keeps_global_default
    record = AppContractFixture::Record.new
    assert_equal 'global-default', record.to_global_id.app
    assert_equal 'global-default', record.to_signed_global_id.app
  end

  def test_class_default_applies_to_normal_signed_and_parameter_aliases
    record = configured
    assert_equal 'class-default', record.to_global_id.app
    assert_equal 'class-default', record.to_gid.app
    assert_equal 'class-default', GlobalID.parse(record.to_gid_param).app
    assert_equal 'class-default', record.to_signed_global_id.app
    assert_equal 'class-default', record.to_sgid.app
    assert_equal 'class-default', SignedGlobalID.parse(record.to_sgid_param).app
    assert_equal 'global-default', GlobalID.app
  end

  def test_explicit_options_win_without_mutating_caller_hash
    record = configured
    options = { app: 'call-override' }.freeze
    assert_equal 'call-override', record.to_global_id(options).app
    assert_equal 'call-override', record.to_signed_global_id(options).app
    assert_equal({ app: 'call-override' }, options)
    assert_equal 'class-default', record.to_global_id.app
  end

  def test_subclass_inherits_until_it_configures_its_own_default
    configured
    assert_equal 'class-default', AppContractFixture::Child.new.to_gid.app
    AppContractFixture::Child.global_id_app = 'child-default'
    AppContractFixture::Configured.global_id_app = 'parent-updated'
    assert_equal 'child-default', AppContractFixture::Child.new.to_sgid.app
    assert_equal 'parent-updated', AppContractFixture::Configured.new.to_gid.app
  end

  def test_aliases_dispatch_to_overridden_methods
    record = AppContractFixture::MethodOverride.new
    assert_equal 'method-app', record.to_gid.app
    assert_equal 'method-app', GlobalID.parse(record.to_gid_param).app
    assert_equal 'signed-method-app', record.to_sgid.app
    assert_equal 'signed-method-app', SignedGlobalID.parse(record.to_sgid_param).app
  end

  def test_invalid_class_app_uses_existing_validation
    configured
    assert_raises(ArgumentError) { AppContractFixture::Configured.global_id_app = 'invalid app/path' }
    assert_equal 'class-default', AppContractFixture::Configured.new.to_gid.app
  end
end
