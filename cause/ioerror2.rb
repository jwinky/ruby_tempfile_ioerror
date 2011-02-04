# Run with script/runner ioerror2.rb
#
# Second method of reproducing an IOError

# This causes IOErrors in both ruby-1.8.7 and ree-1.8.7

$DEBUG = true
require 'tempfile'
"a"
Tempfile.new('a').open.close
Tempfile.new('a').open.close
GC.start

