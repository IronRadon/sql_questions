class Question_Follower < AATable

  def self.followers_for_question_id(q_id)
    QuestionsDatabase.instance.execute(<<-SQL, :question_id => q_id)
      SELECT
        users.*
      FROM
       question_followers
      JOIN users ON users.id = question_followers.follower_id
      JOIN questions ON questions.id = question_followers.question_id
      WHERE
        questions.id = :question_id

    SQL
      .map {|u| User.new(u)}
  end

  def self.followed_questions_for_user_id(u_id)
    QuestionsDatabase.instance.execute(<<-SQL, :user_id => u_id)
      SELECT
        questions.*
      FROM
       question_followers
      JOIN users ON users.id = question_followers.follower_id
      JOIN questions ON questions.id = question_followers.question_id
      WHERE
        users.id = :user_id

    SQL
      .map {|q| Question.new(q)}
  end

  def self.most_followed_questions(n)
    QuestionsDatabase.instance.execute(<<-SQL, :n => n)
      SELECT
        questions.*
      FROM
       question_followers
      JOIN
        questions ON questions.id = question_followers.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*)
      LIMIT
        :n

    SQL
      .map {|q| Question.new(q)}
  end

  attr_accessor :id, :question_id, :follower_id

  def initialize(options = {})
    @id, @question_id = options["id"], options["question_id"]
    @follower_id = options["follower_id"]
  end

end