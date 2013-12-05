require_relative 'aa_table'
class User < AATable

  def self.find_by_name(fname,lname)
    QuestionsDatabase.instance.execute(<<-SQL, :fname => fname, :lname => lname )
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = :fname AND users.lname = :lname

    SQL
    .map {|user| User.new(user)}
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id, @fname, @lname = options["id"], options["fname"], options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def average_karma
    avg_karma = QuestionsDatabase.instance.execute(<<-SQL, :user_id => @id)
      SELECT
        COUNT(*) * 1.0 /
      	(
          SELECT
      	    COUNT(*)
      	  FROM
      	    questions
      	  WHERE
      	    author_id = :user_id
        )
      FROM
      	question_likes
      JOIN
      	questions ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = :user_id

    SQL
    avg_karma[0].values[0]
  end

  def followed_questions
    Question_Follower.followed_questions_for_user_id(@id)
  end

  def liked_questions
    Question_Like.liked_questions_for_user_id(@id)
  end

end