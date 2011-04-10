module ActiveRecord
  module ConnectionAdapters

    class TableDefinition
      def initialize(base)
        @columns = []
        @foreign_keys = []
        @base = base
      end

      # added option to specify the referenced table
      def references(*args)
        options = args.extract_options!
        polymorphic = options.delete(:polymorphic)

        options[:referenced_table] = options.delete(:table)
        if options[:referenced_table] && polymorphic
          raise ArgumentError, "not possible to create a foreign key on a polymorphic association"
        end

        args.each do |col|
          column("#{col}_id", :integer, options)
          foreign_key("#{col}_id", options[:referenced_table], 'id') if options[:referenced_table]
          column("#{col}_type", :string, polymorphic.is_a?(Hash) ? polymorphic : options) unless polymorphic.nil?
        end
      end
      alias :belongs_to :references

      def foreign_key(column, referenced_table, referenced_column)
        @foreign_keys << ForeignKeyDefinition.new(column, referenced_table, referenced_column)
      end

      def to_sql
        (@columns.map(&:to_sql) + @foreign_keys.map(&:to_sql)) * ', '
      end
    end

    class ForeignKeyDefinition
      attr_reader :column, :referenced_table, :referenced_column
      def initialize(column, referenced_table, referenced_column)
        @column = column.to_s
        @referenced_table = referenced_table.to_s
        @referenced_column = referenced_column.to_s
      end

      def to_sql
        # NO ACTION and RESTRICT cause its essentially the same, but RESTRICT does not allow the check to be deferred
        "FOREIGN KEY (#{@column}) REFERENCES #{@referenced_table} (#{@referenced_column}) ON DELETE NO ACTION"
      end
    end
  end
end
