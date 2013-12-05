class Question < AATable

  def self.find_by_author_id(author_id)
    QuestionsDatabase.instance.execute(<<-SQL, :id => author_id)
      SELECT
        *
      FROM
        questions
      WHERE
      questions.author_id = :id

    SQL
    .map {|q| Question.new(q)}

  end

  def self.most_followed(n)
    Question_Follower.most_followed_questions(n)
  end

  def self.most_liked(n)
    Question_Like.most_liked_questions(n)
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(options = {})
    @id, @title = options["id"], options["title"]
    @body, @author_id = options["body"], options["author_id"]
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

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Question_Follower.followers_for_question_id(@id)
  end

  def likers
    Question_Like.likers_for_question_id(@id)
  end

  def num_likes
    Question_Like.num_likes_for_question_id(@id)
  end

end
