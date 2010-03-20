require "pstore"

module Shnotes
  class Notes
    attr_reader :path

    def initialize(path = "data/notes.pstore")
      @path = path
    end

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

    def all_notes
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
      @store ||= PStore.new(path)
    end
  end
end
