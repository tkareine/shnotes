require "shnotes/notes/pstore"

module Shnotes
  module Notes
    def self.init_db(db_type, *args)
      case db_type.to_sym
      when :pstore
        Notes::PStore.new(*args)
      else
        raise ArgumentError, "Unknown database type"
      end
    end
  end
end
