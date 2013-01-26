class PDF::FDF::FieldLoader

  ##############################################################################
  attr_reader(:fields)

  ##############################################################################
  def initialize (file=nil)
    @fields = []
    merge(file) if file
  end

  ##############################################################################
  def merge (file)
    Array(YAML.load_file(file)).each do |new_field|
      #puts new_field[0]
      #puts new_field[1]
      tmp_field = { new_field[0] => new_field[1],}
      if old_field = find(tmp_field)
        old_field.attributes = tmp_field
      else
        @fields << PDF::FDF::Field.new(tmp_field)
      end
    end

    @fields
  end

  ##############################################################################
  private

  ##############################################################################
  def find (new_field)
    @fields.detect do |old_field|
      match?(old_field, new_field, 'name') ||
        match?(old_field, new_field, 'alias')
    end
  end

  ##############################################################################
  def match? (old_field, new_field, attr)
    new_field[attr] &&
      !new_field[attr].empty? &&
      new_field[attr] == old_field.send(attr)
  end
end
