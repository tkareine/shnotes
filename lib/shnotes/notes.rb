# coding: utf-8

module Shnotes
  module Notes
    def self.init_db(db_type, *args)
      case db_type.to_sym
      when :pstore
        require "shnotes/notes/pstore"
        Notes::PStore
      when :redis
        require "shnotes/notes/redis"
        Notes::Redis
      else
        raise ArgumentError, "Unknown database type"
      end.new(*args)
    end
  end
end
