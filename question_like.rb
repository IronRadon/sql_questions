class Question_Like < AATable

  def self.likers_for_question_id(q_id)
    QuestionsDatabase.instance.execute(<<-SQL, :question_id => q_id)
      SELECT
        users.*
      FROM
       question_likes
      JOIN users ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = :question_id

    SQL
      .map {|u| User.new(u)}
  end

  def self.num_likes_for_question_id(q_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, :question_id => q_id)
      SELECT
        COUNT(*)
      FROM
       question_likes
      WHERE
        question_likes.question_id = :question_id

    SQL
    num_likes[0].values[0]
  end

  def self.liked_questions_for_user_id(u_id)
    QuestionsDatabase.instance.execute(<<-SQL, :user_id => u_id)
      SELECT
        questions.*
      FROM
       question_likes
      JOIN questions ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = :user_id

    SQL
      .map {|q| Question.new(q)}
  end

  def self.most_liked_questions(n)
    QuestionsDatabase.instance.execute(<<-SQL, :n => n)
      SELECT
        questions.*
      FROM
       question_likes
      JOIN
        questions ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*)
      LIMIT
        :n

    SQL
      .map {|q| Question.new(q)}
  end


  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id, @question_id = options["id"], options["question_id"]
    @user_id = options["user_id"]
  end




end