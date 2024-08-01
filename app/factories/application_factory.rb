# frozen_string_literal: true

class ApplicationFactory
  def self.create(...)
    new(...).create
  end

  def initialize(...); end
end
