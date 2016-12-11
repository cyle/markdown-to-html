require 'github/markup'

# our in and out paths; would be nice if these were command line args
in_path = './in'
out_path = './out'

# what are we going to pay attention to...
$file_extensions_to_render = ['.md', '.markdown']
$file_extensions_to_copy = ['.jpg', '.jpeg', '.png', '.gif']

puts "reading files and folders inside " + in_path
puts "writing the result to " + out_path

puts "loading templates..."
$head_html = File.read('./templates/head.html') # maybe make this a command line arg too?
$foot_html = File.read('./templates/foot.html') # maybe make this a command line arg too?

puts "clearing out files from " + out_path
clear_out_dir = `rm -rf #{out_path}/*` # byebye

# do some traversal
puts "traversing input path..."
$dirs = Array.new
$files_to_render = Array.new
$files_to_copy = Array.new

# this could probably wrap up way more into it
# also, there's no traversal limit right now...
def traverse(path)
    Dir.foreach(path) do |item|
        next if item == '.' or item == '..'
        realpath = path + '/' + item
        next if File.symlink?(realpath)
        if File.directory?(realpath)
            $dirs.push(realpath)
            traverse(realpath) # go deeper
        elsif $file_extensions_to_render.include?(File.extname(item))
            $files_to_render.push(realpath)
        elsif $file_extensions_to_copy.include?(File.extname(item))
            $files_to_copy.push(realpath)
        end
    end
end

# kick it off
traverse(in_path)

puts "replicating found directories:"
puts $dirs

$dirs.each do |file|
    path_to_make = file.gsub(in_path, out_path)
    Dir.mkdir(path_to_make)
end

puts "rendering found markdown files:"
puts $files_to_render

# let's render these files
$files_to_render.each do |file|
    rendered = GitHub::Markup.render(file) # the actual render step
    file_to_make = file.gsub(in_path, out_path).gsub('.md', '.html').sub('README.html', 'index.html')
    puts "rendering file to " + file_to_make
    File.open(file_to_make, 'w') do |f|
        f.write($head_html) # write the head template first
        f.write(rendered) # next write the rendered file contents
        f.write($foot_html) # write the foot template last
    end
end

puts "other files to copy to the output directory:"
puts $files_to_copy

# copy all the extra stuff
$files_to_copy.each do |file|
    file_to_make = file.gsub(in_path, out_path)
    File.copy_stream(file, file_to_make)
end

puts "all done!"
