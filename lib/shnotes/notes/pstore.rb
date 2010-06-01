# coding: utf-8

require "pstore"

module Shnotes
  module Notes
    class PStore
      attr_reader :path

      def initialize(path = "data/notes.pstore")
        @path = path
      end

      def [](id)
        all[id]
      end

      def []=(id, note)
        store.transaction do
          store[:notes] ||= {}
          store[:notes][id] = note
        end
      end

      def delete(id)
        store.transaction do
          store[:notes] ||= {}
          store[:notes].delete(id)
        end
      end

      def all
        store.transaction do
          store[:notes] ||= {}
        end
      end

      def clear
        store.transaction do
          store[:notes] = {}
        end
      end

      private

      def store
        @store ||= ::PStore.new(path)
      end
    end
  end
end