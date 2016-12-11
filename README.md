# Markdown-to-HTML File Tree Converter

This is a really simple script that takes a folder of markdown files and converts them to HTML.

The neat thing is that it'll traverse through the input folder, include subfolders, and replicate the same structure in the output directory.

So you can make a whole series of folders with markdown files in them, and this converter will replicate the tree of files to HTML. It'll also copy over any images along the way.

When rendering to HTML, it'll use a `head.html` and `foot.html` to wrap the resulting HTML files.

Also, this will turn `README.md` files into `index.html` files, because that seems to make sense.

## Installation

This was made using Ruby 2.0.0.

Clone this repo, and then go into the new cloned directory with all of this code.

You'll need a couple gems:

```
gem install github-markup
gem install github-markdown
```

## Usage

Create `in` and `out` directories. Put your Markdown files and folders and images inside the `in` directory.

Make your `head.html` and `foot.html` templates -- I've included two examples, they're the most basic they can be.

Run the converter: `ruby converter.rb`

It'll let you know what it's doing as it traverses through your `in/` files, and writes them to the `out/` directory.

Now your `out/` folder should have your rendered files!

## To do

- [ ] Command line arguments for the `in` and `out` directories.
- [ ] Stylesheet inclusion, too?
- [ ] Syntax highlighting inclusion, too?
- [ ] What's the best way to set the title of the HTML page?
- [ ] Go through and change links in Markdown files from `[link](thing.md)` to `<a href="thing.html">link</a>`
