# frozen_string_literal: true

require 'term/ansicolor'

class RakeAnnouncer
  def self.log_step(message)
    puts("\n#{Term::ANSIColor.blue}#{Term::ANSIColor.underline}● #{message}#{Term::ANSIColor.reset}")
  end
end
