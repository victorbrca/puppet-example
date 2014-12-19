# Templates



- <% Open Ruby Code
- = Prints out a variable
- @ 
- - Omit line breaks


Ruby for.

For each item in "servers" ; do print "server = [current array value]"

```ruby
<% @servers.each do |server| -%>
server <%= server %>
<% end - %>
```