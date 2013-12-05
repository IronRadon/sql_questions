class Reply < AATable

  def self.find_by_id(id)
    hash = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = :id
    SQL
    self.new(hash[0])
  end

  def self.find_by_question_id(q_id)
    QuestionsDatabase.instance.execute(<<-SQL, :question_id => q_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.question_id = :question_id

    SQL
    .map {|r| Reply.new(r)}
  end

  def self.find_by_user_id(u_id)
    QuestionsDatabase.instance.execute(<<-SQL, :id => u_id)
      SELECT
        *
      FROM
        replies
      WHERE
      replies.author_id = :id

    SQL
    .map {|r| Reply.new(r)}
  end

  attr_accessor :id, :question_id, :parent_id, :author_id, :body

  def initialize(options = {})
    @id, @question_id = options["id"], options["question_id"]
    @author_id, @body = options["author_id"], options["body"]
    @parent_id = options["parent_id"]
  end

  def author
    author = QuestionsDatabase.instance.execute(<<-SQL, :id => @author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id

    SQL
    User.new(author[0])
  end

  def question
    question = QuestionsDatabase.instance.execute(<<-SQL, :id => @question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id

    SQL
    Question.new(question[0])
  end

  def parent_reply
    parent = QuestionsDatabase.instance.execute(<<-SQL, :parent_id => @parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :parent_id

    SQL
    return nil if parent.empty?
    Reply.new(parent[0])
  end

  def child_replies
    children = QuestionsDatabase.instance.execute(<<-SQL, :id => @id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_id = :id

    SQL
    .map {|r| Reply.new(r)}
  end

end
