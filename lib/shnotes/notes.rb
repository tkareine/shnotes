require "pstore"

module Shnotes
  module Notes
    class << self
      attr_accessor :store_location

      def put_note(id, note)
        store.transaction do
          store[:notes] ||= {}
          store[:notes][id] = note
        end
      end

      def delete_note(id)
        store.transaction do
          store[:notes] ||= {}
          store[:notes].delete(id)
        end
      end

      def notes
        store.transaction do
          store[:notes] ||= {}
        end
      end

      def clear_notes
        store.transaction do
          store[:notes] = {}
        end
      end

      private

      def store
        @store ||= begin
          raise "Notes store location is not defined" unless store_location
          PStore.new(store_location)
        end
      end
    end
  end
end
