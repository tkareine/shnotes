require "sinatra/base"
require "digest/md5"
require "json"
require "shnotes"

module Shnotes
  class App < Sinatra::Base
    include Helpers

    class << self
      attr_accessor :notes
    end

    @notes = Shnotes::Notes.new

    before do
      content_type :json, :charset => "utf-8"
    end

    get "/" do
      App.notes.all_notes.to_json
    end

    get "/:id" do
      note = App.notes.all_notes[params[:id]]
      not_found "No such note" unless note
      note.to_json
    end

    post "/" do
      note = params[:note]
      error 400, "No note" unless note
      note.strip!
      error 400, "Not a valid note" if blank? note
      id = Digest::MD5.hexdigest(note)
      App.notes.put_note(id, note)
      {:id => id, :note => note}.to_json
    end

    delete "/:id" do
      note = App.notes.delete_note(params[:id])
      not_found "No such note" unless note
      note.to_json
    end
  end
end
