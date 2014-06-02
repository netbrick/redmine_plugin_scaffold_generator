class RedminePluginMigrationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
  argument :migration_name, :type => :string
  argument :model, :type => :string, :default => nil
  argument :attributes, :type => :array, :default => [], :banner => "field[:type][:index] field[:type][:index]"

  attr_reader :plugin_path, :plugin_name, :plugin_pretty_name

  def initialize(*args)
    super
    # Plugin paths
    @plugin_name = file_name.underscore
    @plugin_pretty_name = plugin_name.titleize
    @plugin_path = "plugins/#{plugin_name}"

    # Table name for apply migration
    @table_name = (model) ? model.camelize.tableize : nil

    # Migration name
    @migration_filename = migration_name.underscore

    # Migration class name
    @migration_class_name = @migration_filename.camelize
  end

  def copy_templates
    migration_filename = "%03i_#{@migration_filename}.rb" % (migration_number + 1)
    template "migration.rb", "#{plugin_path}/db/migrate/#{migration_filename}"
  end

  def attributes_with_index
    attributes.select { |a| a.has_index? || (a.reference? && options[:indexes]) }
  end

  def migration_number
    current = Dir.glob("#{plugin_path}/db/migrate/*.rb").map do |file|
      File.basename(file).split("_").first.to_i
    end.max.to_i
  end
end
