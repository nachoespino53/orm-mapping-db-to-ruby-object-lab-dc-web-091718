require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name)[0]
    Student.new_from_db(row)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

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

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQLite3
    SELECT * FROM students LIMIT ?
    SQLite3

    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQLite3
    SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQLite3

    Student.new_from_db(DB[:conn].execute(sql)[0])
  end

  def self.all_students_in_grade_X(grade)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
  end

end
