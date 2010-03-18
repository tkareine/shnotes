require "sinatra/base"
require "digest/md5"
require "json"

require "shnotes"

module Shnotes
  class App < Sinatra::Base
    Notes.store_location = "data/notes.pstore"

    get "/" do
      Notes.notes.to_json
    end

    get "/:id" do
      note = Notes.notes[params[:id]]
      if note
        note.to_json
      else
        halt 404, "No such note"
      end
    end

    post "/" do
      note = params[:note].strip
      unless blank? note
        id = Digest::MD5.hexdigest(note)
        Notes.put_note(id, note).to_json
      else
        halt 400, "No note"
      end
    end

    delete "/:id" do
      note = Notes.delete_note(params[:id])
      if note
        note.to_json
      else
        halt 404, "No such note"
      end
    end
  end
end
