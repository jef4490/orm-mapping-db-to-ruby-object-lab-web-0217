require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.name = row[1]
    student.grade = row[2]
    student.id = row[0]
    student
  end

  def self.all
    all = []
    sql = <<-SQL
    SELECT * FROM students
    SQL
    rows = DB[:conn].execute(sql)
    rows.each do |row|
      y = Student.new_from_db(row)
      all << y
    end
    all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.count_all_students_in_grade_9
    all = []
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 9
    SQL
    rows = DB[:conn].execute(sql)
    rows.each do |row|
      y = Student.new_from_db(row)
      all << y
    end
    all
  end

  def self.students_below_12th_grade
    all = []
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    rows = DB[:conn].execute(sql)
    rows.each do |row|
      y = Student.new_from_db(row)
      all << y
    end
    all
  end

  def self.first_x_students_in_grade_10(x)
    all = []
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    ORDER BY id LIMIT ?
    SQL
    rows = DB[:conn].execute(sql, x)
    rows.each do |row|
      y = Student.new_from_db(row)
      all << y
    end
    all
  end

  def self.all_students_in_grade_x(x)
    all = []
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    ORDER BY id
    SQL
    rows = DB[:conn].execute(sql, x)
    rows.each do |row|
      y = Student.new_from_db(row)
      all << y
    end
    all
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    ORDER BY id LIMIT 1
    SQL
    row = DB[:conn].execute(sql)
    # binding.pry
    y = Student.new_from_db(row[0])

  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    where name = (?)
    SQL
    row = DB[:conn].execute(sql, name)
    # find the student in the database given a name
    # return a new instance of the Student class
    Student.new_from_db(row[0])
  end

  # def initialize(name, grade, id = nil)
  #   @name = name
  #   @grade = grade
  #   @id = id
  # end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

end
