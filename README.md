RubyReader
==========

Basic RoR application that does something similar to Google Reader now that it will be going away soon.

Feeds can be added and will be fetched on a timed basis and then cached for later viewing.

Installation
------------
  

TODOs
----

- [ ] Add documentation for install and dependencies
- [ ] Add authentication for feed management
- [ ] Add JavaScript lib to show the updated times on how old the feed entry is (2 hours ago, 1 day ago, etc...)
- [ ] Add support for infinite scrolling
- [ ] Simplify the feed creating form (only needs the rss feed url, everything else is autofilled in).
- [ ] Develop some mechanism to intelligently determine when to refetch the feed.  
- [ ] Look at how many posts where found in the last x.hour window and use that to lengthen/shorten the update interval
- [ ] Look at the time of day (late at night doesn't need as many updates)
- [ ] Look at the TTL value from the feed if available
  
   
Contributing
------------

  1. Fork it
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create new Pull Request
  
License
-------

MIT - see [LICENSE.txt](LICENSE.txt)
