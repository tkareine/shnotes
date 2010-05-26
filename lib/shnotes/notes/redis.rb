require "redis"

module Shnotes
  module Notes
    class Redis
      def initialize(options = {})
        @store = ::Redis.new(options)
      end

      def [](id)
        @store.get note_identity(id)
      end

      def []=(id, note)
        @store.set note_identity(id), note
      end

      def delete(id)
        value = self[id]
        @store.del note_identity(id)
        value
      end

      def all
        keys = @store.keys(note_identity('*')).split(' ')
        result = {}
        return result if keys.empty?
        # do not use Redis#mapped_mget, since we want to have control over the
        # keys
        @store.mget(*keys).each do |value|
          key = keys.shift
          unless value.nil?
            id = key.slice(/^notes:(.+)$/, 1)
            result.merge!(id => value)
          end
        end
        result
      end

      def clear
        @store.flushdb
        {}
      end

      private

      def note_identity(id)
        "notes:#{id}"
      end
    end
  end
end
