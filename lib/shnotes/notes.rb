module Shnotes
  module Notes
    def self.init_db(db_type, *args)
      case db_type.to_sym
      when :pstore
        require "shnotes/notes/pstore"
        Notes::PStore.new(*args)
      when :redis
        require "shnotes/notes/redis"
        Notes::Redis.new(*args)
      else
        raise ArgumentError, "Unknown database type"
      end
    end
  end
end
