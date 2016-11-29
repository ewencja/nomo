## Installation

1. `gem install nokogiri` (Required for XML parsing)



## Usage

1. Identify useful page category (example: [Given names](https://en.wikipedia.org/wiki/Category:Given_names))
2. Export using Wikipedia's [Category Export](https://en.wikipedia.org/wiki/Special:Export)
3. Parse: `./parse.rb CategoryExport.xml`


## Data Research Howto

### Step 1: Wikipedia Export
Wikipedia provides several exports:

[Documentation for English language Wikipedia](https://en.wikipedia.org/wiki/Wikipedia:Database_download#English-language_Wikipedia)

One of them is the [Category Export](https://en.wikipedia.org/wiki/Special:Export).

Wikipedia has a category for given names:

- [Given names](https://en.wikipedia.org/wiki/Category:Given_names)

Use the Category Export to get an XML export of the data (ca. 10MB, 5000 names).

Choose the current revision only.

### Step 2: Explore the XML file
Open, for example, in Chrome:

~~~~
open -a /Applications/Google\ Chrome.app CategoryExport-Given_names.xml
~~~~

Understand the architecture of the file and which data you need to export.

~~~~
mediawiki
    siteinfo
    page
        title             <---
        ns
        id
        revision
            id
            parentid
            timestamp
            contributor
                username
                id
            minor
            comment
            model
            format
            text          <---
            sha
    page
    page
    ...    
~~~~

From each page, we need the `title` and the `text` which we'll need to parse more.

### Step 3: Explore the text content

Wikipedia can still be sparsely populated. Many articles contain non-standard formatting.

Most -- but not all (!) -- articles have an Infobox:

~~~~
{{Infobox given name
| name = Charles
| gender = Male
| ...
}}
~~~~

You can extract this infobox and many properties about each name from there.

To do this, regular expressions are useful.

While writing, never just blindly write for the best case. Input data is usually at least a bit dirty and deviates here and there.

For example, check out the name `Kyle`, which contrary to most entries, has a leading space. Visually barely noticeable, but it might not match your regular expression if it's too exact and you will loose information.

~~~~
 | name = Kyle
 | image =
 | imagesize =
 | caption =
 | gender = [[Unisex]] | meaning = from a surname
 | Language = Scottish Gaelic
 | related names =[[Kylie (name)|Kylie]], [[Kyla (given name)|Kyla]]
 | footnotes =
~~~~

Or the name `Bagrat` which, in the title field, contains an HTML break `<br>` followed by the Georgian writing of the name:

~~~~
| name = Bagrat <br>ბაგრატი
| image=
| image_size=
| caption=
| pronunciation=
| gender = Male
| meaning = [[Old Persian]] ''Bagadāta'', "gift of God"
| language = Armenian, Georgian
| seealso =
~~~~

This is a dirty way of storing information, because it mixes semantic with markup. Ideally someone at Wikipedia (maybe you?) will realize that the `given name2` infobox should support spellings of the name in different languages and provide a better way for doing this.

Always parse a little more of the input and compare what's coming out, and handle exceptions along the way.

A good way to investigate this is to write a regular expression what what you would expect e.g. a line to be, and then exclude all of the lines that match. You'll be left with the rest.

### Step 4: Write and import data
Write cool code, yo.
