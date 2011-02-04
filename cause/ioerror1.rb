# Run with script/runner ioerror1.rb
#
# First method of reproducing an IOError

# Causes errors in ruby-1.8.7 but not ree-1.8.7.  
# Uncommenting the last line DOES cause an IOError under REE, so most likely GC isn't running at the same times.

$DEBUG = true
require 'tempfile'

1000.times { Tempfile.new('a').open.close }

