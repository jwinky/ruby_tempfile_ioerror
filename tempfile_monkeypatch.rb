# Fixes IOErrors occuring as a result of a problem with garbage collection and the Tempfile class which is not well understood.
#
# tempfile.rb:167 is the source of IOErrors.  In some cases GC runs the finalizer, which calls #close on a File object that has
# already been closed.  This monkey patch fixes the problem by making it safe to call #close on a File object multiple times.
#

unless RUBY_VERSION == '1.8.7' && RUBY_PATCHLEVEL == 299
  raise "ERROR: Invalid ruby version #{RUBY_DESCRIPTION}.  The IOError monkey patch was written against 1.8.7-p299"
end

require 'tempfile'

class Tempfile
  class << self
      def callback(data)	# :nodoc:
        pid = $$
        lambda{
    if pid == $$
      path, tmpfile, cleanlist = *data

      print "removing ", path, "..." if $DEBUG

      tmpfile.close if tmpfile && !tmpfile.closed?

      # keep this order for thread safeness
      File.unlink(path) if File.exist?(path)
      cleanlist.delete(path) if cleanlist

      print "done\n" if $DEBUG
    end
        }
      end
  end
end