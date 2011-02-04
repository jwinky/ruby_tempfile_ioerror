# Run with script/runner ioerror3.rb
#
# Third method of reproducing an IOErrorrequire 'tempfile'

# This causes IOErrors in only ruby-1.8.7.  I have no clue why REE is fine here but not with ioerror2.rb. 

$DEBUG = true
"a"
a = Tempfile.new('a')
a.open.close
b = Tempfile.new('a')
b.open.close
GC.start

