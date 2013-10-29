# Fixes IOErrors occuring as a result of a problem with garbage collection and the Tempfile class which is not well understood.
#
# tempfile.rb:167 is the source of IOErrors.  In some cases GC runs the finalizer, which calls #close on a File object that has
# already been closed.  This monkey patch fixes the problem by making it safe to call #close on a File object multiple times.
#

require 'tempfile'

if RUBY_VERSION == '1.8.7' && RUBY_PATCHLEVEL == 299
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
end

if RUBY_VERSION == '1.9.3' && RUBY_PATCHLEVEL == 448
  class Tempfile
  
    class Remover
      def initialize(data)
        @pid = $$
        @data = data
      end

      def call(*args)
        return if @pid != $$

        path, tmpfile = *@data

        STDERR.print "removing ", path, "..." if $DEBUG

        tmpfile.close if tmpfile && !tmpfile.closed?

        if path
          begin
            File.unlink(path)
          rescue Errno::ENOENT
          end
        end

        STDERR.print "done\n" if $DEBUG
      end
    end

  end
end