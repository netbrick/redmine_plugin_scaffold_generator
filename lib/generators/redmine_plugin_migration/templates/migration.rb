class <%= @migration_class_name %> < ActiveRecord::Migration
  def self.up
<%- if @table_name && attributes.count > 0 -%>
<% attributes.each do |attribute| -%>
    add_column :<%= @table_name %>, :<%= attribute.name %>, :<%= attribute.type %><%= attribute.inject_options %>
<%- end -%>
<%- end -%>
<%- attributes_with_index.each do |attribute| -%>
    add_index :<%= @table_name %>, :<%= attribute.index_name %><%= attribute.inject_index_options %>
<%- end -%>
  end

  def self.down
<%- if @table_name && attributes.count > 0 -%>
<%- attributes.each do |attribute| -%>
    remove_column :<%= @table_name %>, :<%= attribute.name %>
<%- end -%>
<%- end -%>
  end
end
