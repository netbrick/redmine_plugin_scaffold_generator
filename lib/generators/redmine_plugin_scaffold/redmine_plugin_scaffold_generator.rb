class RedminePluginScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  argument :model, :type => :string
  argument :attributes, :type => :array, :default => [], :banner => "field[:type][:index] field[:type][:index]"

  attr_reader :plugin_path, :plugin_name, :plugin_pretty_name

  def initialize(*args)
    super
    @plugin_name = file_name.underscore
    @plugin_pretty_name = plugin_name.titleize
    @plugin_path = "plugins/#{plugin_name}"

    # Model class
    @model_class = model.camelize

    # Table name
    @table_name = @model_class.tableize

    # Migration filename
    @migration_filename = "create_#{@table_name}"

    # Migration class name
    @migration_class_name = @migration_filename.camelize

    # Controller model before_filter
    @model_bf = model.underscore

    # Controller class
    @controller_class = model.tableize.camelize

    # Controller name
    @controller_filename = "#{model.tableize}"
  end

  def copy_templates
    # Generate model
    template 'model.rb.erb', "#{plugin_path}/app/models/#{model.underscore}.rb"
    template 'unit_test.rb.erb', "#{plugin_path}/test/unit/#{model.underscore}_test.rb"
    migration_filename = "%03i_#{@migration_filename}.rb" % (migration_number + 1)
    template "migration.rb", "#{plugin_path}/db/migrate/#{migration_filename}"

    # Generate controller
    template 'controller.rb.erb', "#{plugin_path}/app/controllers/#{@controller_filename}_controller.rb"
    template 'helper.rb.erb', "#{plugin_path}/app/helpers/#{@controller_filename}_helper.rb"
    template 'functional_test.rb.erb', "#{plugin_path}/test/functional/#{@controller_filename}_controller_test.rb"

    # View template for each action
    template 'new.rb.erb', "#{plugin_path}/app/views/#{@controller_filename}/new.html.erb"
    template 'edit.rb.erb', "#{plugin_path}/app/views/#{@controller_filename}/edit.html.erb"
    template 'form.rb.erb', "#{plugin_path}/app/views/#{@controller_filename}/_form.html.erb"

    %w(index).each do |action|
      path = "#{plugin_path}/app/views/#{@controller_filename}/#{action}.html.erb"
      @action_name = action
      template 'view.html.erb', path
    end
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
