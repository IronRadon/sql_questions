class AATable

  def self.find_by_id(id)
    table = self.to_s.downcase + "s"
    hash = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        '#{table}'
      WHERE
        '#{table}'.id = :id
    SQL
    self.new(hash[0])
  end

  def save
    if self.class == Reply
      table = "replies"
    else
      table = self.class.to_s.downcase + "s"
    end

    cols = self.instance_variables.select do |var|
      !self.instance_variable_get(var).nil?
    end
    vals = cols.map {|i| self.instance_variable_get(i)}
    cols = cols.join(", ").gsub(/[:@]/, "")
    question_marks = vals.map{|el| '?'}.join(', ')
    QuestionsDatabase.instance.execute(<<-SQL, *vals)
          INSERT INTO
            #{table} (#{cols})
          VALUES
            (#{question_marks})
        SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

end